data{
  int<lower=0> N;  // no of continents * no of observations
  vector[N] x1;    // Decade label
  vector[N] x2;    // Schooling Index
  vector[N] y;     // IQ label
  real xpred_decade; // Prediction Decade
  real xpred_schooling [3]; // Schooling index with 5/10/15% increase
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
  a ~ normal(0, 1);
  b ~ normal(0, 50);
  c ~ normal(0, 100);
  
  sigma ~ normal(0,100);
  
  // likelihood
  y ~ normal(mu, sigma);
    
}

generated quantities {
  real ypred[3];
  vector[N] y_pred;
  vector [N] log_lik;
  
  for (i in 1:N){
    y_pred[i] = normal_rng(mu[i], sigma);
    log_lik[i] = normal_lpdf(y[i] | mu[i], sigma);
  }
  for (i in 1:3){
   ypred[i] = normal_rng(a+b*xpred_decade + c*xpred_schooling[i], sigma); 
  }
} 


