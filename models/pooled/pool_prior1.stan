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
  // a's prior changed from N(0, 1)
  // Reason: Even though our data starts from y=0, it's not necessary that the
  // best fit line would also start at y=0.
  a ~ normal(0, 10);
  b ~ normal(0, 50);
  
  sigma ~ normal(0,100);
  
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

