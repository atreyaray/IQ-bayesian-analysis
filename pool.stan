data{
  int<lower=0> N;  // no of observations * no of observations
  vector[N] x;     // Decade label
  vector[N] y;     // IQ label
}

parameters{
  real a;              // intercept
  real b;              // slope
  real<lower=0> sigma; // std
}

transformed parameters{
  vector[N] mu;
  mu = a + b *x;
}

model{
  // mu ~ normal(0, 10); 
  // sigma ~ gamma(1,1);
  sigma ~ normal(0,10);
  
  // likelihood
  y ~ normal(mu, sigma);
    
}

generated quantities {
  vector [N] y_pred;
  
  for (i in 1:N)
    y_pred[i] = normal_rng(mu[i], sigma);
    
} 

