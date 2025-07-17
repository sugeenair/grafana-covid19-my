# grafana-covid19-my
Data Visualization of Covid19-MY with Grafana.
# The objective
This is a home-lab project created to visualize covid19 data in realtime on Grafana. The data is sourced from MoH Malaysia Github.
# The setup consits of the following components:
1. OS: RHEL 8.6
2. Database: MySQL
3. NGNIX
4. Bash script
5. Grafana

# Database schema
CREATE TABLE my_covid_cases(
    id INT NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL,
    cases_new INT NOT NULL,
    cases_import INT NOT NULL,
    cases_recovered INT NOT NULL,
    cases_active INT NOT NULL,
    cases_cluster INT NOT NULL,
    cases_unvax INT NOT NULL,
    cases_pvax INT NOT NULL,
    cases_fvax INT NOT NULL,
    cases_boost INT NOT NULL,
    cases_child INT NOT NULL,
    cases_adolescent INT NOT NULL,
    cases_adult INT NOT NULL,
    cases_elderly INT NOT NULL,
    cases_0_4 INT NOT NULL,
    cases_5_11 INT NOT NULL,
    cases_12_17 INT NOT NULL,
    cases_18_29 INT NOT NULL,
    cases_30_39 INT NOT NULL,
    cases_40_49 INT NOT NULL,
    cases_50_59 INT NOT NULL,
    cases_60_69 INT NOT NULL,
    cases_70_79 INT NOT NULL,
    cases_80 INT NOT NULL,
    cluster_import INT NULL,
    cluster_religious INT NULL,
    cluster_community INT NULL,
    cluster_highRisk INT NULL,
    cluster_education INT NULL,
    cluster_detentionCentre INT NULL,
    cluster_workplace INT NULL,
    c_time DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
);

CREATE TABLE my_covid_clusters(
    id INT NOT NULL AUTO_INCREMENT,
    cluster VARCHAR(255) NOT NULL,
    state varchar(255) NOT NULL,
    district TEXT NOT NULL,
    date_announced VARCHAR(255) NOT NULL,
    date_last_onset VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status VARCHAR(10) NOT NULL,
    cases_new INT NULL,
    cases_total INT NULL,
    cases_active INT NULL,
    tests INT NULL,
    icu INT NULL,
    deaths INT NULL,
    recovered INT NULL,
    summary_bm TEXT NULL,
    summary_en TEXT NULL,
    c_time DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
);

CREATE TABLE my_covid_hospital(
    id INT NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL,
    state VARCHAR(15) NOT NULL,
    beds INT NOT NULL,
    beds_covid INT NOT NULL,
    beds_noncrit INT NOT NULL,
    admitted_pui INT NOT NULL,
    admitted_covid INT NOT NULL,
    admitted_total INT NOT NULL,
    discharged_pui INT NOT NULL,
    discharged_covid INT NOT NULL,
    discharged_total INT NOT NULL,
    hosp_covid INT NOT NULL,
    hosp_pui INT NOT NULL,
    hosp_noncovid INT NOT NULL,
    c_time DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
);

CREATE TABLE my_covid_deaths(
    id INT NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL,
    deaths_new INT NOT NULL,
    deaths_new_dod INT NOT NULL,
    deaths_bid INT NOT NULL,
    deaths_bid_dod INT NOT NULL,
    deaths_unvax INT NOT NULL,
    deaths_pvax INT NOT NULL,
    deaths_fvax INT NOT NULL,
    deaths_boost INT NOT NULL,
    deaths_tat INT NOT NULL,
    c_time DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
);

CREATE TABLE my_covid_pkrc(
    id INT NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL,
    state VARCHAR(15) NOT NULL,
    beds INT NOT NULL,
    admitted_pui INT NOT NULL,
    admitted_covid INT NOT NULL,
    admitted_total INT NOT NULL,
    discharge_pui INT NOT NULL,
    discharge_covid INT NOT NULL,
    discharge_total INT NOT NULL,
    pkrc_covid INT NOT NULL,
    pkrc_pui INT NOT NULL,
    pkrc_noncovid INT NOT NULL,
    c_time DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
);

CREATE TABLE my_covid_icu(
    id INT NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL,
    state VARCHAR(15) NOT NULL,
    beds_icu INT NOT NULL,
    beds_icu_rep INT NOT NULL,
    beds_icu_total INT NOT NULL,
    beds_icu_covid INT NOT NULL,
    vent INT NOT NULL,
    vent_port INT NOT NULL,
    icu_covid INT NOT NULL,
    icu_pui INT NOT NULL,
    icu_noncovid INT NOT NULL,
    vent_covid INT NOT NULL,
    vent_pui INT NOT NULL,
    vent_noncovid INT NOT NULL,
    vent_used INT NOT NULL,
    vent_port_used INT NOT NULL,
    c_time DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
);

CREATE TABLE my_covid_tests(
    id INT NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL,
    rtk_ag INT NOT NULL,
    pcr INT NOT NULL,
    c_time DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
);

CREATE TABLE my_covid_vax(
    id INT NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL,
    daily_partial INT NOT NULL,
    daily_full INT NOT NULL,
    daily_booster INT NOT NULL,
    daily_booster2 INT NOT NULL,
    daily INT NOT NULL,
    daily_partial_adol INT NOT NULL,
    daily_full_adol INT NOT NULL,
    daily_booster_adol INT NOT NULL,
    daily_booster2_adol INT NOT NULL,
    daily_partial_child INT NOT NULL,
    daily_full_child INT NOT NULL,
    daily_booster_child INT NOT NULL,
    daily_booster2_child INT NOT NULL,
    cumul_partial INT NOT NULL,
    cumul_full INT NOT NULL,
    cumul_booster INT NOT NULL,
    cumul_booster2 INT NOT NULL,
    cumul INT NOT NULL,
    cumul_partial_adol INT NOT NULL,
    cumul_full_adol INT NOT NULL,
    cumul_booster_adol INT NOT NULL,
    cumul_booster2_adol INT NOT NULL,
    cumul_partial_child INT NOT NULL,
    cumul_full_child INT NOT NULL,
    cumul_booster_child INT NOT NULL,
    cumul_booster2_child INT NOT NULL,
    pfizer1 INT NOT NULL,
    pfizer2 INT NOT NULL,
    pfizer3 INT NOT NULL,
    pfizer4 INT NOT NULL,
    sinovac1 INT NOT NULL,
    sinovac2 INT NOT NULL,
    sinovac3 INT NOT NULL,
    sinovac4 INT NOT NULL,
    astra1 INT NOT NULL,
    astra2 INT NOT NULL,
    astra3 INT NOT NULL,
    astra4 INT NOT NULL,
    sinopharm1 INT NOT NULL,
    sinopharm2 INT NOT NULL,
    sinopharm3 INT NOT NULL,
    sinopharm4 INT NOT NULL,
    cansino INT NOT NULL,
    cansino3 INT NOT NULL,
    cansino4 INT NOT NULL,
    pending1 INT NOT NULL,
    pending2 INT NOT NULL,
    pending3 INT NOT NULL,
    pending4 INT NOT NULL,
    c_time DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
);

CREATE TABLE my_population(
    id INT NOT NULL AUTO_INCREMENT,
    state VARCHAR(15) NOT NULL,
    idxs INT NOT NULL,
    pop INT NOT NULL,
    pop_18 INT NOT NULL,
    pop_60 INT NOT NULL,
    pop_12 INT NOT NULL,
    pop_5 INT NOT NULL,
    c_time DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
);
