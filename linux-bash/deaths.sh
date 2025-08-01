#!/bin/bash

rootdir="/root/covid19_MY"
covid_moh_git="https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/deaths_malaysia.csv"
my_covid_file="deaths_malaysia.csv"
wget=$(which wget)
db_name="covid19_MY"
table_name="my_covid_deaths"
db_user="gadmin"
datafile=/var/lib/mysql-files/deaths_malaysia_load.csv
countfile="death_cnt.txt"
extra=/etc/mysql_grafana.cnf

# Get record count
function getcount() {
cd $rootdir/log
mysql --defaults-extra-file=/etc/mysql_grafana.cnf -N << EOF > $countfile
use covid19_MY
select count(*) from my_covid_deaths
EOF
echo "1.Current Record Count: $(cat $countfile)"
}

# Cleanup
function cleanup() {
	cd $rootdir/data
	if [[ -f "$my_covid_file" ]]; then
		rm -f $my_covid_file
		echo "2. Remove existing datafile - Completed"

	fi
}

# Get the file
function get_file() {
	$wget $covid_moh_git 2>/dev/null
	echo "3. Download latest datafile from MoH Git Hub - Completed"
}

# Prepare to update new data
function new_data {
	cd $rootdir/log
        rcount=`cat $countfile`
        if [[ $rcount -gt 0 ]]; then
                rcount2=(`expr $rcount + 1`)
                rcount3="2,$rcount2"
                sed "$rcount3"'d' $rootdir/data/$my_covid_file > $datafile
		echo "4. New Record/s Count: $(wc -l < $datafile)"
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
           (date,deaths_new,deaths_bid,deaths_new_dod,deaths_bid_dod,deaths_unvax,deaths_pvax,deaths_fvax,deaths_boost,deaths_tat)
           set
           c_time = now();"
	echo "5. Update New Record/s to Database - Completed"
}

# MAIN #
getcount
cleanup
get_file
new_data
load_db
