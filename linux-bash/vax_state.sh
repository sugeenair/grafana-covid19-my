#!/bin/bash

rootdir="/root/covid19_MY"
covid_moh_git="https://raw.githubusercontent.com/CITF-Malaysia/citf-public/main/vaccination/vax_state.csv"
my_covid_file="vax_state.csv"
wget=$(which wget)
db_name="covid19_MY"
table_name="my_covid_vax_state"
db_user="gadmin"
datafile=/var/lib/mysql-files/vax_state_load.csv
countfile="my_cnt.txt"
extra=/etc/mysql_grafana.cnf

# Get record count
function getcount() {
	cd $rootdir/log
mysql --defaults-extra-file=/etc/mysql_grafana.cnf -N << EOF > $countfile
use covid19_MY
select count(*) from my_covid_vax_state
EOF
echo "1.Current Record Count: $(cat $countfile)"
}

# Cleanup
function cleanup() {
	cd $rootdir/data
	if [[ -f $my_covid_file ]]; then
		rm -f $my_covid_file
		echo "2. Remove existing datafile - Completed"
	fi
}

# Get the file
function get_file() {
	$wget $covid_moh_git 2>/dev/null
	echo "3. Download latest datafile from MoH Git Hub - Completed"
}

# Extract and Transform
function extract_transform() {
        cat $my_covid_file | sed 's/W.P. //g' > temp.csv
        mv -f temp.csv $my_covid_file
        echo "4. Data Transformation - Completed"
}

# Prepare to update new data
function new_data {
	cd $rootdir/log
        rcount=`cat $countfile`
        if [[ $rcount -gt 0 ]]; then
                rcount2=(`expr $rcount + 1`)
                rcount3="2,$rcount2"
                sed "$rcount3"'d' $rootdir/data/$my_covid_file > $datafile
		echo "5. Updated Record Count: $(wc -l < $countfile)"
        else
		cd $rootdir/data
                echo "No Data"
                cat $my_covid_file > $datafile
        fi
}

# Load into database
function load_db() {
        mysql --defaults-extra-file=$extra -e "use $db_name" -e "
          LOAD DATA INFILE '$datafile'
           INTO TABLE $table_name
           FIELDS TERMINATED BY ','
           OPTIONALLY ENCLOSED BY '\"'
           IGNORE 1 LINES
           (date,state,daily_partial,daily_full,daily_booster,daily_booster2,daily,daily_partial_adol,daily_full_adol,daily_booster_adol,daily_booster2_adol,daily_partial_child,daily_full_child,daily_booster_child,daily_booster2_child,cumul_partial,cumul_full,cumul_booster,cumul_booster2,cumul,cumul_partial_adol,cumul_full_adol,cumul_booster_adol,cumul_booster2_adol,cumul_partial_child,cumul_full_child,cumul_booster_child,cumul_booster2_child,pfizer1,pfizer2,pfizer3,pfizer4,sinovac1,sinovac2,sinovac3,sinovac4,astra1,astra2,astra3,astra4,sinopharm1,sinopharm2,sinopharm3,sinopharm4,cansino,cansino3,cansino4,pending1,pending2,pending3,pending4)
           set
           c_time = now();"
	echo "6. Update New Record/s to Database - Completed"
}


# MAIN #
getcount
cleanup
get_file
extract_transform
new_data
load_db
