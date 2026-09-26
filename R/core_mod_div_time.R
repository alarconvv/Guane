guane_rates_tv_fit <- function(tree,models=c('Yule','BD','ExpYule','ExpBD'),sampling=1,survival=TRUE,optimizer='nlminb',maxit=2000,upper=NULL,start_lambda=NULL,start_mu=NULL,beta_start=0,beta_bound=3,tol=1e-8,backend='gslode') {
 original<-tree;tree<-guane_rates_data(tree);age<-max(ape::branching.times(tree))
 if(!length(models)||anyDuplicated(models)||any(!models%in%c('Yule','BD','ExpYule','ExpBD')))stop('Select valid time-comparison models.')
 # Reuse shared scientific/settings validation, and canonical initial rate defaults.
 base<-guane_rates_fit(tree,models='BD',sampling=sampling,survival=survival,optimizer=optimizer,maxit=maxit,upper=upper,start_lambda=start_lambda,start_mu=start_mu,intervals=FALSE,slices=FALSE)
 inp<-base$inputs;upper<-inp$upper;start_lambda<-inp$start_lambda;start_mu<-inp$start_mu
 if(length(beta_bound)!=1||!is.finite(beta_bound)||beta_bound<=0||beta_bound>10||length(beta_start)!=1||!is.finite(beta_start)||abs(beta_start*age)>=beta_bound)stop('Beta start must be within the positive scaled beta bound (at most 10).')
 if(length(tol)!=1||!is.finite(tol)||tol<1e-10||tol>1e-5||length(backend)!=1||!backend%in%c('gslode','deSolve'))stop('Invalid ODE solver settings.')
 fits<-attempts<-curves<-list();warnings<-character()
 for(model in models){
  exponential<-model%in%c('ExpYule','ExpBD');extinction<-model%in%c('BD','ExpBD')
  native<-diversitree::make.bd.t(tree,functions=c(if(exponential)'exp.t' else 'constant.t','constant.t'),sampling.f=sampling,control=list(tol=tol,backend=backend),truncate=FALSE)
  decode<-function(v)c(lambda0=exp(v[1])/age,beta=if(exponential)v[2]/age else 0,mu=if(extinction)exp(tail(v,1))/age else 0)
  args<-function(v){p<-decode(v);if(exponential)unname(p[c(1,2,3)]) else unname(p[c(1,3)])}
  objective<-function(v){
   val<-suppressWarnings(tryCatch(native(args(v),condition.surv=survival),error=function(e)-Inf))
   if(is.finite(val))-val else 1e100
  }
  # Log rates for positive search; a separate exact mu=0 candidate handles the boundary.
  low<-c(log(1e-10),if(exponential)-beta_bound,if(extinction)log(1e-10))
  high<-c(log(upper*age),if(exponential)beta_bound,if(extinction)log(upper*age))
  starts<-lapply(if(exponential)c(beta_start*age,-.5,.5) else 0,function(b)c(log(start_lambda*age),if(exponential)b,if(extinction)log(max(start_mu*age,1e-5))))
  rows<-list();bestv<-NULL;bestll<- -Inf
  for(i in seq_len(length(starts)*if(extinction)2 else 1)){
   zero<-extinction&&i>length(starts);index<-(i-1)%%length(starts)+1
   lower<-if(zero)head(low,-1) else low;upperv<-if(zero)head(high,-1) else high
   objective_free<-if(zero)function(v)objective(c(v,-Inf)) else objective
   start<-if(zero)head(starts[[index]],-1) else starts[[index]]
   start<-pmin(upperv,pmax(lower,start))
   fit<-tryCatch(if(optimizer=='nlminb')stats::nlminb(start,objective_free,lower=lower,upper=upperv,control=list(iter.max=maxit,eval.max=4*maxit,rel.tol=1e-9)) else stats::optim(start,objective_free,method='L-BFGS-B',lower=lower,upper=upperv,control=list(maxit=maxit)),error=identity)
   if(inherits(fit,'error')){rows[[i]]<-data.frame(Model=model,Start=i,Lambda0=NA_real_,Beta=NA_real_,Mu=NA_real_,LogLik=NA_real_,Convergence=99,Message=conditionMessage(fit));next}
   if(zero)fit$par<-c(fit$par,-Inf)
   ll<- -objective(fit$par);p<-decode(fit$par)
   rows[[i]]<-data.frame(Model=model,Start=i,Lambda0=p[1],Beta=p[2],Mu=p[3],LogLik=if(ll> -1e99)ll else NA_real_,Convergence=fit$convergence,Message=if(is.null(fit$message))'' else fit$message)
   if(fit$convergence==0&&is.finite(ll)&&ll> -1e99&&ll>bestll){bestll<-ll;bestv<-fit$par}
  }
  tab<-do.call(rbind,rows);attempts[[model]]<-tab
  if(is.null(bestv)){fits[[model]]<-data.frame(Model=model,Parameters=1+exponential+extinction,Lambda0=NA_real_,Beta=NA_real_,Mu=NA_real_,LogLik=NA_real_,AIC=NA_real_,Converged=FALSE,Boundary=NA,Tolerance_delta=NA_real_);warnings<-c(warnings,'A time model failed; comparison weights are withheld.');next}
  p<-decode(bestv);boundary<-any(abs(bestv-low)<1e-4|abs(bestv-high)<1e-4)||(extinction&&p[3]*age<=1e-5)
  # At the optimum, independently tighten the integration tolerance.
  tighter<-diversitree::make.bd.t(tree,c(if(exponential)'exp.t' else 'constant.t','constant.t'),sampling.f=sampling,control=list(tol=max(tol/10,1e-11),backend=backend))
  ll2<-suppressWarnings(tryCatch(tighter(args(bestv),condition.surv=survival),error=function(e)NA_real_))
  delta<-abs(ll2-bestll)
  if(!is.finite(delta)||delta>1e-4)warnings<-c(warnings,'ODE tolerance sensitivity detected; comparison weights are withheld.')
  if(boundary)warnings<-c(warnings,'A time-model parameter approaches a search bound; refit with reviewed bounds.')
  if(any(tab$Convergence!=0))warnings<-c(warnings,'Some time-model starts failed. Inspect optimizer diagnostics.')
  if(diff(range(tab$LogLik[tab$Convergence==0],na.rm=TRUE))>1e-4)warnings<-c(warnings,'Time-model starts reached different optima.')
  fits[[model]]<-data.frame(Model=model,Parameters=1+exponential+extinction,Lambda0=p[1],Beta=p[2],Mu=p[3],LogLik=bestll,AIC=2*(1+exponential+extinction)-2*bestll,Converged=TRUE,Boundary=boundary,Tolerance_delta=delta)
  time<-seq(age,0,length.out=201);lambda<-p[1]*exp(-p[2]*time)
  curves[[model]]<-data.frame(Model=model,Time_before_present=time,Lambda=lambda,Mu=unname(p[3]),Net=unname(lambda-p[3]))
 }
 comparison<-do.call(rbind,fits);comparison$DeltaAIC<-comparison$Weight<-NA_real_
 if(nrow(comparison)>1&&all(comparison$Converged)&&all(is.finite(comparison$Tolerance_delta)&comparison$Tolerance_delta<=1e-4)){
  comparison$DeltaAIC<-comparison$AIC-min(comparison$AIC);w<-exp(-comparison$DeltaAIC/2);comparison$Weight<-w/sum(w)
 }
 if(!is.null(original$root.edge)&&original$root.edge>0)warnings<-c(warnings,'Supplied stem excluded; this analysis uses a crown-tree likelihood.')
 list(comparison=comparison,attempts=do.call(rbind,attempts),curves=if(length(curves))do.call(rbind,curves) else NULL,warnings=unique(warnings),version=as.character(utils::packageVersion('diversitree')),inputs=list(tree=original,models=models,sampling=sampling,survival=survival,optimizer=optimizer,maxit=maxit,upper=upper,start_lambda=start_lambda,start_mu=start_mu,beta_start=beta_start,beta_bound=beta_bound,tol=tol,backend=backend))
}

