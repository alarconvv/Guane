# Validated helpers shared by multiple diversification cards.
# Crown-tree likelihood; supplied stem is explicitly excluded, never recalibrated.
guane_rates_data <- function(tree) {
 guane_ltt(tree)
 if(!ape::is.binary(tree)||length(tree$tip.label)<4)stop('Rates require a rooted binary ultrametric tree with at least four tips.')
 attr(tree,'order')<-NULL;tree<-ape::reorder.phylo(tree,'cladewise');tree$root.edge<-NULL
 tree
}

guane_rates_fit <- function(tree,models=c('Yule','BD'),sampling=1,survival=TRUE,optimizer='nlminb',maxit=2000,upper=NULL,start_lambda=NULL,start_mu=NULL,intervals=TRUE,slices=TRUE) {
 original<-tree;tree<-guane_rates_data(tree);age<-max(ape::branching.times(tree));n<-length(tree$tip.label)
 if(!length(models)||anyDuplicated(models)||any(!models%in%c('Yule','BD')))stop('Choose Yule, birth-death, or both models.')
 if(length(sampling)!=1||!is.numeric(sampling)||!is.finite(sampling)||sampling<=0||sampling>1)stop('Sampling fraction must be greater than zero and at most one.')
 if(!all(vapply(list(survival,intervals,slices),function(z)is.logical(z)&&length(z)==1&&!is.na(z),logical(1))))stop('Invalid rate analysis settings.')
 if(length(optimizer)!=1||is.na(optimizer)||!optimizer%in%c('nlminb','L-BFGS-B')||length(maxit)!=1||!is.finite(maxit)||maxit!=floor(maxit)||maxit<10||maxit>20000)stop('Invalid optimizer settings.')
 if(is.null(upper))upper<-100/age
 positive<-function(z)length(z)==1&&is.numeric(z)&&is.finite(z)&&z>0
 if(!positive(upper)||upper*age<=1e-7||upper*age>1e6)stop('Rate upper bound must be positive and compatible with the tree scale.')
 if(is.null(start_lambda))start_lambda<-(n-2)/sum(tree$edge.length)
 if(!'BD'%in%models)start_mu<-0
 if(is.null(start_mu))start_mu<-start_lambda/2
 if(!positive(start_lambda)||start_lambda>=upper||length(start_mu)!=1||!is.numeric(start_mu)||!is.finite(start_mu)||start_mu<0||start_mu>=upper)stop('Starting rates must lie inside the selected rate bounds.')
 lik<-diversitree::make.bd(tree,sampling.f=sampling,control=list(method='nee'))
 fits<-list();attempts<-list();warnings<-character();profiles<-list();bounds<-c(1e-10,upper*age)
 for(model in models) {
  p<-if(model=='Yule')1L else 2L
  objective<-function(v){if(any(!is.finite(v))||v[1]<=0||any(v<0))return(1e100);pars<-c(v[1],if(p==2)v[2] else 0)/age;ll<-suppressWarnings(tryCatch(lik(pars,condition.surv=survival),error=function(e)-Inf));if(is.finite(ll))-ll else 1e100}
  starts<-if(p==1)matrix(c(start_lambda,.5*start_lambda,2*start_lambda)*age,ncol=1) else rbind(c(start_lambda,start_mu),c(start_lambda,0),c(start_lambda*2,start_lambda),c(start_lambda*.5,start_lambda),c(start_lambda*3,start_lambda*2))*age
  starts[]<-pmin(upper*age*.99,pmax(starts,0));starts<-unique(starts)
  rows<-lapply(seq_len(nrow(starts)),function(i){
   fit<-tryCatch(if(optimizer=='nlminb')stats::nlminb(starts[i,],objective,lower=c(bounds[1],if(p==2)0),upper=rep(bounds[2],p),control=list(iter.max=maxit,eval.max=maxit*4,rel.tol=1e-10)) else stats::optim(starts[i,],objective,method='L-BFGS-B',lower=c(bounds[1],if(p==2)0),upper=rep(bounds[2],p),control=list(maxit=maxit,factr=1e7)),error=identity)
   if(inherits(fit,'error'))return(data.frame(Model=model,Start=i,Lambda=NA_real_,Mu=NA_real_,LogLik=NA_real_,Convergence=99L,Message=conditionMessage(fit)))
   ll<- -objective(fit$par);data.frame(Model=model,Start=i,Lambda=fit$par[1]/age,Mu=if(p==2)fit$par[2]/age else 0,LogLik=if(ll> -1e99)ll else NA_real_,Convergence=fit$convergence,Message=if(is.null(fit$message))'' else fit$message)
  })
  tab<-do.call(rbind,rows);attempts[[model]]<-tab;good<-which(tab$Convergence==0 & is.finite(tab$LogLik))
  if(!length(good)){fits[[model]]<-list(valid=FALSE);warnings<-c(warnings,'A model failed to converge; model comparison weights are withheld.');next}
  best<-tab[good[which.max(tab$LogLik[good])],];est<-c(lambda=best$Lambda,mu=best$Mu);v<-est[seq_len(p)]*age
  boundary<-any(v>=upper*age*(1-1e-5))||v[1]<=1e-7||(p==2&&v[2]<=1e-7)
  if(boundary)warnings<-c(warnings,'A rate lies on an optimization boundary. Curvature intervals are withheld; inspect bounds and extinction identifiability.')
  if(any(tab$Convergence!=0))warnings<-c(warnings,'Some optimizer starts failed; inspect the full optimizer table.')
  if(diff(range(tab$LogLik[good]))>1e-4)warnings<-c(warnings,'Optimizer starts reached different likelihoods; a global optimum is not guaranteed.')
  se<-rep(NA_real_,3);low<-high<-se;vals<-c(est,net=est[1]-est[2])
  if(intervals&&!boundary){
   H<-tryCatch(stats::optimHess(v,objective),error=function(e)NULL)
   if(!is.null(H)&&all(is.finite(H))&&min(eigen(H,symmetric=TRUE,only.values=TRUE)$values)>0&&kappa(H)<1e8){
    V<-solve(H)/age^2
    se<-if(p==1)c(sqrt(V[1,1]),NA_real_,sqrt(V[1,1])) else c(sqrt(diag(V)),sqrt(max(0,sum(V*c(1,-1,-1,1)))))
    low<-vals-1.96*se;high<-vals+1.96*se
    bad<-which(seq_along(low)<=2 & is.finite(low)&low<0);low[bad]<-high[bad]<-NA_real_
   } else warnings<-c(warnings,'Likelihood curvature is unstable; approximate intervals are unavailable.')
  }
  fits[[model]]<-list(valid=TRUE,rates=est,logLik=best$LogLik,boundary=boundary,estimates=data.frame(Model=model,Parameter=c('lambda','mu','net'),Estimate=unname(vals),SE=se,Lower=unname(low),Upper=unname(high),Fixed=c(FALSE,p==1,FALSE)))
  if(slices)for(j in seq_len(p)){
   grid<-sort(unique(c(seq(if(j==1)max(1e-10/age,est[j]*.1) else 0,min(upper,max(est[j]*2.5,est[1]*1.5)),length.out=61),est[j])))
   ll<-vapply(grid,function(z){a<-v;a[j]<-z*age;-objective(a)},numeric(1));ll[ll< -1e99]<-NA_real_
   profiles[[paste(model,j)]]<-data.frame(Model=model,Parameter=c('lambda','mu')[j],Rate=grid,DeltaLogLik=ll-best$LogLik)
  }
 }
 comparison<-do.call(rbind,lapply(models,function(m){f<-fits[[m]];k<-if(m=='Yule')1 else 2;data.frame(Model=m,Parameters=k,LogLik=if(f$valid)f$logLik else NA_real_,AIC=if(f$valid)2*k-2*f$logLik else NA_real_,Converged=f$valid,Boundary=if(f$valid)f$boundary else NA)}))
 comparison$DeltaAIC<-comparison$Weight<-NA_real_
 if(nrow(comparison)>1&&all(comparison$Converged)){d<-comparison$AIC-min(comparison$AIC);comparison$DeltaAIC<-d;comparison$Weight<-exp(-d/2)/sum(exp(-d/2))}
 if(!any(comparison$Converged))warnings<-c(warnings,'No valid model fit. Change settings and run again.')
 if(!is.null(original$root.edge)&&original$root.edge>0)warnings<-c(warnings,'Supplied stem excluded; this analysis uses a crown-tree likelihood.')
 list(tree=tree,comparison=comparison,estimates=do.call(rbind,lapply(fits,`[[`,'estimates')),attempts=do.call(rbind,attempts),slices=if(length(profiles))do.call(rbind,profiles) else NULL,warnings=unique(warnings),age=age,tips=n,version=as.character(utils::packageVersion('diversitree')),inputs=list(tree=original,models=models,sampling=sampling,survival=survival,optimizer=optimizer,maxit=maxit,upper=upper,start_lambda=start_lambda,start_mu=start_mu,intervals=intervals,slices=slices))
}

