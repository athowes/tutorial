# https://mc-stan.org/rstanarm/articles/rstanarm.html

library(rstanarm)

data("womensrole", package = "HSAUR3")

womensrole <- womensrole |>
  dplyr::mutate(total = agree + disagree)

womensrole_glm_1 <- stats::glm(
  cbind(agree, disagree) ~ education + gender,
  data = womensrole,
  family = binomial(link = "logit")
)

round(coef(summary(womensrole_glm_1)), 3)

womensrole_bglm_1 <- rstanarm::stan_glm(
  cbind(agree, disagree) ~ education + gender,
  data = womensrole,
  family = binomial(link = "logit"),
  prior = student_t(df = 7, 0, 5),
  prior_intercept = student_t(df = 7, 0, 5),
  cores = 2,
  seed = 12345
)

womensrole_bglm_1

prior_summary(womensrole_bglm_1)

ci95 <- posterior_interval(womensrole_bglm_1, prob = 0.95, pars = "education")

# se is a post-estimation method available from glm, and is also available for rstanarm

cbind(Median = coef(womensrole_bglm_1), MAD_SD = se(womensrole_bglm_1))

residuals(womensrole_bglm_1)
cov2cor(vcov(womensrole_bglm_1))
