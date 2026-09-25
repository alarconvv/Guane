# Numerical optimization shared by BiSSE and MuSSE. Engines provide validated likelihoods.
guane_sse_constraint_groups <- function(d,engine) {
 groups<-unique(d$Group);free<-character();start<-lower<-upper<-numeric()
 for(g in groups){i<-which(d$Group==g);lo<-max(d$Lower[i]);hi<-min(d$Upper[i]);fixed<-unique(stats::na.omit(d$Fixed[i]))
  if(lo>=hi||length(fixed)>1||length(fixed)==1&&(fixed<lo||fixed>hi))stop(paste('Tied',engine,'rates have incompatible fixed values or bounds.'))
  if(length(fixed))d$Fixed[i]<-fixed else {free<-c(free,g);lower<-c(lower,lo);upper<-c(upper,hi);start<-c(start,min(hi,max(lo,mean(d$Start[i]))))}
 }
 list(table=d,free=free,start=setNames(start,free),lower=setNames(lower,free),upper=setNames(upper,free))
}
guane_sse_optimize <- function(models,constraints,lik,precise,age,optimizer,starts,maxit,slices,warnings,engine='BiSSE',verify=TRUE) {
 if(length(verify)!=1||!is.logical(verify)||is.na(verify))stop('Invalid optimizer verification settings.')
 fits<-list();attempts<-list();curves<-list()
 msg<-function(x)sub('BiSSE',engine,x,fixed=TRUE)

 for(m in models){con<-constraints[[m]];k<-length(con$free);numerical_messages<-character();failed_evaluations<-0L
  evaluate<-function(p){z<-tryCatch(withCallingHandlers(lik(guane_sse_expand(p,con)),warning=function(w){numerical_messages<<-unique(c(numerical_messages,conditionMessage(w)));invokeRestart('muffleWarning')}),error=function(e){numerical_messages<<-unique(c(numerical_messages,conditionMessage(e)));NA_real_});if(length(z)!=1||!is.finite(z)){failed_evaluations<<-failed_evaluations+1L;numerical_messages<<-unique(c(numerical_messages,msg('Non-finite BiSSE likelihood.')));return(NA_real_)};as.numeric(z)}
  objective<-function(v){ll<-evaluate(v/age);if(is.finite(ll))-ll else 1e100}
  # Deterministic asymmetric starts, recorded in full; no RNG mutation.
  trial<-if(k)lapply(seq_len(starts),function(i){f<-if(i==1)rep(1,k) else exp(sin(seq_len(k)*i)*log(4));pmin(con$upper,pmax(con$lower,con$start*f))}) else list(numeric())
  rows<-list();solutions<-list()
  for(i in seq_along(trial)){
   p<-trial[[i]]
   fit<-tryCatch(if(!k)list(par=numeric(),convergence=0L,message='Fixed rates') else if(optimizer=='nlminb')stats::nlminb(p*age,objective,lower=con$lower*age,upper=con$upper*age,control=list(iter.max=maxit,eval.max=maxit*4,rel.tol=1e-9)) else stats::optim(p*age,objective,method='L-BFGS-B',lower=con$lower*age,upper=con$upper*age,control=list(maxit=maxit)),error=identity)
   error<-inherits(fit,'error');end<-if(error)rep(NA_real_,k) else fit$par/age;ll<-if(error)NA_real_ else evaluate(end)
   solutions[[i]]<-end
   rows[[i]]<-data.frame(Model=m,Start=i,LogLik=ll,Convergence=if(error)99L else if(!is.finite(ll))98L else fit$convergence,Message=if(error)conditionMessage(fit) else if(!is.finite(ll))msg('Non-finite BiSSE likelihood.') else if(is.null(fit$message))'' else fit$message,Initial=paste(signif(p,8),collapse=', '),Final=paste(signif(end,8),collapse=', '))
  }
  a<-do.call(rbind,rows);attempts[[m]]<-a;good<-which(a$Convergence==0&is.finite(a$LogLik));best<-if(length(good))good[which.max(a$LogLik[good])] else NA_integer_
  if(is.na(best)){fits[[m]]<-list(valid=FALSE,k=k,numerical_messages=numerical_messages,failed_evaluations=failed_evaluations);warnings<-c(warnings,'A model failed to converge; model comparison weights are withheld.');next}
  p<-solutions[[best]];full<-guane_sse_expand(p,con);ll<-a$LogLik[best]
  boundary<-k>0&&any(p<=con$lower+1e-7/age|p>=con$upper-1e-5/age)
  ll2<-tryCatch(suppressWarnings(precise(full)),error=function(e)NA_real_);stable<-length(ll2)==1&&is.finite(ll2)&&abs(ll2-ll)<=1e-4
  spread<-diff(range(a$LogLik[good]));better_failed<-any(a$Convergence!=0&is.finite(a$LogLik)&a$LogLik>ll+1e-4)
  alternate<-if(!k)list(convergence=0L,par=numeric(),message='Fixed parameters') else if(verify)tryCatch(if(optimizer=='nlminb')stats::optim(p*age,objective,method='L-BFGS-B',lower=con$lower*age,upper=con$upper*age,control=list(maxit=maxit,factr=1e5)) else stats::nlminb(p*age,objective,lower=con$lower*age,upper=con$upper*age,control=list(iter.max=maxit,eval.max=maxit*4,rel.tol=1e-9)),error=identity) else NULL
  alt_status<-if(is.null(alternate))NA_integer_ else if(inherits(alternate,'error'))99L else alternate$convergence
  alt_ll<-if(is.null(alternate)||inherits(alternate,'error'))NA_real_ else evaluate(alternate$par/age)
  verified<-verify&&isTRUE(alt_status==0)&&is.finite(alt_ll)&&abs(alt_ll-ll)<=1e-4
  if(verify&&!verified)warnings<-c(warnings,'Independent optimizer verification failed or disagreed. Weights and intervals are withheld.')
  fits[[m]]<-list(valid=TRUE,all_converged=all(a$Convergence==0),verified=verified,verification_status=alt_status,verification_logLik=alt_ll,verification_parameters=if(is.null(alternate)||inherits(alternate,'error'))NULL else alternate$par/age,k=k,par=full,free=p,logLik=ll,boundary=boundary,stable=stable,precise_logLik=ll2,spread=spread,better_failed=better_failed,constraint=con,failed_evaluations=failed_evaluations,numerical_messages=numerical_messages)
  if(boundary)warnings<-c(warnings,msg('A BiSSE rate reached a bound. Inspect bounds and identifiability before interpretation.'))
  if(!stable)warnings<-c(warnings,msg('BiSSE likelihood changed under tighter integration tolerance. Ranking weights are withheld.'))
  if(spread>1e-4||better_failed)warnings<-c(warnings,msg('BiSSE starts disagree or an unconverged attempt is better. Refit before interpreting model support.'))
  if(any(a$Convergence!=0))warnings<-c(warnings,'Some optimizer starts failed; inspect the full optimizer table.')
  if(slices&&k)for(j in seq_len(k)){
   grid<-sort(unique(c(p[j],seq(max(con$lower[j],p[j]*.1),min(con$upper[j],max(p[j]*2,1/age)),length.out=25))))
   values<-vapply(grid,function(z){v<-p;v[j]<-z;evaluate(v)},numeric(1))
   if(any(values>ll+1e-4,na.rm=TRUE)){fits[[m]]$better_failed<-TRUE;warnings<-c(warnings,'A likelihood slice found a better point. Refit before interpreting model support.')}
   curves[[paste(m,j)]]<-data.frame(Model=m,Parameter=con$free[j],Rate=grid,DeltaLogLik=values-ll)
  }
 }
 if(isTRUE(fits$Full$valid)&&any(vapply(fits,function(f)isTRUE(f$valid)&&f$logLik>fits$Full$logLik+1e-4,logical(1)))) {fits$Full$better_failed<-TRUE;warnings<-c(warnings,msg('The full BiSSE model fits worse than a constrained candidate. Increase starts or refine bounds.'))}
 # Any better fitted candidate satisfying this model's constraints is a feasible counterexample.
 for(m in models)if(isTRUE(fits[[m]]$valid)) {
  d<-constraints[[m]]$table
  for(other in setdiff(models,m))if(isTRUE(fits[[other]]$valid)&&fits[[other]]$logLik>fits[[m]]$logLik+1e-4) {
   p<-fits[[other]]$par[d$Parameter]
   feasible<-all(p>=d$Lower & p<=d$Upper)&&all(is.na(d$Fixed)|abs(p-d$Fixed)<=1e-10/age)&&all(vapply(split(p,d$Group),function(v)diff(range(v))<=1e-10/age,logical(1)))
   if(feasible){fits[[m]]$better_failed<-TRUE;warnings<-c(warnings,'Another candidate supplies a better feasible point. Refit before interpreting model support.')}
  }
 }
 comparison<-do.call(rbind,lapply(models,function(m){f<-fits[[m]];data.frame(Model=m,Parameters=f$k,LogLik=if(f$valid)f$logLik else NA_real_,AIC=if(f$valid)2*f$k-2*f$logLik else NA_real_,Converged=f$valid,Boundary=if(f$valid)f$boundary else NA,Stable=if(f$valid)f$stable else FALSE)}))
 comparison$DeltaAIC<-comparison$Weight<-NA_real_
 ranking<-length(models)>1&&all(vapply(fits,function(f)isTRUE(f$valid)&&isTRUE(f$stable)&&!isTRUE(f$better_failed)&&f$spread<=1e-4&&isTRUE(f$verified)&&!isTRUE(f$boundary)&&isTRUE(f$all_converged)&&(starts>=2||f$k==0),logical(1)))
 signatures<-vapply(constraints,function(x)paste(c(match(x$table$Group,unique(x$table$Group)),x$table$Fixed,x$table$Lower,x$table$Upper),collapse=','),character(1))
 if(anyDuplicated(signatures))ranking<-FALSE
 if(ranking){delta<-comparison$AIC-min(comparison$AIC);comparison$DeltaAIC<-delta;comparison$Weight<-exp(-delta/2)/sum(exp(-delta/2))}
 estimates<-do.call(rbind,lapply(models,function(m){f<-fits[[m]];if(!f$valid)return(NULL);data.frame(Model=m,Parameter=names(f$par),Estimate=unname(f$par),Group=f$constraint$table$Group,Fixed=!is.na(f$constraint$table$Fixed))}))
 diagnostics<-do.call(rbind,lapply(models,function(m){f<-fits[[m]];if(!f$valid)return(NULL);data.frame(Model=m,TighterLogLik=f$precise_logLik,AbsoluteDifference=abs(f$precise_logLik-f$logLik),StartSpread=f$spread,Verified=f$verified,VerificationStatus=f$verification_status,VerificationLogLik=f$verification_logLik,FailedEvaluations=f$failed_evaluations,Stable=f$stable)}))
 list(fits=fits,estimates=estimates,comparison=comparison,diagnostics=diagnostics,attempts=do.call(rbind,attempts),slices=if(length(curves))do.call(rbind,curves) else NULL,warnings=unique(warnings))
}

