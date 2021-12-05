data{
  int<lower=0> N;  // no of observations * no of observations
  vector[N] x1;     // Decade label
  vector[N] y;     // IQ label
  int xpred;       // Decade for prediction
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
  
  sigma ~ normal(0,100);
  
  // likelihood
  y ~ normal(mu, sigma);
    
}

generated quantities {
  real ypred;
  vector [N] log_lik;
  vector [N] y_pred;
  
  for (i in 1:N){
    log_lik[i] = normal_lpdf(y[i] | mu[i], sigma);
    y_pred[i] = normal_rng(mu[i], sigma);
  }
  ypred = normal_rng(a+b*xpred, sigma);
    
} 