guane_rates_plot <- function(result,type='rates',model='Yule',parameter='lambda',palette='Guane',lang='en') {
 txt<-function(x)guane_text(x,lang);color<-switch(palette,Grayscale='#404040',Legacy='#02b2ce','#2f7d4f');old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old));graphics::par(mar=c(5,5,3,1))
 if(type=='profile'){
  d<-result$profile$curves
  if(is.null(d))stop('Run profile diagnostics first.')
  d<-d[d$Model==model&d$Parameter==parameter,,drop=FALSE]
  if(!nrow(d))stop('No profile for a fixed or failed parameter.')
  cut<-result$profile$cutoff;focus<-d$Rate[d$DeltaLogLik>= -2*cut]
  if(!length(focus))stop('Profile numerical failure or better optimum')
  graphics::plot(d$Rate,d$DeltaLogLik,type='l',lwd=2,col=color,xlim=range(focus),ylim=c(-2*cut,max(0,d$DeltaLogLik)),xlab=paste(parameter,txt('per branch-length unit')),ylab='Delta logLik',main=txt('Profile likelihood: nuisance rate reoptimized'))
  graphics::abline(h=-cut,lty=2,col='grey40')
  graphics::mtext(paste(txt('Reference level'),result$profile$level,txt('Boundary coverage is not calibrated.')),side=3,line=.25,cex=.65)
  return(invisible(d))
 }
 if(type%in%c('adequacy','discrepancy')){
  a<-result$adequacy
  if(is.null(a))stop('Run simulation diagnostics first.')
  if(type=='discrepancy'){
   d<-unique(a$draws[a$draws$Model==model,c('Simulation','D')]);if(!nrow(d))stop('No simulations for this model.')
   obs<-a$summary$Observed_D[a$summary$Model==model]
   graphics::hist(d$D,breaks='FD',col=color,ylab=txt('Frequency'),xlim=range(c(d$D,obs)),xlab='D',main=txt('Conditional discrepancy reference'))
   graphics::abline(v=obs,lwd=2,lty=2)
   graphics::legend('topright',legend=txt('Observed'),lty=2,bty='n');return(invisible(d))
  }
  d<-a$envelope[a$envelope$Model==model,,drop=FALSE];if(!nrow(d))stop('No simulations for this model.')
  graphics::plot(d$Time,d$Observed,type='n',ylim=range(c(d$Observed,d$Lower,d$Upper)),xlab=txt('Time since crown (branch-length units)'),ylab=txt('Lineages'),main=paste(model,txt('Conditional LTT check')))
  x<-rep(d$Time,each=2)[-1];low<-head(rep(d$Lower,each=2),-1);high<-head(rep(d$Upper,each=2),-1)
  graphics::polygon(c(x,rev(x)),c(low,rev(high)),col=grDevices::adjustcolor(color,alpha.f=.2),border=NA)
  graphics::lines(d$Time,d$Median,type='s',col=color,lty=2,lwd=2)
  graphics::lines(d$Time,d$Observed,type='s',col='black',lwd=2)
  graphics::legend('topleft',legend=c(txt('Observed'),txt('Simulation median'),txt('Pointwise 95% simulation envelope')),lty=c(1,2,NA),pch=c(NA,NA,15),col=c('black',color,grDevices::adjustcolor(color,alpha.f=.4)),bty='n',cex=.65)
  return(invisible(d))
 }
 if(type=='comparison'){
  d<-result$comparison;if(!all(is.finite(d$DeltaAIC)))stop('At least two converged compatible fits are required for comparison.')
  graphics::barplot(d$DeltaAIC,names.arg=d$Model,col=color,ylab='Delta AIC',main=txt('Constant-rate model comparison'));return(invisible(d))
 }
 if(type=='slice'){
  d<-result$slices;if(is.null(d))stop('No saved likelihood slice for this selection.');d<-d[d$Model==model&d$Parameter==parameter,,drop=FALSE];if(is.null(d)||!nrow(d))stop('No saved likelihood slice for this selection.')
  graphics::plot(d$Rate,d$DeltaLogLik,type='l',lwd=2,col=color,xlab=paste(parameter,txt('per branch-length unit')),ylab='Delta logLik',main=txt('Likelihood slice: other rate held fixed'));graphics::abline(h=0,lty=2,col='grey50');return(invisible(d))
 }
 d<-result$estimates;if(is.null(d)||!nrow(d))stop('No valid model fit. Change settings and run again.')
 lim<-range(c(0,d$Estimate,d$Lower,d$Upper),finite=TRUE)
 graphics::plot(seq_len(nrow(d)),d$Estimate,ylim=lim,xaxt='n',xlab='',ylab=txt('Rates per branch-length unit'),pch=19,col=color,main=txt('Constant-rate estimates'))
 graphics::mtext(txt('Bars: approximate 95% curvature intervals where available'),side=3,line=.25,cex=.7)
 graphics::axis(1,at=seq_len(nrow(d)),labels=paste(d$Model,d$Parameter),las=2,cex.axis=.75)
 good<-is.finite(d$Lower)&is.finite(d$Upper);graphics::segments(which(good),d$Lower[good],which(good),d$Upper[good],col=color,lwd=2);graphics::abline(h=0,lty=3,col='grey60')
 invisible(d)
}

