# Named tip matching; fastAnc computes BM maximum-likelihood node estimates.
guane_asr_continuous_data <- function(tree,traits,taxon,trait) {
 if(!inherits(tree,'phylo') || !ape::is.rooted(tree) || !ape::is.binary(tree)) stop('Continuous reconstruction requires a rooted, bifurcating tree.')
 if(is.null(tree$edge.length) || length(tree$edge.length)!=nrow(tree$edge) || any(!is.finite(tree$edge.length)) || any(tree$edge.length<=0)) stop('Continuous reconstruction requires finite, positive branch lengths.')
 if(!is.data.frame(traits) || anyDuplicated(names(traits)) || length(taxon)!=1 || length(trait)!=1 || taxon==trait || !all(c(taxon,trait) %in% names(traits))) stop('Select distinct taxon and numeric trait columns.')
 ids<-as.character(traits[[taxon]])
 if(length(tree$tip.label)<3 || anyNA(tree$tip.label) || any(!nzchar(trimws(tree$tip.label))) || anyDuplicated(tree$tip.label) || anyNA(ids) || any(!nzchar(trimws(ids))) || anyDuplicated(ids) || !setequal(ids,tree$tip.label)) stop('Match unique taxon labels explicitly in Data before reconstruction; at least three taxa are required.')
 traits<-traits[match(tree$tip.label,ids),,drop=FALSE]
 values<-traits[[trait]]
 if(!is.numeric(values) || any(!is.finite(values)) || length(unique(values))<2) stop('Continuous reconstruction needs a finite, nonconstant numeric trait. No rows are removed automatically.')
 list(traits=traits,x=setNames(values,tree$tip.label))
}

