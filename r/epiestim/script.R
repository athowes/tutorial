install.packages('EpiEstim', repos = c('https://mrc-ide.r-universe.dev', 'https://cloud.r-project.org'))
library(EpiEstim)

devtools::install_github("reconhub/incidence")
library(incidence)

url <- "https://github.com/reconhub/learn/raw/master/static/data/linelist_20140701.xlsx"
download.file(url, destfile = "epiestim/linelist.xlsx")
linelist <- readxl::read_excel("epiestim/linelist.xlsx")

linelist$date_of_onset <- as.Date(linelist$date_of_onset)
evd_incid <- incidence::incidence(linelist$date_of_onset)

plot(evd_incid, xlab = "Date")

# Serial interval (SI)

R_si_parametric <- estimate_R(
  incid = evd_incid,
  method = "parametric_si",
  config = make_config(mean_si = 14.2, std_si = 9.6)
)

plot(R_si_parametric)

devtools::install_github("reconhub/projections")
library(projections)

trunc_date <- max(linelist$date_of_onset) - 7
trunc_linelist <- subset(linelist, linelist$date_of_onset < trunc_date)
evd_incid_trunc <- incidence(trunc_linelist$date_of_onset)

R_si_parametric_recent <- estimate_R(
  incid = evd_incid_trunc, 
  method = "parametric_si",
  config = make_config(mean_si = 14.2, std_si = 9.6,
  # 2 week window that ended a week ago:
  t_start = length(evd_incid_trunc$counts) - 14,
  t_end = length(evd_incid_trunc$counts))
)

plot(R_si_parametric_recent)

proj <- projections::project(
  evd_incid_trunc,
  R = R_si_parametric_recent$R$`Median(R)`,
  si = R_si_parametric_recent$si_distr[-1],
  n_sim = 1000,
  n_days = 30,
  R_fix_within = TRUE
)

plot(evd_incid, xlab = "Date of Symptom Onset") |>
  projections::add_projections(proj, c(0.025, 0.5, 0.975))