guane_rates_profile <- function(result,level=.95,points=61) {
 if(length(level)!=1||!is.finite(level)||level<.8||level>.99||length(points)!=1||!is.finite(points)||points!=floor(points)||points<21||points>201)stop('Invalid profile settings.')
 age<-result$age;lo<-1e-10;hi<-result$inputs$upper*age
 lik<-diversitree::make.bd(result$tree,sampling.f=result$inputs$sampling,control=list(method='nee'))
 cutoff<-stats::qchisq(level,1)/2;curves<-intervals<-list()
 for(model in result$comparison$Model[result$comparison$Converged]){
  e<-result$estimates;est<-e$Estimate[e$Model==model][1:2]*age
  best<-result$comparison$LogLik[result$comparison$Model==model]
  ll<-function(x){z<-suppressWarnings(tryCatch(lik(x/age,condition.surv=result$inputs$survival),error=function(e)-Inf));if(is.finite(z))z else -1e100}
  for(parameter in c('lambda','mu','net')){
   key<-paste(model,parameter)
   if(model=='Yule'&&parameter=='mu'){
    intervals[[key]]<-data.frame(Model=model,Parameter=parameter,Estimate=0,Lower=NA_real_,Upper=NA_real_,Lower_status='Fixed',Upper_status='Fixed',Reference_level=level,Nuisance_bound=FALSE)
    next
   }
   mle<-switch(parameter,lambda=est[1],mu=est[2],net=est[1]-est[2])
   domain<-if(model=='Yule'||parameter=='lambda')c(lo,hi) else if(parameter=='mu')c(0,hi) else c(lo-hi,hi)
   evaluate<-function(z){
    if(model=='Yule')return(c(LogLik=ll(c(z,0)),Nuisance=NA_real_,Bound=0))
    if(parameter=='lambda'){range<-c(0,hi);pars<-function(q)c(z,q)}
    if(parameter=='mu'){range<-c(lo,hi);pars<-function(q)c(q,z)}
    if(parameter=='net'){range<-c(max(0,lo-z),min(hi,hi-z));pars<-function(q)c(q+z,q)}
    fun<-function(q)ll(pars(q))
    # Grid-bracket all observed local maxima, including both endpoints.
    grid<-sort(unique(c(seq(range[1],range[2],length.out=13),pmin(range[2],pmax(range[1],c(est,10^seq(-9,log10(hi),length.out=13)))))))
    values<-vapply(grid,fun,numeric(1));candidates<-grid
    if(length(grid)>2)for(k in 2:(length(grid)-1))if(values[k]>=values[k-1]&&values[k]>=values[k+1]){
     opt<-stats::optimize(fun,c(grid[k-1],grid[k+1]),maximum=TRUE,tol=1e-8)
     candidates<-c(candidates,opt$maximum)
    }
    values<-vapply(candidates,fun,numeric(1));q<-candidates[which.max(values)];rates<-pars(q)
    c(LogLik=max(values),Nuisance=q/age,Bound=as.numeric(any(rates>=hi*(1-1e-6))))
   }
   grid<-sort(unique(c(seq(domain[1],domain[2],length.out=points),mle,
     domain[1]+(mle-domain[1])*seq(0,1,length.out=points),
     mle+(domain[2]-mle)*c(0,10^seq(-6,0,length.out=points)))))
   cache<-new.env(parent=emptyenv())
   at<-function(z){k<-sprintf('%.17g',z);if(!exists(k,cache,inherits=FALSE))assign(k,evaluate(z),cache);get(k,cache)}
   vals<-t(vapply(grid,at,numeric(3)));delta<-vals[,'LogLik']-best
   # A higher profile value invalidates the fitted reference rather than inventing a CI.
   valid<-all(is.finite(delta)&delta> -1e99)&&max(delta)<1e-4
   endpoint<-function(side){
    edge<-if(side=='lower')domain[1] else domain[2]
    seqz<-if(side=='lower')sort(grid[grid<=mle],decreasing=TRUE) else sort(grid[grid>=mle])
    f<-function(z)unname(at(z)['LogLik']-best+cutoff)
    outside<-which(vapply(seqz,f,numeric(1))<0)
    if(length(outside)&&outside[1]>1){
     j<-outside[1];root<-stats::uniroot(f,sort(seqz[c(j-1,j)]),tol=1e-8)$root
     return(list(value=root/age,status='Threshold crossing',bound=at(root)['Bound']>0))
    }
    physical<-parameter=='mu'&&side=='lower'
    list(value=if(physical)0 else NA_real_,status=if(physical)'Physical boundary' else 'Search limit reached',bound=at(edge)['Bound']>0)
   }
   a<-endpoint('lower');b<-endpoint('upper')
   support<-delta>= -cutoff
   disconnected<-sum(diff(c(FALSE,support,FALSE))==1)>1
   if(disconnected){a$value<-b$value<-NA_real_;a$status<-b$status<-'Disconnected support; inspect profile'}
   if(!valid){a$value<-b$value<-NA_real_;a$status<-b$status<-'Profile numerical failure or better optimum'}
   intervals[[key]]<-data.frame(Model=model,Parameter=parameter,Estimate=mle/age,Lower=a$value,Upper=b$value,Lower_status=a$status,Upper_status=b$status,Reference_level=level,Nuisance_bound=a$bound||b$bound)
   # Save evaluated crossings too, so exported curves reproduce the reported endpoints.
   allx<-sort(as.numeric(ls(cache)));allv<-t(vapply(allx,at,numeric(3)))
   curves[[key]]<-data.frame(Model=model,Parameter=parameter,Rate=allx/age,DeltaLogLik=allv[,'LogLik']-best,Nuisance=allv[,'Nuisance'],Nuisance_bound=as.logical(allv[,'Bound']))
  }
 }
 list(intervals=if(length(intervals))do.call(rbind,intervals) else NULL,curves=if(length(curves))do.call(rbind,curves) else NULL,level=level,cutoff=cutoff,points=points)
}

# Conditional reconstructed branching-time distribution (Stadler 2009;
# Stadler & Steel 2019). Conditional on crown age and sampled tip count.
# rho is independent Bernoulli sampling of extant species.
guane_rates_clade_catalog <- function(tree) {
 tree<-guane_rates_data(tree);n<-length(tree$tip.label)
 nodes<-seq.int(n+1,n+tree$Nnode);desc<-vector('list',n+tree$Nnode)
 for(i in seq_len(n))desc[[i]]<-i
 post<-ape::reorder.phylo(tree,'postorder')$edge
 for(i in seq_len(nrow(post)))desc[[post[i,1]]]<-c(desc[[post[i,1]]],desc[[post[i,2]]])
 ages<-ape::branching.times(tree)
 table<-data.frame(Node=nodes,Tips=vapply(desc[nodes],length,integer(1)),Crown_age=unname(ages[as.character(nodes)]))
 table<-table[table$Tips>=4,,drop=FALSE]
 table$Label<-if(is.null(tree$node.label))'' else tree$node.label[table$Node-n]
 table$Label[is.na(table$Label)]<-''
 table$First_tip<-vapply(desc[table$Node],function(x)tree$tip.label[x[1]],character(1))
 list(tree=tree,table=table,descendants=desc)
}