guane_asr_bm <- function(tree,traits,taxon,trait) {
 prepared<-guane_asr_continuous_data(tree,traits,taxon,trait)
 traits<-prepared$traits;x<-prepared$x;warnings<-character()
 fit<-withCallingHandlers(phytools::fastAnc(tree,x,vars=TRUE,CI=TRUE),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
 nodes<-as.character(seq_len(tree$Nnode)+length(x))
 estimates<-fit$ace[nodes];variances<-fit$var[nodes];ci<-fit$CI95[nodes,,drop=FALSE]
 if(any(!is.finite(c(estimates,variances,ci))) || any(variances<0)) stop('BM reconstruction returned invalid node estimates or uncertainty.')
 # Marginal tip-data likelihood with root mean and diffusion rate estimated by ML.
 C<-ape::vcv.phylo(tree)[names(x),names(x)];chol(C)
 root<-sum(solve(C,x))/sum(solve(C,rep(1,length(x))))
 residual<-x-root;rate<-as.numeric(crossprod(residual,solve(C,residual)))/length(x)
 if(!is.finite(rate) || rate<=0) stop('BM reconstruction returned an invalid diffusion rate.')
 loglik<--.5*(length(x)*(log(2*pi)+1+log(rate))+as.numeric(determinant(C,logarithm=TRUE)$modulus))
 table<-data.frame(Node=as.integer(nodes),Estimate=unname(estimates),Variance=unname(variances),Lower=ci[,1],Upper=ci[,2],row.names=NULL)
 list(tree=tree,traits=traits,taxon=taxon,trait=trait,x=x,ace=estimates,nodes=table,root=root,rate=rate,logLik=loglik,pic=ape::pic(x,tree),warnings=unique(warnings))
}

guane_asr_bm_plot <- function(result,type='map',palette='Guane',labels=TRUE,node_labels=FALSE,lang='en',appearance=list(),label_size=.7,parameter='sig2') {
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old))
 txt<-function(x) guane_text(x,lang)
 tree<-result$tree;x<-result$x;g<-guane_asr_graphics(appearance)
 if(type=='map' && g$layout!='phylogram')stop('Colored histories and continuous maps currently require a phylogram layout.')
 colors<-guane_asr_gradient(palette,g$gradient)
 if(!is.null(result$bayes) && type=='diagnostics')type<-'trace'
 if(type%in%c('trace','posterior_density')) {
  if(is.null(result$bayes) || !parameter%in%setdiff(names(result$bayes$full[[1]]),'gen'))stop('Choose a saved Bayesian parameter for this graph.')
  b<-result$bayes;cols<-grDevices::colorRampPalette(colors)(b$chains+2)[seq_len(b$chains)+1]
  graphics::par(mar=c(5,5,3,1))
  if(type=='trace') {
   ys<-vapply(b$full,function(z)z[[parameter]],numeric(nrow(b$full[[1]])))
   graphics::matplot(b$full[[1]]$gen,ys,type='l',lty=seq_len(b$chains),col=cols,xlab=txt('Generation'),ylab=parameter,main=txt('MCMC traces including burn-in'))
   graphics::abline(v=b$burnin,lty=2,col='grey40')
  } else {
   ds<-lapply(b$retained,function(z)stats::density(z[[parameter]]))
   graphics::plot(ds[[1]],xlim=range(vapply(ds,function(z)range(z$x),numeric(2))),ylim=c(0,max(vapply(ds,function(z)max(z$y),numeric(1)))),col=cols[1],lty=1,main=txt('Retained posterior densities'),xlab=parameter,ylab=txt('Density'))
   if(b$chains>1)for(i in 2:b$chains)graphics::lines(ds[[i]],col=cols[i],lty=i)
  }
  graphics::legend('topright',legend=paste(txt('Chain'),seq_len(b$chains)),col=cols,lty=seq_len(b$chains),bty='n',cex=.7)
 } else if(type=='map') {
  m<-phytools::contMap(tree,x,res=g$resolution,method='user',anc.states=result$ace,plot=FALSE)
  m$cols[]<-grDevices::colorRampPalette(colors)(length(m$cols))
  plot(m,type=g$layout,direction=g$direction,outline=g$outline,lwd=g$edge_width,ftype=c(c('reg','b','i','bi')[g$font],'reg'),offset=g$label_offset*max(phytools::nodeHeights(tree)),mar=c(1,1,3,1),leg.txt=result$trait,underscore=g$underscore,fsize=c(if(labels) label_size else 0,g$legend_size),legend=if(g$legend)g$legend_fraction*max(ape::node.depth.edgelength(tree)) else 0)
  if(node_labels) ape::nodelabels(cex=.6,frame='none',adj=c(1.1,-.3))
  guane_asr_highlight(result,g)
  graphics::title(main=paste(paste(if(is.null(result$model)) 'BM' else result$model,txt('Ancestral reconstruction')),result$trait,sep=': '),cex.main=.9)
 } else if(type=='phenogram') {
  graphics::par(mar=c(5,5,3,2))
  phytools::phenogram(tree,c(x,result$ace),fsize=if(labels) label_size else 0,spread.labels=FALSE,ftype=c('reg','b','i','bi')[g$font],lwd=g$edge_width,lty=g$edge_type,offset=g$label_offset,colors=tail(colors,1),xlab=txt('Distance from root (branch-length units)'),ylab=result$trait)
 } else if(type%in%c('intervals','node')) {
  d<-if(type=='node')guane_asr_node_table(result,g$focus_node) else result$nodes
  graphics::par(mar=c(5,5,3,1))
  has_ci<-all(is.finite(c(d$Lower,d$Upper)))
  graphics::plot(d$Node,d$Estimate,ylim=if(has_ci)range(d$Lower,d$Upper) else range(d$Estimate),xlab=txt('Node'),ylab=result$trait,pch=19,col=tail(colors,1),main=paste(if(is.null(result$model))'BM' else result$model,txt(if(!has_ci)'Node estimates; intervals unavailable' else if(!is.null(result$bayes))'Equal-tailed 95% credible intervals' else if(identical(result$engine,'Gaussian ML'))'Conditional 95% prediction intervals' else 'Approximate 95% node intervals')),cex.main=.9)
  if(has_ci)graphics::segments(d$Node,d$Lower,d$Node,d$Upper,col=tail(colors,1))
 } else if(type=='comparison') {
  d<-result$comparison
  if(is.null(d))stop('Run Gaussian ML with model comparison enabled.')
  good<-is.finite(d$DeltaAIC)
  graphics::par(mar=c(5,5,3,1))
  graphics::barplot(d$DeltaAIC[good],names.arg=d$Model[good],col=tail(colors,1),ylab='Delta AIC',main=txt('Marginal model comparison'))
 } else if(type=='diagnostics') {
  graphics::par(mar=c(5,5,3,1))
  z<-if(is.null(result$whitened))result$pic else result$whitened
  stats::qqnorm(z,pch=19,col=tail(colors,1),main=txt(if(is.null(result$whitened))'BM contrast diagnostic' else 'Fitted covariance residual diagnostic'),xlab=txt('Theoretical quantiles'),ylab=txt(if(is.null(result$whitened))'Standardized contrasts' else 'Decorrelated tip residuals'))
  stats::qqline(z,col='grey50',lty=2)
 } else stop('Unknown BM graph.')
 invisible(result$nodes)
}

