# Retain native optimizer evidence in a private call environment. The installed
# namespace and native likelihood are never modified. Fail closed on API drift.
guane_hidden_native <- function(..., verify=TRUE, maxeval=100000) {
 guane_hidden_require()
 if(!identical(as.character(utils::packageVersion('hisse')),'2.1.11'))stop('Optimizer capture requires the validated hisse version 2.1.11.')
 if(length(verify)!=1||!is.logical(verify)||is.na(verify)||length(maxeval)!=1||!is.finite(maxeval)||maxeval<10||maxeval>1000000||maxeval!=floor(maxeval))stop('Invalid optimizer verification settings.')
 native<-hisse::hisse;scope<-new.env(parent=environment(native));record<-NULL
 scope$nloptr<-function(x0,eval_f,lb,ub,opts,...) {
  args<-list(...);objective<-function(p)do.call(eval_f,c(list(p),args))
  opts$maxeval<-maxeval
  out<-nloptr::nloptr(x0=x0,eval_f=objective,lb=lb,ub=ub,opts=opts)
  check<-tryCatch(objective(out$solution),error=function(e)NA_real_)
  alt<-if(verify)tryCatch(stats::nlminb(out$solution,objective,lower=lb,upper=ub,control=list(iter.max=maxeval,eval.max=maxeval,rel.tol=opts$ftol_rel)),error=identity) else NULL
  alt_ok<-!is.null(alt)&&!inherits(alt,'error')&&identical(alt$convergence,0L)&&is.finite(alt$objective)&&alt$objective<1e30
  agreement<-alt_ok&&is.finite(check)&&abs(alt$objective-check)<=1e-4
  record<<-list(status=out$status,message=out$message,evaluations=out$iterations,
   converged=out$status%in%1:4&&is.finite(check)&&check<1e30&&abs(check-out$objective)<=1e-6,
   reevaluated=-check,verification_requested=verify,verified=verify&&agreement,
   verification_status=if(is.null(alt))NA_integer_ else if(inherits(alt,'error'))99L else alt$convergence,
   verification_logLik=if(is.null(alt)||inherits(alt,'error'))NA_real_ else -alt$objective,
   verification_message=if(is.null(alt))'Not requested' else if(inherits(alt,'error'))conditionMessage(alt) else alt$message,
   verification_parameters=if(is.null(alt)||inherits(alt,'error'))NULL else alt$par)
  out
 }
 environment(native)<-scope
 answer<-native(...)
 if(is.null(record))stop('HiSSE optimizer capture failed; no verified status is available.')
 answer$guane_optimizer<-record;answer
}