guane_sse_parameters <- function(d,n,text,age,engine) {
 msg<-function(x)sub('BiSSE',engine,x,fixed=TRUE)
 if(length(text)!=1||is.na(text))stop(msg('Invalid BiSSE parameter table.'))
 if(nzchar(trimws(text))) {
  d<-tryCatch(utils::read.csv(text=text,stringsAsFactors=FALSE,check.names=FALSE,na.strings=c('','NA')),error=function(e)stop(msg('Invalid BiSSE parameter table.')))
  if(!identical(names(d),c('Parameter','Group','Fixed','Start','Lower','Upper'))||nrow(d)!=length(n)||anyDuplicated(d$Parameter)||!setequal(d$Parameter,n))stop(msg('Invalid BiSSE parameter table.'))
  d<-d[match(n,d$Parameter),,drop=FALSE]
  for(col in c('Fixed','Start','Lower','Upper')) { old<-d[[col]];d[[col]]<-suppressWarnings(as.numeric(old));if(any(!is.na(old)&is.na(d[[col]])))stop(msg('Invalid BiSSE parameter table.')) }
 }
 if(anyNA(d$Group)||any(!grepl('^[A-Za-z][A-Za-z0-9_]*$',d$Group))||!all(vapply(d[c('Fixed','Start','Lower','Upper')],is.numeric,logical(1))))stop(msg('Invalid BiSSE parameter table.'))
 if(any(!is.finite(as.matrix(d[c('Start','Lower','Upper')])) )||any(d$Lower<0)||any(d$Upper<=d$Lower)||any(d$Upper*age>1e6)||any(d$Start<d$Lower|d$Start>d$Upper)||any(!is.na(d$Fixed)&(!is.finite(d$Fixed)|d$Fixed<d$Lower|d$Fixed>d$Upper)))stop(msg('BiSSE starts and fixed rates must respect finite nonnegative bounds.'))
 d
}

