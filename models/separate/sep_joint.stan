// sep_joint.stan
data {
  int<lower=0> C; // number of continents, 5 for our data
  int<lower=0> N1; // number of observations for continent 1
  int<lower=0> N2; // number of observations for continent 2
  int<lower=0> N3; // number of observations for continent 3
  int<lower=0> N4; // number of observations for continent 4
  int<lower=0> N5; // number of observations for continent 5

  vector[N1] x1; // Decade label for continent 1
  vector[N2] x2; // Decade label for continent 2
  vector[N3] x3; // Decade label for continent 3
  vector[N4] x4; // Decade label for continent 4
  vector[N5] x5; // Decade label for continent 5

  vector[N1] y1; // IQ label for continent 1
  vector[N2] y2; // IQ label for continent 2
  vector[N3] y3; // IQ label for continent 3
  vector[N4] y4; // IQ label for continent 4
  vector[N5] y5; // IQ label for continent 5
  
  vector[N1] z1; // Schooling level label for continent 1
  vector[N2] z2; // Schooling level for continent 2
  vector[N3] z3; // Schooling level for continent 3
  vector[N4] z4; // Schooling level for continent 4
  vector[N5] z5; // Schooling level for continent 5
}

parameters {
  vector[C] a; // intercepts
  vector[C] b; // decade slopes
  vector[C] c; // schooling level slopes

  vector<lower=0>[C] sigma; // stds
}

transformed parameters {
  vector[N1] mu1;
  vector[N2] mu2;
  vector[N3] mu3;
  vector[N4] mu4;
  vector[N5] mu5;

  mu1 = a[1] + b[1] * x1 + c[1] * z1;
  mu2 = a[2] + b[2] * x2 + c[2] * z2;
  mu3 = a[3] + b[3] * x3 + c[3] * z3;
  mu4 = a[4] + b[4] * x4 + c[4] * z4;
  mu5 = a[5] + b[5] * x5 + c[5] * z5;
}

model {
  // priors
  a ~ normal(0, 1);
  b ~ normal(0, 50);
  c ~ normal(0, 100);
  
  // mu ~ normal(0, 10);
  //for (i in 1:C) {
  // this is informative?  sigma[i] ~ inv_chi_square(1);
  //}
  for (i in 1:C) {
    sigma[i] ~ normal(0, 100);
  }
  
  // likelihood
  y1 ~ normal(mu1, sigma[1]); 
  y2 ~ normal(mu2, sigma[2]); 
  y3 ~ normal(mu3, sigma[3]); 
  y4 ~ normal(mu4, sigma[4]); 
  y5 ~ normal(mu5, sigma[5]); 
}

generated quantities {
  real y1pred[N1];
  real y2pred[N2];
  real y3pred[N3];
  real y4pred[N4];
  real y5pred[N5];
  vector[N1+N2+N3+N4+N5] log_lik;

  // posterior predictions
  y1pred = normal_rng(mu1, sigma[1]);
  y2pred = normal_rng(mu2, sigma[2]);
  y3pred = normal_rng(mu3, sigma[3]);
  y4pred = normal_rng(mu4, sigma[4]);
  y5pred = normal_rng(mu5, sigma[5]);
  // pointwise log-likelihood (log_lik)
    for (i in 1:N1) {
    log_lik[i] = normal_lpdf(y1[i] | mu1, sigma[1]);
  }
  
  for (i in 1:N2) {
    log_lik[i+N1] = normal_lpdf(y2[i] | mu2, sigma[2]);
  }
  
  for (i in 1:N3) {
    log_lik[i+N1+N2] = normal_lpdf(y3[i] | mu3, sigma[3]);
  }
  
  for (i in 1:N4) {
    log_lik[i+N1+N2+N3] = normal_lpdf(y4[i] | mu4, sigma[4]);
  }
  for (i in 1:N5) {
    log_lik[i+N1+N2+N3+N4] = normal_lpdf(y5[i] | mu5, sigma[5]);
  }
}
