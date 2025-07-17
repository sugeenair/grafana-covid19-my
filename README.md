# grafana-covid19-my
This is a home-lab project (that runs on a local vm machine) created to visualize various covid19 data (cases, deaths, hospital utilization and etc) in realtime on Grafana. The data is fetched from MoH Malaysia Github
# Disclaimer
The visualizations are intended strictly for internal use and analytical purposes only and are not meant for public distribution, publication, or external communication. Data can be validated against the official KKM website.
# Architecture
MoH Github <--- linux_box (bash-script) ---> mysql <--- grafana <---> nginx <--- user
# Moh Github source
https://github.com/MoH-Malaysia/covid19-public/tree/main/epidemic
# The setup consits of the following components:
1. OS: RHEL 8.6
2. Database: MySQL 8.0+
# Database schema
Refer to /mysql/schema.txt
3. NGNIX
# NGINX config
Refer to /nginx/config.txt
4. Bash script
# Bash scripts
Refer to /linux-bash/*.sh
5. Grafana 12+ Enterprise (Free & unlicensed)
# Grafana JSON Model
Refer to /grafana/json-model.txt. 

