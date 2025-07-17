# grafana-covid19-my
This is a home-lab project (that runs on a local vm machine) created to visualize various covid19 data (cases, deaths, hospital utilization and etc) in realtime on Grafana. The data is fetched from MoH Malaysia Github
# Disclaimer
The visualizations are intended strictly for internal use and analytical purposes only and are not meant for public distribution, publication, or external communication. Data can be validated against the official KKM website.
# Architecture
MoH Github <--- linux_box (bash-script) ---> mysql <--- grafana <---> nginx <--- user
# The setup consits of the following components:
1. OS: RHEL
2. Database: MySQL 8.0+
3. NGNIX
4. Bash script
5. Grafana 12+ Enterprise (Free & unlicensed)
# Database schema
Refer to /mysql/schema.txt
# NGINX config
Refer to /nginx/config.txt
# Bash scripts
Refer to /bash-script/*.sh
# Grafana
Refer to /grafana/json-model.txt. 