guane_rates_tv_plot <- function(result,type='time_rates',model=NULL,parameter='lambda',palette='Guane',lang='en'){
 txt<-function(x)guane_text(x,lang)
 if(type%in%c('time_profile','time_bootstrap','time_robustness')){
  u<-result$uncertainty;if(is.null(u))stop('Run time-model uncertainty first.')
  color<-switch(palette,Grayscale='grey30',Legacy='#02b2ce','#2f7d4f')
  if(type=='time_profile'){
   p<-u$profile;if(is.null(p))stop('Run profile diagnostics first.')
   d<-p$curves[p$curves$Parameter==parameter,,drop=FALSE];if(!nrow(d))stop('Select lambda, beta or mu with a fitted profile.')
   graphics::plot(d$Rate,d$DeltaLogLik,type='l',col=color,lwd=2,xlab=paste(parameter,txt('per branch-length unit')),ylab='Delta logLik',main=paste(u$model,txt('Time-model profile likelihood')),ylim=c(-2*p$cutoff,max(0,d$DeltaLogLik)),xlim=range(d$Rate[d$DeltaLogLik>= -2*p$cutoff]))
   graphics::abline(h=-p$cutoff,lty=2);graphics::mtext(paste(txt('Reference level'),p$level,txt('Boundary coverage is not calibrated.')),side=3,cex=.65)
   return(invisible(d))
  }
  if(type=='time_robustness'){
   d<-u$robustness;if(is.null(d)||!any(is.finite(d$DeltaLogLik)))stop('Run robustness checks first.')
   graphics::barplot(d$DeltaLogLik,names.arg=vapply(d$Scenario,txt,character(1)),col=color,ylim=range(c(-1e-4,1e-4,d$DeltaLogLik),finite=TRUE),ylab='Delta logLik',main=txt('Sensitivity relative to saved fit'),cex.names=.7);graphics::abline(h=c(-1e-4,0,1e-4),lty=c(2,1,2));return(invisible(d))
  }
  b<-u$bootstrap;if(is.null(b)||is.null(b$bands))stop('Bootstrap bands unavailable; inspect refit failures.')
  d<-b$bands[b$bands$Parameter==parameter,,drop=FALSE];if(!nrow(d))stop('Select lambda, mu or net for bootstrap curves.')
  estimate<-result$curves[result$curves$Model==u$model,]
  y<-estimate[[switch(parameter,lambda='Lambda',mu='Mu',net='Net')]]
  graphics::plot(d$Time_before_present,y,type='n',xlim=rev(range(d$Time_before_present)),ylim=range(c(d$Lower,d$Upper,y)),xlab=txt('Time before present (branch-length units)'),ylab=paste(parameter,txt('per branch-length unit')),main=paste(u$model,txt('Conditional bootstrap refits')))
  graphics::polygon(c(d$Time_before_present,rev(d$Time_before_present)),c(d$Lower,rev(d$Upper)),col=grDevices::adjustcolor(color,alpha.f=.2),border=NA)
  graphics::lines(d$Time_before_present,d$Median,lty=2,col=color,lwd=2);graphics::lines(d$Time_before_present,y,lwd=2)
  graphics::legend('topright',legend=c(txt('Saved fit'),txt('Bootstrap median')),lty=c(1,2),col=c('black',color),bty='n')
  graphics::mtext(txt('Pointwise 95% conditional refit envelope; not calibrated coverage.'),side=3,cex=.65)
  return(invisible(d))
 }
 if(type=='time_comparison'){
  d<-result$comparison;if(!all(is.finite(d$DeltaAIC)))stop('Compatible converged and numerically stable fits are required.')
  graphics::barplot(d$DeltaAIC,names.arg=d$Model,col=switch(palette,Grayscale='grey40',Legacy='#02b2ce','#2f7d4f'),ylab='Delta AIC',main=txt('Time-model comparison'));return(invisible(d))
 }
 d<-result$curves;if(is.null(d))stop('No valid model fit. Change settings and run again.')
 colname<-switch(parameter,lambda='Lambda',mu='Mu',net='Net');if(is.null(colname))stop('Invalid graph parameter.')
 models<-unique(d$Model);colors<-if(palette=='Grayscale')rep('grey30',length(models)) else if(palette=='Legacy')grDevices::hcl.colors(length(models),'Dark 3') else grDevices::hcl.colors(length(models),'Dark 2')
 yrange<-range(d[[colname]]);yrange[2]<-yrange[2]+.3*max(diff(yrange),abs(yrange[2])*.1,1e-10)
 graphics::plot(range(d$Time_before_present),yrange,type='n',xlim=rev(range(d$Time_before_present)),xlab=txt('Time before present (branch-length units)'),ylab=paste(parameter,txt('per branch-length unit')),main=txt('Fitted rates through time'))
 for(i in seq_along(models)){z<-d[d$Model==models[i],];graphics::lines(z$Time_before_present,z[[colname]],col=colors[i],lty=i,lwd=2)}
 graphics::legend('topright',legend=models,col=colors,lty=seq_along(models),lwd=2,bty='n',cex=.8)
 graphics::mtext(txt('Fitted trajectories; uncertainty bands are not estimated.'),side=3,line=.25,cex=.7)
 invisible(d)
}