# Binary observed traits with latent diversification categories, using the public HiSSE API.
core_mod_sse_hidden <- function() list(implemented=TRUE)
guane_hidden_require <- function() {
 if(!requireNamespace('hisse',quietly=TRUE))stop('Install the hisse R package to run hidden-state models.')
}
guane_hidden_models <- function() c('BiSSE (HiSSE backend)','HiSSE','CID-2','CID-4','Custom')
guane_hidden_spec <- function(model,eps_mode='Shared',custom_classes=2,turnover_text='',eps_text='',transition_text='') {
 guane_hidden_require()
 if(length(model)!=1||!model%in%guane_hidden_models()||length(eps_mode)!=1||!eps_mode%in%c('Shared','By diversification class','Zero extinction')||length(custom_classes)!=1||!custom_classes%in%c(2,4))stop('Invalid hidden-state model settings.')
 k<-switch(model,`BiSSE (HiSSE backend)`=1,HiSSE=2,`CID-2`=2,`CID-4`=4,Custom=custom_classes)
 tr<-hisse::TransMatMakerHiSSE(hidden.traits=k-1,make.null=startsWith(model,'CID'))
 turnover<-switch(model,`BiSSE (HiSSE backend)`=1:2,HiSSE=1:4,`CID-2`=rep(1:2,each=2),`CID-4`=rep(1:4,each=2),Custom=seq_len(2*k))
 eps<-switch(eps_mode,Shared=rep(1,2*k),`By diversification class`=turnover,`Zero extinction`=rep(0,2*k))
 indices<-function(text,default,zero=FALSE){
  if(length(text)!=1||is.na(text))stop('Invalid parameter index vector.')
  if(!nzchar(trimws(text)))return(default)
  v<-suppressWarnings(as.numeric(strsplit(text,',',fixed=TRUE)[[1]]));u<-sort(unique(v[v>0]))
  if(length(v)!=2*k||any(!is.finite(v))||any(v!=floor(v))||any(v<if(zero)0 else 1)||length(u)&&!identical(u,as.numeric(seq_len(max(u)))))stop('Use consecutive parameter indices; zero is allowed only for extinction fractions.')
  v
 }
 if(model=='Custom'){
  turnover<-indices(turnover_text,turnover);eps<-indices(eps_text,eps,TRUE)
  if(length(transition_text)!=1||is.na(transition_text))stop('Invalid hidden-state transition matrix.')
  if(nzchar(trimws(transition_text))){
   x<-tryCatch(as.matrix(utils::read.csv(text=transition_text,header=FALSE,check.names=FALSE)),error=function(e)stop('Invalid hidden-state transition matrix.'))
   suppressWarnings(storage.mode(x)<-'numeric')
   if(!identical(dim(x),dim(tr))||anyNA(x)||any(!is.finite(x))||any(x<0|x!=floor(x))||any(x[is.na(tr)]!=0))stop('Only single observed-state or hidden-class changes are supported; use zero elsewhere.')
   u<-sort(unique(x[x>0]));if(!length(u)||!identical(u,as.numeric(seq_len(max(u)))))stop('Transition indices must be consecutive positive integers; zero forbids a transition.')
   dimnames(x)<-dimnames(tr);x[is.na(tr)]<-NA;tr<-x
  }
 }
 list(classes=k,turnover=turnover,eps=eps,trans=tr,states=if(k==1)c('0A','1A') else as.vector(rbind(paste0('0',LETTERS[seq_len(k)]),paste0('1',LETTERS[seq_len(k)]))))
}
guane_hidden_fit <- function(tree,traits,taxon,trait,state0,models=c('HiSSE','CID-2','CID-4'),eps_mode='Shared',sampling=c(1,1),survival=TRUE,root_type='madfitz',root_mode='Likelihood',root0=.5,starts=2,seed=999,sann=FALSE,sann_its=1000,tolerance=1e-8,turnover_start=.5,eps_start=.2,transition_start=.1,turnover_upper=100,eps_upper=3,transition_upper=100,ode_eps=0,custom_classes=2,turnover_text='',eps_text='',transition_text='',verify=TRUE,maxeval=100000) {
 inputs<-as.list(environment());guane_hidden_require()
 d<-tryCatch(guane_bisse_data(tree,traits,taxon,trait,state0),error=function(e)stop(sub('BiSSE','hidden-state analysis',conditionMessage(e),fixed=TRUE)))
 scalar<-function(x)is.numeric(x)&&length(x)==1&&is.finite(x)
 if(!length(models)||anyNA(models)||anyDuplicated(models)||any(!models%in%guane_hidden_models()))stop('Select supported hidden-state models.')
 if(length(sampling)!=2||any(!is.finite(sampling))||any(sampling<=0|sampling>1)||!all(vapply(list(survival,sann),function(x)is.logical(x)&&length(x)==1&&!is.na(x),logical(1)))||length(root_type)!=1||!root_type%in%c('madfitz','herr_als')||length(root_mode)!=1||!root_mode%in%c('Likelihood','Given')||!scalar(root0)||root0<0||root0>1)stop('Invalid hidden-state sampling or root settings.')
 if(!scalar(starts)||!starts%in%1:8||!scalar(seed)||seed<0||seed>2147480000||seed!=floor(seed)||!scalar(sann_its)||sann_its<10||sann_its>100000||sann_its!=floor(sann_its)||!scalar(tolerance)||tolerance<1e-12||tolerance>1e-3||!scalar(ode_eps)||ode_eps<0||ode_eps>1e-3)stop('Invalid hidden-state optimizer settings.')
 initial<-c(turnover_start,eps_start,transition_start);upper<-c(turnover_upper,eps_upper,transition_upper)
 if(length(initial)!=3||length(upper)!=3||any(!is.finite(c(initial,upper)))||any(initial<=exp(-20))||any(upper<=initial)||any(upper>1e6))stop('Starts must be positive and below finite upper bounds.')
 # Native HiSSE changes thread counts and can use RNG even without annealing.
 had<-exists('.Random.seed',envir=.GlobalEnv,inherits=FALSE);saved<-if(had)get('.Random.seed',.GlobalEnv) else NULL;kind<-RNGkind();threads<-data.table::getDTthreads()
 on.exit({do.call(RNGkind,as.list(kind));if(had)assign('.Random.seed',saved,.GlobalEnv) else if(exists('.Random.seed',.GlobalEnv,inherits=FALSE))rm('.Random.seed',envir=.GlobalEnv);data.table::setDTthreads(threads)})
 specs<-setNames(lapply(models,guane_hidden_spec,eps_mode,custom_classes,turnover_text,eps_text,transition_text),models)
 fits<-list();rows<-list();estimates<-list();transitions<-list();warnings<-c('Optimizer status is retained. Weights require converged repeatable interior fits and agreement with an independent optimizer.','Compare only models refitted in this card with the same data and likelihood settings. Do not combine AIC values from other cards.','Hidden classes are latent rate categories, not identified biological traits. No uncertainty intervals or calibrated likelihood-ratio tests are provided.')
 if(length(d$states)<100||min(d$mapping$Count)<10)warnings<-c(warnings,'Few taxa or imbalanced states can give weakly identified rates. This is a screening warning, not a sufficiency threshold.')
 if(!is.null(tree$root.edge)&&tree$root.edge>0)warnings<-c(warnings,'Supplied stem excluded; this analysis uses a crown-tree likelihood.')
 for(model in models){
  spec<-specs[[model]];answers<-list()
  for(i in seq_len(starts)){
   set.seed(seed+i-1);start<-pmin(upper*.95,pmax(exp(-19),initial*if(i==1)1 else exp(sin(seq_len(3)*i)*log(4))))
   notes<-character();output<-capture.output(ans<-tryCatch(withCallingHandlers(guane_hidden_native(d$tree,data.frame(species=names(d$states),state=unname(d$states)),f=sampling,turnover=spec$turnover,eps=spec$eps,hidden.states=spec$classes>1,trans.rate=spec$trans,condition.on.survival=survival,root.type=root_type,root.p=if(root_mode=='Given')rep(c(root0,1-root0)/spec$classes,spec$classes) else NULL,sann=sann,sann.its=sann_its,bounded.search=TRUE,max.tol=tolerance,starting.vals=start,turnover.upper=upper[1],eps.upper=upper[2],trans.upper=upper[3],ode.eps=ode_eps,dt.threads=1,verify=verify,maxeval=maxeval),warning=function(w){notes<<-c(notes,conditionMessage(w));invokeRestart('muffleWarning')}),error=identity))
   ok<-!inherits(ans,'error')&&length(ans$loglik)==1&&is.finite(ans$loglik)&&ans$loglik> -1e30&&all(is.finite(ans$solution))
   answers[i]<-list(if(ok)ans else NULL)
   # Preserve failed starts in a separate row, without inventing optimizer convergence.
   rows[[length(rows)+1]]<-data.frame(Model=model,Start=i,LogLik=if(ok)ans$loglik else NA_real_,Finite=ok,Convergence=if(ok)ans$guane_optimizer$status else NA_integer_,Converged=ok&&isTRUE(ans$guane_optimizer$converged),Verified=ok&&isTRUE(ans$guane_optimizer$verified),VerificationLogLik=if(ok)ans$guane_optimizer$verification_logLik else NA_real_,VerificationStatus=if(ok)ans$guane_optimizer$verification_status else NA_integer_,NativeIterations=if(ok)ans$guane_optimizer$evaluations else NA_integer_,OptimizerMessage=if(ok)ans$guane_optimizer$message else '',VerificationMessage=if(ok)ans$guane_optimizer$verification_message else '',Message=paste(c(if(inherits(ans,'error'))conditionMessage(ans) else notes),collapse=' | '),Initial=paste(signif(start,8),collapse=', '),Seed=seed+i-1)
  }
  valid<-which(vapply(answers,function(a)!is.null(a),logical(1)))
  if(!length(valid)){fits[[model]]<-list(valid=FALSE);next}
  converged<-valid[vapply(answers[valid],function(x)isTRUE(x$guane_optimizer$converged),logical(1))]
  pool<-if(length(converged))converged else valid
  a<-answers[[pool[which.max(vapply(answers[pool],`[[`,numeric(1),'loglik'))]]];np<-length(a$starting.vals)
  free<-vapply(seq_len(np),function(j)a$solution[which(a$index.par==j)[1]],numeric(1))
  boundary<-any(log(free)<=a$lower.bounds+1e-5|log(free)>=a$upper.bounds-1e-5)
  spread<-diff(range(vapply(answers[valid],`[[`,numeric(1),'loglik')))
  fits[[model]]<-list(valid=TRUE,native=a,k=np,boundary=boundary,spread=spread,logLik=a$loglik,converged=isTRUE(a$guane_optimizer$converged),verified=isTRUE(a$guane_optimizer$verified),all_converged=length(converged)==length(answers),better_failed=any(vapply(answers[valid],function(x)x$loglik>a$loglik+1e-4,logical(1))))
  t<-a$solution[paste0('turnover',spec$states)];e<-a$solution[paste0('eps',spec$states)];lambda<-t/(1+e)
  estimates[[model]]<-data.frame(Model=model,State=spec$states,Turnover=unname(t),ExtinctionFraction=unname(e),Speciation=unname(lambda),Extinction=unname(lambda*e),NetDiversification=unname(lambda*(1-e)))
  q<-expand.grid(Source=spec$states,Destination=spec$states,stringsAsFactors=FALSE);q<-q[q$Source!=q$Destination,,drop=FALSE];q$Rate<-unname(a$solution[paste0('q',q$Source,q$Destination)]);q$Rate[is.na(q$Rate)]<-0;q$Model<-model;transitions[[model]]<-q
  if(boundary)warnings<-c(warnings,'A hidden-state parameter reached a bound. Inspect identifiability and bounds.')
  if(spread>1e-4)warnings<-c(warnings,'Hidden-state starts disagree. Increase search effort before interpreting model differences.')
 }
 if(isTRUE(fits$HiSSE$valid)&&isTRUE(fits[['CID-2']]$valid)&&fits[['CID-2']]$logLik>fits$HiSSE$logLik+1e-4)warnings<-c(warnings,'HiSSE fits worse than its CID-2 submodel. Increase search effort before interpretation.')
 comparison<-do.call(rbind,lapply(models,function(m){f<-fits[[m]];data.frame(Model=m,Parameters=if(f$valid)f$k else NA_integer_,LogLik=if(f$valid)f$logLik else NA_real_,AIC=if(f$valid)-2*f$logLik+2*f$k else NA_real_,Finite=f$valid,Boundary=if(f$valid)f$boundary else NA,StartSpread=if(f$valid)f$spread else NA_real_,Converged=isTRUE(f$converged),Verified=isTRUE(f$verified),Weight=NA_real_)}))
 comparison$DeltaAIC<-if(all(comparison$Finite))comparison$AIC-min(comparison$AIC) else NA_real_
 eligible<-length(models)>1&&starts>=2&&all(vapply(fits,function(f)isTRUE(f$converged)&&isTRUE(f$verified)&&isTRUE(f$all_converged)&&!isTRUE(f$boundary)&&!isTRUE(f$better_failed)&&f$spread<=1e-4,logical(1)))
 if(isTRUE(fits$HiSSE$valid)&&isTRUE(fits[['CID-2']]$valid)&&fits[['CID-2']]$logLik>fits$HiSSE$logLik+1e-4)eligible<-FALSE
 # Duplicate constraints must not receive multiple shares of model weight.
 signatures<-vapply(specs,function(s)paste(c(s$classes,s$turnover,s$eps,as.vector(s$trans)),collapse=','),character(1))
 if(anyDuplicated(signatures))eligible<-FALSE
 if(eligible){w<-exp(-comparison$DeltaAIC/2);comparison$Weight<-w/sum(w)} else warnings<-c(warnings,'Model weights withheld: inspect termination, verification, starts, boundaries and duplicate constraints.')
 c(d,list(specs=specs,fits=fits,estimates=do.call(rbind,estimates),transitions=do.call(rbind,transitions),comparison=comparison,attempts=do.call(rbind,rows),warnings=unique(warnings),inputs=inputs,trait=trait,version=as.character(utils::packageVersion('hisse'))))
}
guane_hidden_settings <- function(type='rates',model='HiSSE',palette='Guane',labels=TRUE,label_size=.7,width=10,height=7,lang='en') {
 if(length(type)!=1||!type%in%c('rates','tree','transitions','comparison','starts','verification'))stop('Select a supported hidden-state graph.')
 s<-guane_bisse_settings(type,model,'',palette,labels,label_size,width,height,lang);s$parameter<-NULL;s
}
guane_hidden_plot <- function(result,settings=guane_hidden_settings()) {
 if(identical(settings$type,'verification'))return(guane_sse_verification_plot(result,settings))
 s<-do.call(guane_hidden_settings,settings);txt<-function(x)guane_text(x,s$lang)
 if(s$type=='comparison'){z<-s;z$parameter<-'';return(guane_bisse_plot(result,z))}
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old));graphics::par(mar=c(6,5,3,2))
 cols<-switch(s$palette,Grayscale=c('#222222','#888888'),Legacy=c('#02b2ce','#e52920'),c('#26734f','#bd6731'))
 if(s$type=='tree'){
  ape::plot.phylo(result$tree,show.tip.label=s$labels,underscore=TRUE,cex=s$label_size,label.offset=max(ape::branching.times(result$tree))*.02,main=result$trait,no.margin=FALSE);ape::tiplabels(pch=21,bg=cols[result$states[result$tree$tip.label]+1],cex=.8);graphics::legend('topleft',legend=result$mapping$State,pch=21,pt.bg=cols,bty='n',cex=s$label_size);graphics::mtext(txt('Observed tip states; no ancestral reconstruction'),side=1,line=4.5,cex=.7)
 } else if(s$type=='starts'){
  x<-result$attempts[result$attempts$Model==s$model,];if(!any(x$Finite))stop('No finite hidden-state fit. Inspect diagnostics.')
  graphics::plot(x$Start,x$LogLik,pch=19,col=cols[1],xlab=txt('Optimizer start'),ylab='logLik',main=s$model);graphics::mtext(txt('Inspect termination and independent optimizer agreement in Diagnostics'),side=1,line=4.5,cex=.7)
 } else {
  f<-result$fits[[s$model]];if(!isTRUE(f$valid))stop('No finite hidden-state fit. Inspect diagnostics.')
  if(s$type=='rates'){
   x<-result$estimates[result$estimates$Model==s$model,];graphics::barplot(rbind(x$Speciation,x$Extinction),beside=TRUE,names.arg=x$State,col=cols,ylab=txt('Rate per branch-length unit'),main=s$model,ylim=c(0,max(x$Speciation,x$Extinction,1e-8)*1.2));graphics::legend('topright',c('lambda','mu'),fill=cols,bty='n');graphics::mtext(txt('Hidden categories are not identified biological traits'),side=1,line=4.5,cex=.7)
  } else {
   names<-result$specs[[s$model]]$states;k<-length(names);q<-result$transitions[result$transitions$Model==s$model,];graphics::plot(c(.5,k+.5),c(.5,k+.5),type='n',axes=FALSE,xlab=txt('Destination state'),ylab=txt('Source state'),main=s$model)
   for(i in seq_len(k))for(j in seq_len(k)){v<-q$Rate[q$Source==names[i]&q$Destination==names[j]];graphics::rect(j-.5,k-i+.5,j+.5,k-i+1.5,border='white',col=if(i==j)'#eeeeee' else if(s$palette=='Grayscale')'#dddddd' else '#d8e4dc');graphics::text(j,k-i+1,if(i==j)'-' else signif(v,3),cex=s$label_size)}
   graphics::axis(1,seq_len(k),names);graphics::axis(2,seq_len(k),rev(names),las=1);graphics::mtext(txt('Rate per branch-length unit'),side=1,line=4.5)
  }
 }
 invisible(result)
}
guane_hidden_script <- function(result,settings=guane_hidden_settings()) {
 functions<-c('guane_sse_verification_plot','guane_ltt','guane_bisse_data','guane_bisse_settings','guane_bisse_plot','guane_hidden_native','guane_hidden_require','guane_hidden_models','guane_hidden_spec','guane_hidden_fit','guane_hidden_settings','guane_hidden_plot','guane_text')
 c('# GUane hidden-state analysis: saved fits and editable plots. Requires ape, hisse and data.table for refitting.',paste('# Original hisse version:',result$version),vapply(functions,function(n)paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),guane_r_assignment('result',result),guane_r_assignment('settings',settings),'# Optional refit: result <- do.call(guane_hidden_fit,result$inputs)','opened <- grDevices::dev.cur() == 1L','if(opened) grDevices::pdf("guane-hidden.pdf",width=settings$width,height=settings$height)','guane_hidden_plot(result,settings)','if(opened) grDevices::dev.off()','print(result$comparison)','print(result$warnings)','sessionInfo()')
}