guane_sse_backend <- function() if(.Platform$OS.type=='windows') 'deSolve' else 'gslode'
guane_sse_expand <- function(pars,constraint) {
 d<-constraint$table;z<-d$Fixed;i<-is.na(z);z[i]<-pars[match(d$Group[i],constraint$free)];setNames(z,d$Parameter)
}

# One selected free group, with nuisance parameters refitted at every grid point.
# Finite search endpoints and failed segments never become confidence limits.
guane_sse_profile <- function(fit,lik,precise,parameter,lower,upper,points=15,level=.95,maxit=500,age=1) {
 if(!isTRUE(fit$valid)||!isTRUE(fit$verified)||!isTRUE(fit$stable)||isTRUE(fit$boundary)||isTRUE(fit$better_failed)||fit$spread>1e-4)stop('Resolve fit diagnostics before calculating profile intervals.')
 con<-fit$constraint;j<-match(parameter,con$free)
 if(length(j)!=1||is.na(j))stop('Select an estimated parameter group for profiling.')
 if(length(c(lower,upper,points,level,maxit))!=5||any(!is.finite(c(lower,upper,points,level,maxit)))||lower>=fit$free[j]||upper<=fit$free[j]||lower<con$lower[j]||upper>con$upper[j]||!points%in%5:101||level<=.5||level>=1||!maxit%in%10:5000)stop('Profile bounds must enclose the estimate within its fitted bounds.')
 grid<-sort(unique(c(seq(lower,upper,length.out=points),fit$free[j])));rows<-list();nuisance<-setdiff(seq_along(con$free),j)
 for(v in grid){
  eval<-function(x,fun=lik){p<-fit$free;p[j]<-v;p[nuisance]<-x/age;tryCatch(suppressWarnings(fun(guane_sse_expand(p,con))),error=function(e)NA_real_)}
  objective<-function(x){z<-eval(x);if(length(z)==1&&is.finite(z))-z else 1e100}
  trials<-list(fit$free[nuisance]*age,(con$lower[nuisance]+pmin(con$upper[nuisance],pmax(fit$free[nuisance]*2,con$lower[nuisance]+1/age)))/2*age)
  fits<-lapply(trials,function(x)tryCatch(if(!length(nuisance))list(par=numeric(),convergence=0L) else stats::nlminb(x,objective,lower=con$lower[nuisance]*age,upper=con$upper[nuisance]*age,control=list(iter.max=maxit,eval.max=maxit*4,rel.tol=1e-9)),error=identity))
  lls<-vapply(fits,function(f)if(inherits(f,'error'))NA_real_ else eval(f$par),numeric(1));ok<-vapply(fits,function(f)!inherits(f,'error')&&f$convergence==0,logical(1))&is.finite(lls)
  best<-if(any(ok))which(ok)[which.max(lls[ok])] else NA_integer_;ll<-if(is.na(best))NA_real_ else lls[best]
  fine<-if(is.na(best))NA_real_ else eval(fits[[best]]$par,precise)
  stable<-is.finite(ll)&&is.finite(fine)&&abs(fine-ll)<=1e-4
  repeatable<-all(ok)&&diff(range(lls))<=1e-4
  rows[[length(rows)+1]]<-data.frame(Parameter=parameter,Value=v,LogLik=ll,TighterLogLik=fine,FailedStarts=sum(!ok),Message=paste(vapply(fits,function(f)if(inherits(f,'error'))conditionMessage(f) else if(is.null(f$message))'' else f$message,character(1)),collapse=' | '),Converged=any(ok),Stable=stable,Repeatable=repeatable,DeltaLogLik=ll-fit$logLik)
 }
 curve<-do.call(rbind,rows);cut<-stats::qchisq(level,1)/2;center<-which.min(abs(curve$Value-fit$free[j]));better<-any(curve$DeltaLogLik>1e-4,na.rm=TRUE)
 endpoint<-function(indices){previous<-center
  for(i in indices){if(!isTRUE(curve$Stable[i])||!isTRUE(curve$Repeatable[i]))return(c(value=NA,status='Failed profile segment'))
   if(curve$DeltaLogLik[i]<= -cut){a<-curve[previous,];b<-curve[i,];return(c(value=a$Value+(-cut-a$DeltaLogLik)*(b$Value-a$Value)/(b$DeltaLogLik-a$DeltaLogLik),status='Crossing'))};previous<-i}
  c(value=NA,status='Search limit reached')
 }
 lo<-endpoint(rev(seq_len(center-1)));hi<-endpoint(seq.int(center+1,nrow(curve)))
 if(better||!curve$Stable[center]||!curve$Repeatable[center]){lo<-hi<-c(value=NA,status='Fit requires review')}
 list(curve=curve,interval=data.frame(Parameter=parameter,Estimate=fit$free[j],Lower=as.numeric(lo['value']),Upper=as.numeric(hi['value']),LowerStatus=unname(lo['status']),UpperStatus=unname(hi['status']),Level=level),better=better,settings=list(parameter=parameter,lower=lower,upper=upper,points=points,level=level,maxit=maxit),warning='Profile intervals use an approximate chi-square reference conditional on the tree and model. Failed segments and search limits have no interval endpoint.')
}
guane_sse_profile_plot <- function(result,settings) {
 p<-result$profile
 if(is.null(p))stop('Run a profile analysis first.')
 txt<-function(x)guane_text(x,settings$lang);x<-p$curve;ok<-x$Stable&x$Repeatable
 graphics::plot(x$Value,x$DeltaLogLik,type='n',xlab=p$settings$parameter,ylab='Delta logLik',main=paste(txt('Profile likelihood'),txt(p$model)))
 y<-x$DeltaLogLik;y[!ok]<-NA;graphics::lines(x$Value,y);graphics::points(x$Value,x$DeltaLogLik,pch=ifelse(ok,19,4))
 graphics::abline(h=-stats::qchisq(p$settings$level,1)/2,lty=2);graphics::abline(v=p$interval$Estimate,lty=3)
 graphics::mtext(txt('Approximate profile intervals; inspect failed segments and search limits'),side=1,line=3.5,cex=.7)
}