guane_rates_tv_script <- function(result,type='time_rates',model=NULL,parameter='lambda',palette='Guane',lang='en'){
 helpers<-c('guane_ltt','guane_rates_data','guane_rates_fit','guane_rates_tv_fit','guane_rates_tv_profile','guane_rates_tv_cdf','guane_rates_tree_from_ages','guane_rates_tv_bootstrap','guane_rates_tv_robustness','guane_rates_tv_uncertainty','guane_rates_tv_plot','guane_text')
 c('# Guane time-varying crown-tree ML. Time measured backward from the present.',
 '# lambda(t)=lambda0*exp(-beta*t); positive beta means increasing toward present.',
 '# install.packages(c("ape","diversitree","deSolve"))',paste('# diversitree',result$version),
 guane_script_helpers(helpers),
 guane_r_assignment('result',result),guane_r_assignment('settings',list(type=type,model=model,parameter=parameter,palette=palette,lang=lang)),
 '# Optional refit: refitted <- do.call(guane_rates_tv_fit,result$inputs)',
 '# Optional uncertainty replay: replay <- do.call(guane_rates_tv_uncertainty,c(list(result=refitted),result$uncertainty_inputs))',
 '# Bootstrap fixes crown age and sampled tip count; bands condition on successful refits.',
 'opened<-grDevices::dev.cur()==1L','if(opened)grDevices::pdf("guane-time-rates.pdf",width=10,height=7)',
 'do.call(guane_rates_tv_plot,c(list(result=result),settings))','if(opened)grDevices::dev.off()')
}

