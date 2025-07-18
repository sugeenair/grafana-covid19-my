# grafana-covid19-my
This is a home-lab project (that runs on a local vm machine) created to visualize various covid19 data (cases, deaths, hospital utilization and etc) in realtime on Grafana. The data is fetched from MoH Malaysia Github
# Disclaimer
The visualizations are intended strictly for internal use and analytical purposes only and are not meant for public distribution, publication, or external communication. Data can be validated against the official KKM website.
# Architecture
MoH Github <--- linux_box (bash-script) ---> mysql <--- grafana <---> nginx <--- user
# Moh Github source
https://github.com/MoH-Malaysia/covid19-public/tree/main/epidemic
# The setup consists of the following components
1. OS: RHEL 8.6
2. Database: MySQL 8.0+
3. Web Server/Reverse Proxy: NGNIX
4. ETL: bash scripts
5. Grafana: 12+ Enterprise (Free & unlicensed)
# Configuration
1. Install mysql and create database schema
- /mysql/schema.txt
2. Install grafana > setup mysql connection > load JSON Model to the new dashboard
- /grafana/json-model.txt
3. Install nginx and configure reverse proxy to grafana
- nginx/config.txt
4. Setup and execute the bash scripts
5. Access the project via http://<hostname>/grafana
