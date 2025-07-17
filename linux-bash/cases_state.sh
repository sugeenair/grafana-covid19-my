#!/bin/bash

rootdir="/root/covid19_MY"
covid_moh_git="https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/cases_state.csv"
my_covid_file="cases_state.csv"
wget=$(which wget)
db_name="covid19_MY"
table_name="my_covid_cases_state"
db_user="gadmin"
datafile=/var/lib/mysql-files/cases_state_load.csv
countfile="state_cnt.txt"
extra=/etc/mysql_grafana.cnf

# Get record count
function getcount() {
	cd $rootdir/log
mysql --defaults-extra-file=/etc/mysql_grafana.cnf -N << EOF > $countfile
use covid19_MY
select count(*) from my_covid_cases_state
EOF
#echo "1. Current Record Count: $(cat $countfile)"
}

# Cleanup
function cleanup() {
	cd $rootdir/data
	if [[ -f "$my_covid_file" ]]; then
		rm -f $my_covid_file
#		echo "2. Remove existing datafile - Completed"
	fi
}

# Get the file
function get_file() {
	$wget $covid_moh_git 2>/dev/null
#	echo "3. Download latest datafile from MoH Git Hub - Completed"
}

# Extract and Transform
function extract_transform() {
        #cat $my_covid_file | sed '/^2020/d' | sed 's/W.P. //g' > temp.csv
        cat $my_covid_file | sed 's/W.P. //g' > temp.csv
        mv -f temp.csv $my_covid_file
#	echo "4. Data Transformation - Completed"
}

# Prepare to update new data
function new_data {
	cd $rootdir/log
        rcount=`cat $countfile`
        if [[ $rcount -gt 0 ]]; then
                rcount2=(`expr $rcount + 1`)
                rcount3="2,$rcount2"
                sed "$rcount3"'d' $rootdir/data/$my_covid_file > $datafile
#               echo "5. Updated Record Count: $(wc -l < $countfile)"
        else
		cd $rootdir/data
#               echo "No Data"
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
           (date,state,cases_new,cases_import,cases_recovered,cases_active,cases_cluster,cases_unvax,cases_pvax,cases_fvax,cases_boost,cases_child,cases_adolescent,cases_adult,cases_elderly,cases_0_4,cases_5_11,cases_12_17,cases_18_29,cases_30_39,cases_40_49,cases_50_59,cases_60_69,cases_70_79,cases_80)
           set
           #cases_cluster = NULLIF(@cases_cluster,''),
           #cases_pvax = NULLIF(@cases_pvax,''),
           #cases_fvax = NULLIF(@cases_fvax,''),
           #cases_child = NULLIF(@cases_child,''),
           #cases_adolescent = NULLIF(@cases_adolescent,''),
           #cases_adult = NULLIF(@cases_adult,''),
           #cases_elderly = NULLIF(@cases_elderly,''),
           c_time = now();"
#	echo "6. Update New Record/s to Database - Completed"
}

# MAIN #
getcount
cleanup
get_file
extract_transform
new_data
load_db