# Profile the saved time-model likelihood; only nuisance parameters are refitted.
guane_rates_tv_profile <- function(result,model,level=.95,points=31) {
 d<-result$comparison[result$comparison$Model==model,,drop=FALSE]
 if(nrow(d)!=1||!isTRUE(d$Converged)||!is.finite(d$Tolerance_delta)||d$Tolerance_delta>1e-4)stop('Select a converged and numerically stable time model.')
 if(length(level)!=1||!is.finite(level)||level<.8||level>.99||length(points)!=1||!is.finite(points)||points!=floor(points)||points<21||points>101)stop('Invalid profile settings.')
 inp<-result$inputs;tree<-guane_rates_data(inp$tree);age<-max(ape::branching.times(tree))
 expmodel<-model%in%c('ExpYule','ExpBD');ext<-model%in%c('BD','ExpBD')
 native<-diversitree::make.bd.t(tree,c(if(expmodel)'exp.t' else 'constant.t','constant.t'),sampling.f=inp$sampling,control=list(tol=inp$tol,backend=inp$backend))
 lower<-c(1e-10,-inp$beta_bound,0);upper<-c(inp$upper*age,inp$beta_bound,inp$upper*age)
 mle<-unname(c(d$Lambda0,d$Beta,d$Mu)*age);active<-c(1,if(expmodel)2,if(ext)3);cut<-qchisq(level,1)/2
 ll<-function(p){
  args<-if(expmodel)p/age else p[c(1,3)]/age
  z<-suppressWarnings(tryCatch(native(args,condition.surv=inp$survival),error=function(e)-Inf))
  if(is.finite(z))z else -1e100
 }
 curves<-intervals<-list()
 for(j in 1:3){
  parameter<-c('lambda','beta','mu')[j]
  if(!j%in%active){intervals[[parameter]]<-data.frame(Parameter=parameter,Estimate=mle[j]/age,Lower=NA_real_,Upper=NA_real_,Lower_status='Fixed',Upper_status='Fixed',Nuisance_bound=FALSE);next}
  free<-setdiff(active,j)
  evaluate<-function(x){
   fixed<-mle;fixed[j]<-x
   if(!length(free))return(c(LogLik=ll(fixed),Bound=0))
   starts<-list(mle,mle*c(.5,1,.5),c(mle[1],0,0),mle*c(2,1,2))
   best<- -1e100;bound<-FALSE
   for(start in starts){
    objective<-function(v){p<-fixed;p[free]<-v;-ll(p)}
    fit<-tryCatch(nlminb(pmin(upper[free],pmax(lower[free],start[free])),objective,lower=lower[free],upper=upper[free],control=list(iter.max=inp$maxit,eval.max=4*inp$maxit,rel.tol=1e-9)),error=function(e)NULL)
    if(!is.null(fit)&&fit$convergence==0&& -fit$objective>best){
     best<- -fit$objective;bound<-any(abs(fit$par-upper[free])<1e-5 | (free!=3&abs(fit$par-lower[free])<1e-5))
    }
   }
   c(LogLik=best,Bound=as.numeric(bound))
  }
  cache<-new.env(parent=emptyenv());at<-function(x){key<-sprintf('%.17g',x);if(!exists(key,cache,inherits=FALSE))assign(key,evaluate(x),cache);get(key,cache)}
  grid<-sort(unique(c(seq(lower[j],upper[j],length.out=points),seq(lower[j],mle[j],length.out=points),mle[j]+(upper[j]-mle[j])*c(0,10^seq(-5,0,length.out=points)))))
  values<-t(vapply(grid,at,numeric(2)));delta<-values[,1]-d$LogLik
  endpoint<-function(side){
   xs<-if(side==1)sort(grid[grid<=mle[j]],decreasing=TRUE) else sort(grid[grid>=mle[j]])
   f<-function(x)at(x)[1]-d$LogLik+cut;out<-which(vapply(xs,f,numeric(1))<0)
   if(length(out)&&out[1]>1){
    root<-uniroot(f,sort(xs[c(out[1]-1,out[1])]),tol=1e-7)$root
    return(list(value=root/age,status='Threshold crossing',bound=at(root)[2]>0))
   }
   physical<-j==3&&side==1
   list(value=if(physical)0 else NA_real_,status=if(physical)'Physical boundary' else 'Search limit reached',bound=at(tail(xs,1))[2]>0)
  }
  a<-endpoint(1);b<-endpoint(2)
  # Examine all cached values, including root-search evaluations, before accepting endpoints.
  xs<-sort(as.numeric(ls(cache)));vs<-t(vapply(xs,at,numeric(2)));ds<-vs[,1]-d$LogLik
  bad<-max(ds)>1e-4||any(ds< -1e99)||any(!is.finite(ds))
  disconnected<-sum(diff(c(FALSE,ds>= -cut,FALSE))==1)>1
  if(bad||disconnected){a$value<-b$value<-NA_real_;a$status<-b$status<-if(bad)'Profile numerical failure or better optimum' else 'Disconnected support; inspect profile'}
  intervals[[parameter]]<-data.frame(Parameter=parameter,Estimate=mle[j]/age,Lower=a$value,Upper=b$value,Lower_status=a$status,Upper_status=b$status,Nuisance_bound=a$bound||b$bound)
  curves[[parameter]]<-data.frame(Parameter=parameter,Rate=xs/age,DeltaLogLik=ds,Nuisance_bound=vs[,2]>0)
 }
 list(model=model,level=level,cutoff=cut,points=points,intervals=do.call(rbind,intervals),curves=do.call(rbind,curves))
}

