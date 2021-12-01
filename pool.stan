data{
  int<lower=0> N;  // no of observations
  int<lower=0> J;  // no of continents
  vector[J] y[N];  // data matrix
}

parameters{
  real mu;             // mean
  real<lower=0> sigma; // std
}

model{
  mu ~ normal(0, 10); 
  sigma ~ gamma(1,1);
  
  // likelihood
  for (j in 1:J)
    y[,j] ~ normal(mu, sigma);
    
}

generated quantities {
  vector [J] y_pred;
  
  for (i in 1:J)
    y_pred[i] = normal_rng(mu, sigma);
    
} 

