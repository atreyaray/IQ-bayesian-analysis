data{
  int<lower=0> N;  // no of observations * no of observations
  vector[N] x1;     // Decade label
  vector[N] y;     // IQ label
}

parameters{
  real a;              // intercept
  real b;              // slope of decade
  real<lower=0> sigma; // std
}

transformed parameters{
  vector[N] mu;
  mu = a + b*x1;
}

model{
  a ~ normal(0, 1);
  b ~ normal(0, 50);
  
  // Sigma's prior changed from N(0, 100)
  // Reason: Inv chi square is generally used as the prior for an
  // unknown variance of the normal distribution.
  // It is a conjugate prior, thus is it computationally convenient
  // and aslo satisfies some minimal prior requirements for a variance,
  // like not having a positive density for negative values.
  sigma ~ inv_chi_square(1);
  
  // likelihood
  y ~ normal(mu, sigma);
    
}

generated quantities {
  vector [N] y_pred;
  vector [N] log_lik;
  
  for (i in 1:N){
    y_pred[i] = normal_rng(mu[i], sigma);
    log_lik[i] = normal_lpdf(y[i] | mu[i], sigma);
  }
    
} 