# Conditional non-root node-age CDF from lambda(t)*q(t), q'/q =
# -(lambda+mu)+2*lambda*E, E(0)=1-rho. Normalization conditions on age and n.
guane_rates_tv_cdf <- function(lambda,beta,mu,rho,age,grid=4001) {
 if(any(!is.finite(c(lambda,beta,mu,rho,age)))||lambda<=0||mu<0||rho<=0||rho>1||age<=0||grid<501||grid>16001)stop('Invalid bootstrap simulation parameters.')
 times<-sort(unique(c(seq(0,age,length.out=grid),age*10^seq(-9,0,length.out=501))))
 ode<-function(t,y,p){l<-lambda*exp(-beta*t);list(c(mu-(l+mu)*y[1]+l*y[1]^2,-(l+mu)+2*l*y[1],l*exp(y[2])))}
 sol<-deSolve::ode(c(E=1-rho,G=0,C=0),times,ode,NULL,rtol=1e-10,atol=1e-12)
 cdf<-sol[,'C']/tail(sol[,'C'],1)
 if(nrow(sol)!=length(times)||any(!is.finite(cdf))||any(diff(cdf)< -1e-10)||tail(sol[,'C'],1)<=0)stop('Bootstrap CDF integration failed.')
 data.frame(Time=times,Probability=cummax(pmin(1,pmax(0,cdf))))
}