guane_asr_bm_script <- function(result,type='map',palette='Guane',labels=TRUE,node_labels=FALSE,lang='en',appearance=list(),label_size=.7,parameter='sig2') {
 helpers<-c('guane_bayes_parameters','guane_bayes_controls','guane_bayes_diagnostics','guane_asr_bayes','guane_asr_graphics','guane_asr_colors','guane_asr_gradient','guane_asr_node_table','guane_asr_highlight','guane_asr_legend','guane_asr_density','guane_asr_covariance','guane_asr_gaussian','guane_asr_gaussian_compare','guane_asr_continuous_data','guane_asr_continuous','guane_asr_bm','guane_asr_bm_plot','guane_text')
 c('# Guane continuous ancestral reconstruction; engine and uncertainty are saved in result.',
 '# install.packages(c("ape","phytools","coda","jsonlite"))',
 '# Uncertainty and likelihood basis are stored in result$uncertainty and result$likelihood_basis. No AIC ranking across engines.',
 '# Branch colors/phenogram lines interpolate estimates; they are not sampled evolutionary histories.',
 paste0('# R ',getRversion(),'; phytools ',utils::packageVersion('phytools'),'; ape ',utils::packageVersion('ape')),
 vapply(helpers,function(n) paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),
 guane_r_assignment('inputs',if(is.null(result$inputs))result[c('tree','traits','taxon','trait')] else result$inputs),if(is.null(result$inputs))'# Optional refit: refitted <- do.call(guane_asr_bm,inputs)' else if(!is.null(result$bayes))'# Optional refit: refitted <- do.call(guane_asr_bayes,inputs)' else '# Optional refit: refitted <- do.call(guane_asr_continuous,inputs)',if(is.null(result$bayes))guane_r_assignment('result',result) else guane_bayes_saved_assignment(result),
 'print(result$nodes)','print(c(root=result$root,diffusion_estimate=result$rate,logLik=result$logLik))','print(result$warnings)','print(result$uncertainty)','print(result$likelihood_basis)','print(result$comparison)',
 guane_r_assignment('plot_settings',list(type=type,palette=palette,labels=labels,node_labels=node_labels,lang=lang,appearance=appearance,label_size=label_size,parameter=parameter)),
 guane_asr_script_device(appearance),
 'do.call(guane_asr_bm_plot,c(list(result=result),plot_settings))',
 '# Optional: pdf("guane-bm.pdf",width=9,height=7); do.call(guane_asr_bm_plot,c(list(result=result),plot_settings)); dev.off()', guane_asr_script_device(appearance,close=TRUE),'sessionInfo()')
}

