guane_rates_script <- function(result,type='rates',model='Yule',parameter='lambda',palette='Guane',lang='en') {
 helpers<-c('guane_ltt','guane_rates_data','guane_rates_fit','guane_rates_profile','guane_rates_time','guane_rates_adequacy','guane_rates_diagnose','guane_rates_plot','guane_text')
 c('# Guane constant-rate crown-tree ML. Independent random extant-taxon sampling.',
 '# install.packages(c("ape","diversitree"))',paste0('# diversitree ',result$version),
 '# Intervals: approximate normal curvature intervals; unavailable at boundaries/unstable curvature.',
 '# Likelihood slices hold the other rate fixed; they are not profile likelihood intervals.',
 guane_script_helpers(helpers),
 guane_r_assignment('result',result),guane_r_assignment('settings',list(type=type,model=model,parameter=parameter,palette=palette,lang=lang)),
 '# Optional refit: refitted <- do.call(guane_rates_fit,result$inputs)',
 '# Optional diagnostic replay: replay <- do.call(guane_rates_diagnose,c(list(result=refitted),result$diagnostic_inputs))',
 '# Profile chi-square(1) reference is asymptotic, not boundary-calibrated.',
 '# Simulation envelopes condition on crown age and sampled n; pointwise, not simultaneous.',
 '# Reference tail fraction is a plug-in descriptive check, not a calibrated p-value.',
 'opened <- grDevices::dev.cur()==1L','if(opened) grDevices::pdf("guane-rates.pdf",width=10,height=7)',
 'do.call(guane_rates_plot,c(list(result=result),settings))','if(opened) grDevices::dev.off()','sessionInfo()')
}

# Profile the saved crown likelihood within its original rate bounds.
# Reference cutoffs are asymptotic chi-square(1), not boundary-calibrated coverage.
guane_rates_time <- function(x,lambda,mu,rho,age,inverse=FALSE) {
 if(any(!is.finite(c(lambda,mu,rho,age)))||lambda<=0||mu<0||rho<=0||rho>1||age<=0||any(!is.finite(x)))stop('Invalid simulation parameters.')
 r<-lambda-mu;b<-lambda*rho
 H<-function(t){
  if(r==0)return(t/(1+b*t))
  if(r>0){a<- -expm1(-r*t);return(a/(r*exp(-r*t)+b*a))}
  a<-expm1(r*t)/r;a/(1+b*a)
 }
 h<-H(age)
 if(!inverse){if(any(x<0|x>age))stop('Invalid simulation times.');return(H(x)/h)}
 if(any(x<0|x>1))stop('Invalid simulation probabilities.')
 y<-x*h
 t<-if(r==0)y/(1-b*y) else log1p(r*y/(1-b*y))/r
 t[x==0]<-0;t[x==1]<-age
 if(any(!is.finite(t))||any(t<0|t>age*(1+1e-8)))stop('Simulation numerical failure.')
 pmin(age,t)
}

guane_rates_adequacy <- function(result,nsim=200,seed=999) {
 if(length(nsim)!=1||!is.finite(nsim)||nsim!=floor(nsim)||nsim<20||nsim>2000||length(seed)!=1||!is.finite(seed)||seed!=floor(seed)||seed<0||seed>.Machine$integer.max)stop('Invalid simulation settings.')
 if(nsim*(result$tips-2)>2e6)stop('Too many simulated branching times; reduce replicates.')
 oldkind<-RNGkind()
 had<-exists('.Random.seed',envir=.GlobalEnv,inherits=FALSE);if(had)old<-get('.Random.seed',envir=.GlobalEnv)
 on.exit({do.call(RNGkind,as.list(oldkind));if(had)assign('.Random.seed',old,envir=.GlobalEnv) else if(exists('.Random.seed',envir=.GlobalEnv,inherits=FALSE))rm('.Random.seed',envir=.GlobalEnv)},add=TRUE)
 set.seed(seed,kind='Mersenne-Twister',normal.kind='Inversion',sample.kind='Rejection')
 n<-result$tips;age<-result$age;times<-sort(ape::branching.times(result$tree),decreasing=TRUE)[-1]
 grid<-sort(unique(c(seq(0,age,length.out=101),age-times)))
 count<-function(t)2+findInterval(grid,sort(age-t))
 observed<-count(times)
 ks<-function(u){u<-sort(u);k<-length(u);max(seq_len(k)/k-u,u-(seq_len(k)-1)/k)}
 envelopes<-summaries<-draws<-list()
 for(model in result$comparison$Model[result$comparison$Converged]){
  e<-result$estimates;est<-e$Estimate[e$Model==model][1:2]
  args<-list(lambda=est[1],mu=est[2],rho=result$inputs$sampling,age=age)
  sim<-matrix(do.call(guane_rates_time,c(list(x=stats::runif(nsim*(n-2)),inverse=TRUE),args)),nrow=n-2)
  curves<-apply(sim,2,count)
  qs<-apply(curves,1,stats::quantile,probs=c(.025,.5,.975),names=FALSE,type=1)
  du<-apply(sim,2,function(t)ks(do.call(guane_rates_time,c(list(x=t),args))))
  obs<-ks(do.call(guane_rates_time,c(list(x=times),args)))
  envelopes[[model]]<-data.frame(Model=model,Time=grid,Observed=observed,Lower=qs[1,],Median=qs[2,],Upper=qs[3,])
  summaries[[model]]<-data.frame(Model=model,Simulations=nsim,Observed_D=obs,Reference_tail_fraction=(1+sum(du>=obs))/(nsim+1))
  draws[[model]]<-data.frame(Model=model,Simulation=rep(seq_len(nsim),each=n-2),Node_age=as.vector(sim),D=rep(du,each=n-2))
 }
 list(envelope=if(length(envelopes))do.call(rbind,envelopes) else NULL,summary=if(length(summaries))do.call(rbind,summaries) else NULL,draws=if(length(draws))do.call(rbind,draws) else NULL,nsim=nsim,seed=seed)
}

guane_rates_diagnose <- function(result,profiles=TRUE,level=.95,points=61,simulate=TRUE,nsim=200,seed=999) {
 if(!any(result$comparison$Converged))stop('No valid model fit. Change settings and run again.')
 if(!is.logical(profiles)||length(profiles)!=1||is.na(profiles)||!is.logical(simulate)||length(simulate)!=1||is.na(simulate))stop('Invalid diagnostic settings.')
 result$profile<-if(profiles)guane_rates_profile(result,level,points) else NULL
 result$adequacy<-if(simulate)guane_rates_adequacy(result,nsim,seed) else NULL
 result$diagnostic_inputs<-list(profiles=profiles,level=level,points=points,simulate=simulate,nsim=nsim,seed=seed)
 result
}

# Time before present, lambda(t)=lambda0*exp(-beta*t).
# All candidate likelihoods use the same ODE backend and crown conditioning.