guane_rates_tree_from_ages <- function(ages,labels,crown) {
 n<-length(labels)
 if(length(ages)!=n-2||any(!is.finite(ages))||any(ages<=0|ages>=crown)||anyDuplicated(ages))stop('Invalid bootstrap branching ages.')
 # Uniform ranked topology, with the same node-age likelihood for these models.
 active<-seq_len(n);heights<-numeric(2*n-1);edge<-matrix(0L,2*n-2,2);lens<-numeric(2*n-2);k<-1L
 for(i in seq_len(n-1)){
  node<-2*n-i;time<-c(sort(ages),crown)[i];children<-sample(active,2)
  edge[k:(k+1),]<-cbind(node,children);lens[k:(k+1)]<-time-heights[children];heights[node]<-time
  active<-c(setdiff(active,children),node);k<-k+2L
 }
 tree<-structure(list(edge=edge,edge.length=lens,tip.label=labels,Nnode=n-1L),class='phylo')
 ape::reorder.phylo(tree,'cladewise')
}

guane_rates_tv_bootstrap <- function(result,model,nsim=50,seed=999) {
 d<-result$comparison[result$comparison$Model==model,,drop=FALSE]
 if(nrow(d)!=1||!isTRUE(d$Converged)||!is.finite(d$Tolerance_delta)||d$Tolerance_delta>1e-4)stop('Select a converged and numerically stable time model.')
 if(length(nsim)!=1||!is.finite(nsim)||nsim!=floor(nsim)||nsim<20||nsim>500||length(seed)!=1||!is.finite(seed)||seed!=floor(seed)||seed<0||seed>.Machine$integer.max)stop('Invalid bootstrap settings.')
 inp<-result$inputs;tree<-guane_rates_data(inp$tree);age<-max(ape::branching.times(tree));n<-length(tree$tip.label)
 if(nsim*(n-2)>2e6)stop('Too many simulated branching times; reduce replicates.')
 coarse<-guane_rates_tv_cdf(d$Lambda0,d$Beta,d$Mu,inp$sampling,age,2001)
 cdf<-guane_rates_tv_cdf(d$Lambda0,d$Beta,d$Mu,inp$sampling,age,4001)
 quantile<-function(x,u)approx(x$Probability,x$Time,xout=u,ties='ordered',rule=2)$y
 error<-max(abs(quantile(cdf,seq(.001,.999,length.out=999))-quantile(coarse,seq(.001,.999,length.out=999))))/age
 if(error>1e-4)stop('Bootstrap CDF grid is not accurate enough.')
 oldkind<-RNGkind();had<-exists('.Random.seed',envir=.GlobalEnv,inherits=FALSE);if(had)old<-get('.Random.seed',envir=.GlobalEnv)
 on.exit({do.call(RNGkind,as.list(oldkind));if(had)assign('.Random.seed',old,envir=.GlobalEnv) else if(exists('.Random.seed',envir=.GlobalEnv,inherits=FALSE))rm('.Random.seed',envir=.GlobalEnv)},add=TRUE)
 set.seed(seed,kind='Mersenne-Twister',normal.kind='Inversion',sample.kind='Rejection')
 rows<-draws<-list();curves<-list();times<-seq(age,0,length.out=201)
 for(i in seq_len(nsim)){
  ages<-quantile(cdf,runif(n-2))
  fit<-tryCatch({args<-inp;args$tree<-guane_rates_tree_from_ages(ages,tree$tip.label,age);args$models<-model;do.call(guane_rates_tv_fit,args)},error=identity)
  ok<-!inherits(fit,'error')&&isTRUE(fit$comparison$Converged)&&is.finite(fit$comparison$Tolerance_delta)&&fit$comparison$Tolerance_delta<=1e-4
  p<-if(ok)fit$comparison else NULL
  rows[[i]]<-data.frame(Replicate=i,Success=ok,Lambda0=if(ok)p$Lambda0 else NA_real_,Beta=if(ok)p$Beta else NA_real_,Mu=if(ok)p$Mu else NA_real_,Boundary=if(ok)p$Boundary else NA,LogLik=if(ok)p$LogLik else NA_real_,Tolerance_delta=if(ok)p$Tolerance_delta else NA_real_,Message=if(inherits(fit,'error'))conditionMessage(fit) else paste(fit$warnings,collapse='; '))
  draws[[i]]<-data.frame(Replicate=i,Node_age=ages)
  if(ok)curves[[as.character(i)]]<-data.frame(Replicate=i,Time_before_present=times,Lambda=p$Lambda0*exp(-p$Beta*times),Mu=p$Mu,Net=p$Lambda0*exp(-p$Beta*times)-p$Mu)
 }
 tab<-do.call(rbind,rows);success<-sum(tab$Success)
 # Conditional-on-success summaries are labeled; withhold if fewer than 90% succeed.
 bands<-NULL;allcurves<-if(length(curves))do.call(rbind,curves) else NULL
 if(success>=20&&success/nsim>=.9){
  bands<-do.call(rbind,lapply(c('Lambda','Mu','Net'),function(param){
   m<-vapply(curves,function(x)x[[param]],numeric(length(times)))
   q<-apply(m,1,stats::quantile,c(.025,.5,.975),names=FALSE)
   data.frame(Parameter=tolower(param),Time_before_present=times,Lower=q[1,],Median=q[2,],Upper=q[3,])
  }))
 }
 list(model=model,nsim=nsim,seed=seed,success=success,failed=nsim-success,boundary=sum(tab$Boundary,na.rm=TRUE),cdf=cdf,cdf_error=error,replicates=tab,ages=do.call(rbind,draws),curves=allcurves,bands=bands)
}

