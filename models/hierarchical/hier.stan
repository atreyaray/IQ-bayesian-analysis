data {
  // int<lower=0> N; // Number of observations per continent (different for each one!)
  int<lower=0> C; // Number of continents
  
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
  real<lower=0> sigma;
  vector[C] a; // Intercept
  vector[C] b; // Decade slope

  vector[N1] mu1;
  vector[N2] mu2;
  vector[N3] mu3;
  vector[N4] mu4;
  vector[N5] mu5;
}

model {
  // Priors
  a ~ normal(0, 1);
  b ~ normal(0, 50);

  sigma ~ normal(0, 100); // Shared variance
  
  mu1 ~ normal(a[1] + b[1] * x1, sigma);
  mu2 ~ normal(a[2] + b[2] * x2, sigma);
  mu3 ~ normal(a[3] + b[3] * x3, sigma);
  mu4 ~ normal(a[4] + b[4] * x4, sigma);
  mu5 ~ normal(a[5] + b[5] * x5, sigma);
  // likelihood
  y1 ~ normal(mu1, 1); 
  y2 ~ normal(mu2, 1); 
  y3 ~ normal(mu3, 1); 
  y4 ~ normal(mu4, 1); 
  y5 ~ normal(mu5, 1); 
}
