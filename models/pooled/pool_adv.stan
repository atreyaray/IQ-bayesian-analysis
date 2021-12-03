data{
  int<lower=0> N;  // no of observations * no of observations
  vector[N] x1;     // Decade label
  vector[N] x2;
  vector[N] y;     // IQ label
}

parameters{
  real a;              // intercept
  real b;              // slope of decade
  real c;              // slope of schooling index
  real<lower=0> sigma; // std
}

transformed parameters{
  vector[N] mu;
  mu = a + b*x1 + c*x2;
}

model{
  a ~ normal(0, 10);
  b ~ normal(0, 1);
  c ~ normal(0, 1000);
  
  sigma ~ normal(0,10);
  
  // likelihood
  y ~ normal(mu, sigma);
    
}

generated quantities {
  vector [N] y_pred;
  
  for (i in 1:N)
    y_pred[i] = normal_rng(mu[i], sigma);
    
} 