guane_rates_tv_robustness <- function(result,model,factor=2) {
 if(length(factor)!=1||!is.finite(factor)||factor<=1||factor>4)stop('Robustness bound multiplier must be greater than one and at most four.')
 d<-result$comparison[result$comparison$Model==model,,drop=FALSE]
 if(nrow(d)!=1||!isTRUE(d$Converged)||!is.finite(d$Tolerance_delta)||d$Tolerance_delta>1e-4)stop('Select a converged and numerically stable time model.')
 inp<-result$inputs;age<-max(ape::branching.times(inp$tree));inp$models<-model
 changes<-list('Alternate starts'=list(start_lambda=inp$start_lambda*.5,start_mu=inp$start_mu*.5,beta_start=-inp$beta_start),
  'Wider bounds'=list(upper=inp$upper*factor,beta_bound=min(10,inp$beta_bound*factor)),
  'Tighter tolerance'=list(tol=max(1e-10,inp$tol/10)))
 do.call(rbind,lapply(names(changes),function(scenario){
  args<-utils::modifyList(inp,changes[[scenario]])
  fit<-tryCatch(do.call(guane_rates_tv_fit,args),error=identity)
  if(inherits(fit,'error'))return(data.frame(Scenario=scenario,Converged=FALSE,LogLik=NA_real_,DeltaLogLik=NA_real_,Lambda0=NA_real_,Beta=NA_real_,Mu=NA_real_,Boundary=NA,Message=conditionMessage(fit)))
  p<-fit$comparison
  data.frame(Scenario=scenario,Converged=p$Converged,LogLik=p$LogLik,DeltaLogLik=p$LogLik-d$LogLik,Lambda0=p$Lambda0,Beta=p$Beta,Mu=p$Mu,Boundary=p$Boundary,Message=paste(fit$warnings,collapse='; '))
 }))
}

