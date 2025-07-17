#!/bin/bash

#pop_my_git="https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/static/population.csv"
pop_my_git="https://raw.githubusercontent.com/CITF-Malaysia/citf-public/main/static/population.csv"
my_pop_file="population.csv"
wget=$(which wget)
db_name="covid19_MY"
table_name="my_population"
db_user="gadmin"
datafile=/var/lib/mysql-files/pop_my_load.csv
countfile="pop_cnt.txt"
extra=/etc/mysql_grafana.cnf

# Get record count
function getcount() {
mysql --defaults-extra-file=/etc/mysql_grafana.cnf -N << EOF > $countfile
use covid19_MY
select count(*) from my_population
EOF
}

# Cleanup
function cleanup() {
	if [[ -f "$my_pop_file" ]]; then
		echo "cleaning up ..."
		rm -f $my_pop_file
	fi
}

# Get the file
function get_file() {
	echo "downloading file ...."
	$wget $pop_my_git 2>/dev/null
}

# Extract and Transform
function extract_transform() {
        cat $my_pop_file | sed 's/W.P. //g' > temp.csv
        mv -f temp.csv $my_pop_file
}

# Prepare to update new datat
function new_data {
        rcount=`cat $countfile`
	if [[ $rcount -gt 0 ]]; then 
		rcount2=(`expr $rcount + 1`)
        	rcount3="2,$rcount2"
        	sed "$rcount3"'d' $my_pop_file > $datafile
	else 
		echo "No Data"
		cat $my_pop_file > $datafile
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
           (state,idxs,pop,pop_18,pop_60)
           set
           c_time = now();"
}

# MAIN #
getcount
cleanup
get_file
extract_transform
new_data
load_db