# anc.ML optimizes a joint tip + ancestral-state density, not the marginal
# tip-data likelihood reported by the fastAnc adapter. Do not rank these by AIC.
guane_asr_continuous <- function(tree,traits,taxon,trait,model='BM',engine=if(model=='BM')'fastAnc' else 'anc.ML',maxit=2000,tol=NULL,trace=FALSE,intervals=TRUE,start=NULL,se_column=NULL,shape_bounds=NULL,compare=FALSE) {
 if(identical(engine,'Gaussian ML')) {
  r<-guane_asr_gaussian(tree,traits,taxon,trait,model,maxit,trace,intervals,start,se_column,shape_bounds)
  if(isTRUE(compare))r$comparison<-guane_asr_gaussian_compare(r,tree,traits,taxon,trait,maxit,trace,se_column)
  r$inputs<-list(tree=tree,traits=traits,taxon=taxon,trait=trait,model=model,engine=engine,maxit=maxit,trace=trace,intervals=intervals,start=start,se_column=se_column,shape_bounds=shape_bounds,compare=compare)
  return(r)
 }
 if(!is.null(se_column) || isTRUE(compare))stop('Measurement error and model comparison require Gaussian ML.')
 if(length(model)!=1 || !model%in%c('BM','OU','EB') || length(engine)!=1 || !engine%in%c('fastAnc','anc.ML') || (engine=='fastAnc' && model!='BM'))stop('Choose fastAnc for BM or anc.ML for BM, OU or EB.')
 if(length(intervals)!=1 || is.na(intervals) || !is.logical(intervals) || length(trace)!=1 || is.na(trace) || !is.logical(trace))stop('Invalid continuous-engine switches.')
 prepared<-guane_asr_continuous_data(tree,traits,taxon,trait)
 if(engine=='fastAnc') {
  r<-guane_asr_bm(tree,traits,taxon,trait)
  r$likelihood_basis<-'Marginal tip-data likelihood; root and diffusion estimated by ML.'
  r$uncertainty<-'Approximate 95% fastAnc/Rohlf intervals; no tree or model uncertainty.'
  r$effective_args<-list(vars=TRUE,CI=TRUE)
 } else {
  if(is.null(tol))tol<-if(model=='BM')10*.Machine$double.eps else 1e-8
  if(length(maxit)!=1 || !is.numeric(maxit) || !is.finite(maxit) || maxit<1 || maxit>100000 || maxit!=as.integer(maxit))stop('Maximum iterations must be an integer from 1 to 100000.')
  if(length(tol)!=1 || !is.numeric(tol) || !is.finite(tol) || tol<=0)stop('The positive parameter lower bound must be finite and greater than zero.')
  if(!is.null(start) && (length(start)!=1 || !is.numeric(start) || !is.finite(start) || model=='BM' || (model=='OU' && start<tol)))stop('Use a finite EB rate start or an OU alpha start at or above the lower bound.')
  args<-list(maxit=maxit,model=model,tol=tol,trace=trace)
  # OU supplies no node uncertainty. EB var is misindexed in phytools 2.5.2;
  # use correctly indexed CI95, deriving its variance by the exact 1.96 rule.
  if(model!='OU')args<-c(args,list(vars=FALSE,CI=intervals))
  if(!is.null(start))args[[if(model=='OU')'a.init' else 'r.init']]<-start
  warnings<-character();fit<-withCallingHandlers(do.call(phytools::anc.ML,c(list(tree=tree,x=prepared$x),args)),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
  if(length(fit$convergence)!=1 || is.na(fit$convergence) || fit$convergence!=0)stop(paste('Continuous optimizer did not converge:',fit$convergence,fit$message))
  nodes<-as.character(seq_len(tree$Nnode)+length(tree$tip.label));ace<-fit$ace[nodes]
  if(length(ace)!=length(nodes) || any(!is.finite(ace)) || !is.finite(fit$logLik) || !is.finite(fit$sig2) || fit$sig2<=0)stop('Continuous optimization returned invalid estimates or likelihood.')
  ci<-matrix(NA_real_,length(nodes),2);variance<-rep(NA_real_,length(nodes))
  if(model!='OU' && intervals) {
   ci<-fit$CI95[nodes,,drop=FALSE]
   if(any(!is.finite(ci)) || any(ci[,2]<ci[,1]))stop('Node uncertainty is invalid; inspect the model or rerun without intervals.')
   variance<-((ci[,2]-ci[,1])/(2*1.96))^2
  }
  covariance_args<-list(tree=tree,anc.nodes=FALSE,model=model)
  if(model=='OU')covariance_args$alpha<-fit$alpha
  if(model=='EB')covariance_args$r<-fit$r
  C<-fit$sig2*do.call(phytools::vcvPhylo,covariance_args)
  root<-unname(ace[1]);white<-as.numeric(forwardsolve(t(chol(C)),prepared$x-root))
  if(fit$sig2<=tol*1.01 || (model=='OU' && fit$alpha<=tol*1.01))warnings<-c(warnings,'An estimated parameter is at its lower bound; interpret with caution.')
  if(model=='OU')warnings<-c(warnings,'The installed anc.ML documentation cautions that the OU implementation has not been thoroughly tested. No OU node intervals are supplied.')
  if(model=='EB' && fit$r>0)warnings<-c(warnings,'The fitted EB rate increases through time (r > 0); the backend does not constrain it to an early burst.')
  r<-list(tree=tree,traits=prepared$traits,taxon=taxon,trait=trait,x=prepared$x,ace=ace,nodes=data.frame(Node=as.integer(nodes),Estimate=unname(ace),Variance=variance,Lower=ci[,1],Upper=ci[,2],row.names=NULL),root=root,rate=fit$sig2,alpha=fit$alpha,r=fit$r,logLik=fit$logLik,whitened=white,warnings=unique(warnings),fit=fit,effective_args=args,
   likelihood_basis='Joint tip and ancestral-state density from anc.ML; not comparable to marginal tip-data likelihood. No AIC ranking.',
   uncertainty=if(model=='OU')'OU node intervals are unavailable from this engine.' else if(intervals)'Approximate 95% Hessian intervals; no tree or model uncertainty.' else 'Node intervals were not requested.')
 }
 r$model<-model;r$engine<-engine;r$backend_version<-as.character(utils::packageVersion('phytools'))
 r$inputs<-list(tree=tree,traits=traits,taxon=taxon,trait=trait,model=model,engine=engine,maxit=maxit,tol=tol,trace=trace,intervals=intervals,start=start)
 r
}

# Root-conditioned Gaussian processes with one unknown constant mean (OU root
# equals optimum). Includes the root as a zero-covariance row; mean-estimation
# uncertainty is added by universal kriging, not by an arbitrary root prior.
guane_asr_covariance <- function(tree,model='BM',shape=0) {
 if(length(model)!=1 || !model%in%c('BM','OU','EB') || length(shape)!=1 || !is.numeric(shape) || !is.finite(shape))stop('Unknown continuous covariance model.')
 depth<-ape::node.depth.edgelength(tree)
 shared<-matrix(depth[ape::mrca(tree,full=TRUE)],length(depth))
 if(model=='BM' || abs(shape)*max(depth)<1e-8)return(shared)
 if(model=='OU')return(-expm1(-2*shape*shared)*exp(-shape*ape::dist.nodes(tree))/(2*shape))
 if(model=='EB')return(expm1(shape*shared)/shape)
 stop('Unknown continuous covariance model.')
}

# ML on observed tips only: V = sig2*C + diag(SE^2). Profile the common
# mean analytically; ancestral states are predictions, not AIC parameters.
guane_asr_gaussian <- function(tree,traits,taxon,trait,model='BM',maxit=2000,trace=FALSE,intervals=TRUE,start=NULL,se_column=NULL,shape_bounds=NULL) {
 prepared<-guane_asr_continuous_data(tree,traits,taxon,trait)
 if(length(model)!=1 || !model%in%c('BM','OU','EB'))stop('Unknown continuous covariance model.')
 if(length(maxit)!=1 || !is.numeric(maxit) || !is.finite(maxit) || maxit<1 || maxit>100000 || maxit!=floor(maxit))stop('Maximum iterations must be an integer from 1 to 100000.')
 if(length(trace)!=1 || !is.logical(trace) || is.na(trace) || length(intervals)!=1 || !is.logical(intervals) || is.na(intervals))stop('Invalid continuous-engine switches.')
 x<-prepared$x;n<-length(x);tips<-seq_len(n);nodes<-n+seq_len(tree$Nnode)
 se<-setNames(rep(0,n),names(x))
 if(!is.null(se_column)) {
  if(length(se_column)!=1 || is.na(se_column) || !se_column%in%names(traits) || se_column%in%c(taxon,trait))stop('Select a separate numeric standard-error column.')
  se<-prepared$traits[[se_column]]
  if(!is.numeric(se) || any(!is.finite(se)) || any(se<0))stop('Standard errors must be finite, nonnegative and on the selected trait scale.')
  names(se)<-names(x)
 }
 height<-max(ape::node.depth.edgelength(tree));scale<-stats::var(x)/height
 if(is.null(shape_bounds))shape_bounds<-if(model=='OU')c(0,50/height) else if(model=='EB')c(-50/height,0) else c(0,0)
 if(length(shape_bounds)!=2 || !is.numeric(shape_bounds) || any(!is.finite(shape_bounds)) || (model!='BM' && shape_bounds[1]>=shape_bounds[2]) || (model=='OU' && shape_bounds[1]<0) || max(abs(shape_bounds))*height>100)stop('Invalid shape bounds: OU must be nonnegative; scaled bounds must lie within -100 to 100.')
 if(!is.null(start) && (length(start)!=1 || !is.numeric(start) || !is.finite(start) || start<shape_bounds[1] || start>shape_bounds[2]))stop('The starting shape parameter must lie within its bounds.')
 evaluate<-function(par,details=FALSE) {
  shape<-if(model=='BM')0 else par[2]/height
  C<-guane_asr_covariance(tree,model,shape);rate<-exp(par[1])*scale
  V<-rate*C[tips,tips,drop=FALSE]+diag(se^2,n)
  L<-chol(V);iv<-chol2inv(L);one<-rep(1,n);denom<-sum(iv);mu<-sum(iv%*%x)/denom;res<-x-mu
  nll<-.5*(n*log(2*pi)+2*sum(log(diag(L)))+as.numeric(crossprod(res,iv%*%res)))
  if(!is.finite(nll))stop('Invalid Gaussian likelihood.')
  if(details)list(C=C,V=V,iv=iv,mean=mu,rate=rate,shape=shape,denom=denom,nll=nll,L=L) else nll
 }
 objective<-function(par)tryCatch(evaluate(par),error=function(e)1e100)
 # Deterministic starts preserve caller RNG and expose optimizer failures.
 shapes<-if(model=='BM')0 else unique(c(if(!is.null(start))start*height,shape_bounds*height,mean(shape_bounds)*height,if(model=='OU')1 else -1))
 shapes<-shapes[shapes>=shape_bounds[1]*height & shapes<=shape_bounds[2]*height]
 starts<-lapply(shapes,function(z)if(model=='BM')0 else c(0,z))
 fits<-lapply(starts,function(p)tryCatch(stats::optim(p,objective,method='L-BFGS-B',lower=c(-25,if(model!='BM')shape_bounds[1]*height),upper=c(25,if(model!='BM')shape_bounds[2]*height),control=list(maxit=maxit,trace=as.integer(trace))),error=identity))
 ok<-vapply(fits,function(f)!inherits(f,'error') && f$convergence==0 && is.finite(f$value) && f$value<1e99,logical(1))
 if(!any(ok))stop('No marginal-likelihood optimization start converged.')
 best<-which(ok)[which.min(vapply(fits[ok],function(f)f$value,numeric(1)))];fit<-fits[[best]];v<-evaluate(fit$par,TRUE)
 B<-v$rate*v$C[nodes,tips,drop=FALSE];weights<-B%*%v$iv
 ace<-as.numeric(v$mean+weights%*%(x-v$mean));names(ace)<-as.character(nodes)
 h<-1-rowSums(weights)
 node_cov<-v$rate*v$C[nodes,nodes,drop=FALSE]-weights%*%t(B)+tcrossprod(h)/v$denom
 variance<-diag(node_cov)
 if(any(!is.finite(variance)) || any(variance< -1e-8*max(1,v$rate*height)))stop('Invalid conditional node variance.')
 variance<-pmax(variance,0);ci<-stats::qnorm(.975)*sqrt(variance)
 warnings<-character()
 boundary<-abs(fit$par[1])>24.9 || (model!='BM' && min(abs(v$shape-shape_bounds))*height<1e-5)
 if(boundary)warnings<-c(warnings,'A marginal model parameter is at a search bound; inspect bounds and model identifiability.')
 if(any(!ok))warnings<-c(warnings,'Some optimization starts failed; the best converged start is reported.')
 if(model=='EB' && v$shape>0)warnings<-c(warnings,'The fitted EB rate increases through time (r > 0); the backend does not constrain it to an early burst.')
 k<-if(model=='BM')2 else 3;ll<--v$nll;aic<-2*k-2*ll
 list(tree=tree,traits=prepared$traits,taxon=taxon,trait=trait,x=x,ace=ace,
  nodes=data.frame(Node=nodes,Estimate=unname(ace),Variance=if(intervals)variance else NA_real_,Lower=if(intervals)ace-ci else NA_real_,Upper=if(intervals)ace+ci else NA_real_,row.names=NULL),
  root=v$mean,rate=v$rate,alpha=if(model=='OU')v$shape else NULL,r=if(model=='EB')v$shape else NULL,logLik=ll,k=k,AIC=aic,AICc=if(n>k+1)aic+2*k*(k+1)/(n-k-1) else NA_real_,
  whitened=as.numeric(forwardsolve(t(v$L),x-v$mean)),warnings=warnings,fit=fit,
  starts=data.frame(Start=seq_along(fits),Converged=ok,NegativeLogLikelihood=vapply(fits,function(f)if(inherits(f,'error'))NA_real_ else f$value,numeric(1))),
  effective_args=list(maxit=maxit,trace=trace,intervals=intervals,start=start,se_column=se_column,shape_bounds=shape_bounds,log_rate_scale_bounds=c(-25,25)),
  measurement_se=se,shape_bounds=shape_bounds,boundary=boundary,
  likelihood_basis='Marginal Gaussian tip-data ML; same observations and known measurement errors across BM/OU/EB. OU root equals its single optimum.',
  uncertainty=if(intervals)'Approximate 95% conditional prediction intervals include mean-estimation uncertainty; covariance parameters and tree are fixed at their fitted values.' else 'Node intervals were not requested.',
  model=model,engine='Gaussian ML',backend_version=paste('Guane Gaussian v1; R',getRversion()))
}

guane_asr_gaussian_compare <- function(selected,tree,traits,taxon,trait,maxit=2000,trace=FALSE,se_column=NULL) {
 models<-c('BM','OU','EB')
 rows<-lapply(models,function(m){
  r<-tryCatch(if(m==selected$model)selected else guane_asr_gaussian(tree,traits,taxon,trait,m,maxit,trace,intervals=FALSE,se_column=se_column),error=identity)
  if(inherits(r,'error'))return(data.frame(Model=m,logLik=NA_real_,Parameters=if(m=='BM')2 else 3,AIC=NA_real_,AICc=NA_real_,ShapeLower=NA_real_,ShapeUpper=NA_real_,Boundary=NA,Status=conditionMessage(r)))
  data.frame(Model=m,logLik=r$logLik,Parameters=r$k,AIC=r$AIC,AICc=r$AICc,ShapeLower=r$shape_bounds[1],ShapeUpper=r$shape_bounds[2],Boundary=r$boundary,Status='Converged')
 })
 tab<-do.call(rbind,rows);tab$DeltaAIC<-tab$AIC-min(tab$AIC,na.rm=TRUE)
 tab$AkaikeWeight<-if(all(is.finite(tab$AIC)))exp(-tab$DeltaAIC/2)/sum(exp(-tab$DeltaAIC/2)) else NA_real_
 tab
}

# Explicit anc.Bayes parameter order: diffusion, root, remaining internal nodes.
guane_bayes_parameters <- function(tree,traits,taxon,trait) {
 d<-guane_asr_continuous_data(tree,traits,taxon,trait)
 f<-phytools::phyl.vcv(as.matrix(d$x),ape::vcv(tree),1)
 p<-c('sig2',as.character(length(d$x)+seq_len(tree$Nnode)))
 data.frame(Parameter=p,Start=c(as.numeric(f$R[1,1]),rep(as.numeric(f$alpha),tree$Nnode)),PriorMean=c(1000,rep(0,tree$Nnode)),PriorVariance=c(NA_real_,rep(1000,tree$Nnode)),ProposalVariance=rep(.01*max(f$C)*f$R[1,1],length(p)),check.names=FALSE)
}

guane_bayes_controls <- function(tree,traits,taxon,trait,parameters=NULL,sample=100) {
 template<-guane_bayes_parameters(tree,traits,taxon,trait)
 if(is.null(parameters))parameters<-template
 if(is.character(parameters))parameters<-tryCatch(utils::read.csv(text=parameters,check.names=FALSE,stringsAsFactors=FALSE),error=function(e)stop('Invalid Bayesian parameter CSV.'))
 cols<-names(template)
 if(!is.data.frame(parameters) || !identical(names(parameters),cols) || nrow(parameters)!=nrow(template) || anyNA(parameters$Parameter) || anyDuplicated(parameters$Parameter) || !setequal(as.character(parameters$Parameter),template$Parameter))stop('Provide exactly one Bayesian parameter row for sig2 and every internal node.')
 parameters<-parameters[match(template$Parameter,parameters$Parameter),,drop=FALSE];rownames(parameters)<-NULL
 for(n in cols[-1])if(!is.numeric(parameters[[n]]))stop('Bayesian parameter values must be numeric; diffusion prior variance must be NA.')
 if(any(!is.finite(as.matrix(parameters[c('Start','PriorMean','ProposalVariance')])) ) || any(!is.finite(parameters$PriorVariance[-1])) || !is.na(parameters$PriorVariance[1]) || parameters$Start[1]<=0 || parameters$PriorMean[1]<=0 || any(parameters$PriorVariance[-1]<=0) || any(parameters$ProposalVariance<=0))stop('Invalid Bayesian priors, starts or proposal variances.')
 list(parameters=parameters,control=list(sig2=parameters$Start[1],a=parameters$Start[2],y=unname(parameters$Start[-c(1,2)]),pr.mean=parameters$PriorMean,pr.var=c(parameters$PriorMean[1]^2,parameters$PriorVariance[-1]),prop=parameters$ProposalVariance,sample=sample))
}

guane_asr_bayes <- function(tree,traits,taxon,trait,ngen=50000,sample=100,burnin=10000,chains=2,seed=999,spread=2,parameters=NULL) {
 hadseed<-exists('.Random.seed',envir=.GlobalEnv,inherits=FALSE);oldkind<-RNGkind()
 if(hadseed)oldseed<-get('.Random.seed',envir=.GlobalEnv)
 on.exit({do.call(RNGkind,as.list(oldkind));if(hadseed)assign('.Random.seed',oldseed,envir=.GlobalEnv) else if(exists('.Random.seed',envir=.GlobalEnv,inherits=FALSE))rm('.Random.seed',envir=.GlobalEnv)},add=TRUE)
 d<-guane_asr_continuous_data(tree,traits,taxon,trait)
 integer_ok<-function(z,lo,hi)length(z)==1 && is.numeric(z) && is.finite(z) && z==floor(z) && z>=lo && z<=hi
 if(!integer_ok(ngen,100,2000000) || !integer_ok(sample,1,ngen) || ngen%%sample!=0 || !integer_ok(burnin,0,ngen-1) || !integer_ok(chains,1,4) || !integer_ok(seed,0,2147483646-chains))stop('Invalid MCMC settings: generations must be divisible by sampling interval; choose 1–4 chains and a valid seed and burn-in.')
 if(sum(seq(0,ngen,by=sample)>burnin)<20)stop('Retain at least 20 saved draws per chain after burn-in.')
 if(length(spread)!=1 || !is.numeric(spread) || !is.finite(spread) || spread<0 || spread>10)stop('Chain starting spread must be between 0 and 10.')
 if(chains*ngen*(length(d$x)+tree$Nnode-1)^2>8e9 || chains*(ngen/sample+1)*(tree$Nnode+3)>2e6)stop('Requested Bayesian workload is too large; reduce generations, chains or saved draws.')
 if(any(tree$edge.length<=10*.Machine$double.eps))stop('Bayesian BM requires branch lengths above the numerical zero threshold.')
 spec<-guane_bayes_controls(tree,traits,taxon,trait,parameters,sample)
 full<-controls<-vector('list',chains);warnings<-character()
 for(i in seq_len(chains)) {
  con<-spec$control
  # Deterministic dispersed starts; exact effective starts are saved per chain.
  offset<-if(i==1)0 else (-1)^i*spread*ceiling((i-1)/2)
  con$sig2<-con$sig2*exp(offset/4);con$a<-con$a+offset*sqrt(con$prop[2]);con$y<-con$y+offset*sqrt(con$prop[-c(1,2)])
  controls[[i]]<-con
  set.seed(seed+i-1,kind='Mersenne-Twister',normal.kind='Inversion',sample.kind='Rejection')
  fit<-withCallingHandlers(phytools::anc.Bayes(tree,d$x,ngen=ngen,control=con),message=function(m)invokeRestart('muffleMessage'),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
  z<-fit$mcmc
  if(!identical(names(z),c('gen','sig2',as.character(length(d$x)+seq_len(tree$Nnode)),'logLik')) || !identical(as.numeric(z$gen),seq(0,ngen,by=sample)) || any(!is.finite(as.matrix(z))) || any(z$sig2<=0))stop('The sampler returned invalid or incomplete posterior draws.')
  full[[i]]<-z
 }
 retained<-lapply(full,function(z)z[z$gen>burnin,,drop=FALSE])
 diagnostics<-guane_bayes_diagnostics(retained)
 if(chains<2)warnings<-c(warnings,'One chain cannot assess between-chain convergence; split-Rhat is unavailable.')
 if(chains>=2 && any(!is.finite(diagnostics$SplitRhat) | diagnostics$SplitRhat>1.01))warnings<-c(warnings,'Split-Rhat exceeds 1.01 or is unavailable. Do not treat this run as converged.')
 if(any(!is.finite(diagnostics$ESS) | diagnostics$ESS<400))warnings<-c(warnings,'Effective sample size is below 400 or unavailable. Longer or better-tuned chains are needed.')
 nodes<-as.character(length(d$x)+seq_len(tree$Nnode));nd<-diagnostics[match(nodes,diagnostics$Parameter),]
 ace<-setNames(nd$Mean,nodes);merged<-do.call(rbind,lapply(seq_along(retained),function(i)data.frame(Chain=i,retained[[i]],check.names=FALSE)))
 list(tree=tree,traits=d$traits,taxon=taxon,trait=trait,x=d$x,ace=ace,nodes=data.frame(Node=as.integer(nodes),Estimate=nd$Mean,Variance=nd$SD^2,Lower=nd$Lower,Upper=nd$Upper),root=ace[1],rate=diagnostics$Mean[diagnostics$Parameter=='sig2'],logLik=NA_real_,warnings=unique(warnings),model='BM',engine='anc.Bayes',backend_version=as.character(utils::packageVersion('phytools')),
  likelihood_basis='Bayesian BM samples the joint posterior of diffusion and all ancestral states. No ML likelihood or AIC ranking is reported.',
  uncertainty='Posterior means and equal-tailed 95% credible intervals integrate diffusion and ancestral-state uncertainty under the specified priors; the tree is fixed. Inspect chain diagnostics before interpretation.',
  bayes=list(full=full,retained=retained,draws=merged,diagnostics=diagnostics,parameters=spec$parameters,controls=controls,seeds=seed+seq_len(chains)-1,ngen=ngen,sample=sample,burnin=burnin,chains=chains),
  inputs=list(tree=tree,traits=traits,taxon=taxon,trait=trait,ngen=ngen,sample=sample,burnin=burnin,chains=chains,seed=seed,spread=spread,parameters=spec$parameters))
}

# Literal dput of long MCMC tables is slow to parse. Embed compressed saved data;
# the graph functions and plot_settings remain ordinary editable R code.
