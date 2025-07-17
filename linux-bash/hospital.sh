#!/bin/bash

rootdir="/root/covid19_MY"
covid_moh_git="https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/hospital.csv"
my_covid_file="hospital.csv"
wget=$(which wget)
db_name="covid19_MY"
table_name="my_covid_hospital"
db_user="gadmin"
datafile=/var/lib/mysql-files/hospital.csv
countfile="hospital_cnt.txt"
extra=/etc/mysql_grafana.cnf

# Get record count
function getcount() {
cd $rootdir/log
mysql --defaults-extra-file=/etc/mysql_grafana.cnf -N << EOF > $countfile
use covid19_MY
select count(*) from my_covid_hospital
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
                echo "5. Updated Record Count: $(wc -l < $datafile)"
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
           (date,state,beds,beds_covid,beds_noncrit,admitted_pui,admitted_covid,admitted_total,discharged_pui,discharged_covid,discharged_total,hosp_covid,hosp_pui,hosp_noncovid)
           set c_time = now();"
	echo "6. Update New Record/s to Database - Completed"
}

# MAIN #
getcount
cleanup
get_file
extract_transform
new_data
load_db