guane_sse_verification_plot <- function(result,settings) {
 txt<-function(x)guane_text(x,settings$lang)
 values<-lapply(result$fits,function(f){a<-if(!is.null(f$native))f$native$guane_optimizer else f;c(Fitted=if(isTRUE(f$valid))f$logLik else NA_real_,Verification=if(length(a$verification_logLik))a$verification_logLik else NA_real_)})
 z<-do.call(rbind,values);if(!any(is.finite(z)))stop('No finite optimizer results to display.')
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old));graphics::par(mar=c(5,12,3,2))
 graphics::plot(range(z,finite=TRUE),c(.5,nrow(z)+.5),type='n',yaxt='n',xlab='logLik',ylab='',main=txt('Independent optimizer verification'))
 graphics::axis(2,seq_len(nrow(z)),vapply(rownames(z),txt,character(1)),las=1,cex.axis=.8)
 cols<-if(settings$palette=='Grayscale')c('#222222','#888888') else c('#26734f','#bd6731')
 for(i in seq_len(nrow(z))){graphics::segments(z[i,1],i,z[i,2],i);graphics::points(z[i,],rep(i,2),pch=c(19,4),col=cols)}
 graphics::legend('bottomright',c(txt('Fitted'),txt('Verification')),pch=c(19,4),col=cols,bty='n')
}
