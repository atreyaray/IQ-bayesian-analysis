// sep_simple.stan
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
}

parameters {
  vector[C] a; // intercepts
  vector[C] b; // slopes
  vector[C] sigma; // stds
}

transformed parameters {
  vector[N1] mu1;
  vector[N2] mu2;
  vector[N3] mu3;
  vector[N4] mu4;
  vector[N5] mu5;

  mu1 = a[1] + b[1] * x1;
  mu2 = a[2] + b[2] * x2;
  mu3 = a[3] + b[3] * x3;
  mu4 = a[4] + b[4] * x4;
  mu5 = a[5] + b[5] * x5;
}

model {
  // priors
  // a ~ normal(0, 10);
  // b ~ normal(0, 1)
  for (c in 1:C) {
    sigma[c] ~ inv_chi_square(1);
  }
  
  // likelihood
  y1 ~ normal(mu1, sigma[1]); 
  y2 ~ normal(mu2, sigma[2]); 
  y3 ~ normal(mu3, sigma[3]); 
  y4 ~ normal(mu4, sigma[4]); 
  y5 ~ normal(mu5, sigma[5]); 
}