guane_rates_tv_uncertainty <- function(result,model='ExpYule',profiles=TRUE,level=.95,points=31,bootstrap=TRUE,nsim=50,seed=999,robustness=TRUE,factor=2) {
 if(!all(vapply(list(profiles,bootstrap,robustness),function(x)is.logical(x)&&length(x)==1&&!is.na(x),logical(1))))stop('Invalid diagnostic settings.')
 u<-list(model=model)
 if(profiles)u$profile<-guane_rates_tv_profile(result,model,level,points)
 if(bootstrap)u$bootstrap<-guane_rates_tv_bootstrap(result,model,nsim,seed)
 if(robustness)u$robustness<-guane_rates_tv_robustness(result,model,factor)
 u$warnings<-character()
 if(!is.null(u$robustness)&&any(u$robustness$DeltaLogLik>1e-4,na.rm=TRUE))u$warnings<-c(u$warnings,'A robustness refit improved the likelihood; review the original fit before interpretation.')
 if(!is.null(u$bootstrap)&&u$bootstrap$failed>0)u$warnings<-c(u$warnings,'Some bootstrap refits failed; summaries condition on successful refits.')
 if(!is.null(u$bootstrap)&&is.null(u$bootstrap$bands))u$warnings<-c(u$warnings,'Bootstrap bands unavailable; inspect refit failures.')
 result$uncertainty<-u
 result$uncertainty_inputs<-list(model=model,profiles=profiles,level=level,points=points,bootstrap=bootstrap,nsim=nsim,seed=seed,robustness=robustness,factor=factor)
 result
}

# Explicit, non-overlapping crown-clade analyses; no joint rate-shift test.
