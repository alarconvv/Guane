core_mod_div_joint <- function() list(implemented=TRUE)

guane_rates_joint_data <- function(tree,nodes,sampling=NULL,split_t=Inf) {
 catalog<-guane_rates_clade_catalog(tree);tree<-catalog$tree;n<-length(tree$tip.label)
 if(!is.numeric(nodes)||!length(nodes)||length(nodes)>4||any(!is.finite(nodes))||anyDuplicated(nodes)||any(nodes!=floor(nodes))||any(!nodes%in%setdiff(catalog$table$Node,n+1)))stop('Choose one to four non-root shift nodes with at least four descendant tips.')
 if(length(split_t)!=1||!identical(as.numeric(split_t),Inf))stop('This backend supports branch-base shifts only (split.t = Inf).')
 depth<-ape::node.depth.edgelength(tree);nodes<-as.integer(nodes[order(depth[nodes],nodes)])
 regions<-c(0L,nodes);group<-rep(0L,n+tree$Nnode)
 for(node in nodes){tips<-catalog$descendants[[node]];inside<-which(vapply(catalog$descendants,function(x)length(x)>0&&all(x%in%tips),logical(1)));group[inside]<-node}
 counts<-tabulate(match(group[seq_len(n)],regions),length(regions))
 if(any(counts<2))stop('Each joint region, including the background, must retain at least two sampled tips.')
 if(is.null(sampling))sampling<-data.frame(Region=regions,Sampling=1)
 if(!is.data.frame(sampling)||!identical(sort(names(sampling)),c('Region','Sampling'))||nrow(sampling)!=length(regions)||!is.numeric(sampling$Region)||anyNA(sampling$Region)||anyDuplicated(sampling$Region)||!setequal(sampling$Region,regions)||!is.numeric(sampling$Sampling)||any(!is.finite(sampling$Sampling))||any(sampling$Sampling<=0|sampling$Sampling>1))stop('Use Region,Sampling with background 0 and every shift node exactly once; fractions must be in (0,1].')
 tab<-data.frame(Region=regions,Sampling=sampling$Sampling[match(regions,sampling$Region)],Tips=counts,Shift_age=c(NA_real_,depth[tree$edge[match(nodes,tree$edge[,2]),1]]))
 tab$Shift_age[-1]<-max(depth[seq_len(n)])-tab$Shift_age[-1]
 # Keep existing scientific labels in the snapshot; the backend gets unique labels internally.
 list(tree=tree,nodes=nodes,regions=tab,group=group,edges=data.frame(Parent=tree$edge[,1],Child=tree$edge[,2],Region=group[tree$edge[,2]],Length=tree$edge.length),membership=data.frame(Taxon=tree$tip.label,Region=group[seq_len(n)]),age=max(depth[seq_len(n)]),split_t=Inf)
}

guane_rates_joint_csv <- function(text) {
 if(is.null(text)||!nzchar(trimws(text)))return(NULL)
 tryCatch(utils::read.csv(text=text,check.names=FALSE,stringsAsFactors=FALSE),error=function(e)stop('Invalid joint-model CSV table.'))
}

guane_rates_joint_map <- function(regions,model,custom=NULL) {
 k<-length(regions);L<-rep('lambda',k);M<-rep('mu',k)
 if(model=='SharedYule')M[]<-'0'
 if(model%in%c('ShiftLambda','ShiftBoth'))L<-paste0('lambda',regions)
 if(model%in%c('ShiftMu','ShiftBoth'))M<-paste0('mu',regions)
 if(model=='Custom'){
  if(!is.data.frame(custom)||!identical(sort(names(custom)),c('Lambda','Mu','Region'))||nrow(custom)!=k||anyNA(custom)||anyDuplicated(custom$Region)||!setequal(custom$Region,regions))stop('Custom constraints require Region,Lambda,Mu for every region exactly once.')
  custom<-custom[match(regions,custom$Region),];L<-as.character(custom$Lambda);M<-as.character(custom$Mu)
 }
 tokens<-as.vector(rbind(L,M));fixed<-suppressWarnings(as.numeric(tokens));free<-is.na(fixed)
 if(any(!is.finite(fixed[!free]))||any(fixed[!free]<0)||any(!free[seq(1,2*k,2)]&fixed[seq(1,2*k,2)]<=0)||any(!grepl('^[A-Za-z][A-Za-z0-9_]*$',tokens[free])))stop('Constraints must be nonnegative fixed rates or parameter names; speciation must be positive.')
 if(length(intersect(L[is.na(suppressWarnings(as.numeric(L)))],M[is.na(suppressWarnings(as.numeric(M)))])))stop('Do not share a parameter name between speciation and extinction.')
 list(table=data.frame(Region=regions,Lambda=L,Mu=M),tokens=tokens,fixed=fixed,free=unique(tokens[free]),index=match(tokens,unique(tokens[free])))
}

guane_rates_joint_likelihood <- function(data) {
 tr<-data$tree;tr$node.label<-paste0('node_',seq_len(tr$Nnode))
 diversitree::make.bd.split(tr,nodes=data$nodes,split.t=Inf,sampling.f=data$regions$Sampling)
}

guane_rates_joint_fit <- function(tree,nodes,sampling=NULL,models=c('SharedYule','SharedBD','ShiftLambda','ShiftMu','ShiftBoth'),custom=NULL,controls=NULL,survival=TRUE,optimizer='nlminb',maxit=2000,upper=NULL,intervals=TRUE,split_t=Inf) {
 original<-tree;data<-guane_rates_joint_data(tree,nodes,sampling,split_t);age<-data$age
 allowed<-c('SharedYule','SharedBD','ShiftLambda','ShiftMu','ShiftBoth','Custom')
 if(!length(models)||anyNA(models)||anyDuplicated(models)||any(!models%in%allowed))stop('Choose at least one supported joint model.')
 if(!all(vapply(list(survival,intervals),function(x)is.logical(x)&&length(x)==1&&!is.na(x),logical(1))))stop('Invalid rate analysis settings.')
 if(length(optimizer)!=1||!optimizer%in%c('nlminb','L-BFGS-B')||length(maxit)!=1||!is.finite(maxit)||maxit!=floor(maxit)||maxit<10||maxit>20000)stop('Invalid optimizer settings.')
 if(is.null(upper))upper<-100/age
 if(length(upper)!=1||!is.finite(upper)||upper<=1e-7/age||upper>1e6/age)stop('Rate upper bound must be positive and compatible with the tree scale.')
 maps<-stats::setNames(lapply(models,function(m)guane_rates_joint_map(data$regions$Region,m,custom)),models)
 available<-unique(unlist(lapply(maps,`[[`,'free')))
 if(!is.null(controls)){
  if(!is.data.frame(controls)||!identical(sort(names(controls)),c('Lower','Parameter','Start','Upper'))||anyNA(controls)||anyDuplicated(controls$Parameter)||any(!controls$Parameter%in%available)||!all(vapply(controls[c('Lower','Start','Upper')],is.numeric,logical(1)))||any(!is.finite(as.matrix(controls[c('Lower','Start','Upper')]))))stop('Parameter controls require Parameter,Start,Lower,Upper with unique free parameter names.')
 }
 likelihood<-guane_rates_joint_likelihood(data);allfits<-list();attempts<-estimates<-effective<-list();warn<-character()
 for(model in models){
  map<-maps[[model]];p<-length(map$free);is_lambda<-vapply(map$free,function(x)any(map$table$Lambda==x),logical(1))
  start0<-(length(data$tree$tip.label)-2)/sum(data$tree$edge.length)
  start<-ifelse(is_lambda,start0,start0*.25);lower<-ifelse(is_lambda,1e-10/age,0);higher<-rep(upper,p)
  if(!is.null(controls))for(i in seq_len(p)){j<-match(map$free[i],controls$Parameter);if(!is.na(j)){start[i]<-controls$Start[j];lower[i]<-controls$Lower[j];higher[i]<-controls$Upper[j]}}
  if(any(lower<0)||any(lower[is_lambda]<=0)||any(higher<=lower)||any(higher*age>1e6)||any(start<=lower|start>=higher))stop('Joint starts must be strictly inside valid parameter bounds; free speciation lower bounds must be positive.')
  if(any(map$fixed[is.finite(map$fixed)]*age>1e6))stop('Fixed rates exceed the supported tree scale.')
  expand<-function(v){z<-map$fixed;j<-which(!is.na(map$index));z[j]<-v[map$index[j]]/age;z}
  objective<-function(v){ll<-suppressWarnings(tryCatch(likelihood(expand(v),condition.surv=survival),error=function(e)-Inf));if(is.finite(ll))-ll else 1e100}
  starts<-if(p)unique(rbind(start,start*.5,start*2,ifelse(is_lambda,start*1.5,start*.1),ifelse(is_lambda,start*.5,start*1.5))*age) else matrix(numeric(),nrow=1,ncol=0)
  if(p)for(i in seq_len(p))starts[,i]<-pmin(higher[i]*age-.000001*(higher[i]-lower[i])*age,pmax(lower[i]*age+.000001*(higher[i]-lower[i])*age,starts[,i]))
  rows<-lapply(seq_len(nrow(starts)),function(i){
   fit<-tryCatch(if(!p)list(par=numeric(),convergence=0,message='Fixed rates') else if(optimizer=='nlminb')stats::nlminb(starts[i,],objective,lower=lower*age,upper=higher*age,control=list(iter.max=maxit,eval.max=4*maxit,rel.tol=1e-10)) else stats::optim(starts[i,],objective,method='L-BFGS-B',lower=lower*age,upper=higher*age,control=list(maxit=maxit,factr=1e7)),error=identity)
   if(inherits(fit,'error'))return(list(row=data.frame(Model=model,Start=i,LogLik=NA_real_,Convergence=99,Message=conditionMessage(fit)),fit=NULL))
   ll<- -objective(fit$par);list(row=data.frame(Model=model,Start=i,LogLik=if(ll> -1e99)ll else NA_real_,Convergence=fit$convergence,Message=if(ll<= -1e99||!is.finite(ll))'Non-finite split likelihood; inspect fixed rates, bounds and lambda = mu.' else if(is.null(fit$message))'' else fit$message),fit=fit)
  })
  tab<-do.call(rbind,lapply(rows,`[[`,'row'));attempts[[model]]<-tab;good<-which(tab$Convergence==0&is.finite(tab$LogLik))
  if(p)effective[[model]]<-data.frame(Model=model,Parameter=map$free,Start=start,Lower=lower,Upper=higher)
  if(!length(good)){allfits[[model]]<-list(valid=FALSE,k=p);warn<-c(warn,'A joint model failed; comparison weights are withheld.');next}
  best<-good[which.max(tab$LogLik[good])];v<-rows[[best]]$fit$par;rates<-expand(v)
  boundary<-p&&any(v<=lower*age+1e-6*pmax(1,abs(v))|v>=higher*age-1e-6*pmax(1,abs(v)))
  H<-V<-NULL
  if(intervals&&p&&!boundary){H<-tryCatch(stats::optimHess(v,objective),error=function(e)NULL);if(!is.null(H)&&all(is.finite(H))&&min(eigen(H,symmetric=TRUE,only.values=TRUE)$values)>0&&kappa(H)<1e8)V<-solve(H)/age^2}
  if(boundary)warn<-c(warn,'A joint estimate reaches a parameter bound; curvature intervals are withheld.')
  if(intervals&&p&&!boundary&&is.null(V))warn<-c(warn,'Joint likelihood curvature is unstable; intervals are unavailable.')
  if(length(good)>1&&diff(range(tab$LogLik[good]))>1e-4)warn<-c(warn,'Joint optimizer starts disagree; inspect local optima.')
  if(any(tab$Convergence!=0))warn<-c(warn,'Some joint optimizer starts failed; inspect all attempts.')
  est<-lapply(seq_len(nrow(map$table)),function(i){
   inds<-c(2*i-1,2*i);values<-c(rates[inds],rates[inds[1]]-rates[inds[2]])
   J<-matrix(0,3,p)
   for(j in 1:2)if(!is.na(map$index[inds[j]]))J[j,map$index[inds[j]]]<-1
   if(p)J[3,]<-J[1,]-J[2,]
   fixed<-rowSums(abs(J))==0;se<-rep(NA_real_,3);if(!is.null(V))se<-sqrt(pmax(0,diag(J%*%V%*%t(J))))
   se[fixed]<-NA;lo<-values-1.96*se;hi<-values+1.96*se;bad<-which(seq_along(lo)<=2&is.finite(lo)&lo<0);lo[bad]<-hi[bad]<-NA
   if(length(bad))warn<<-c(warn,'Normal intervals cross zero for a nonnegative rate; those intervals are withheld.')
   data.frame(Model=model,Region=map$table$Region[i],Parameter=c('lambda','mu','net'),Estimate=values,SE=se,Lower=lo,Upper=hi,Fixed=fixed)
  })
  estimates[[model]]<-do.call(rbind,est)
  allfits[[model]]<-list(valid=TRUE,k=p,logLik=tab$LogLik[best],boundary=boundary,parameters=stats::setNames(v/age,map$free),rates=rates,covariance=V)
 }
 comparison<-do.call(rbind,lapply(models,function(m){f<-allfits[[m]];data.frame(Model=m,Parameters=f$k,LogLik=if(f$valid)f$logLik else NA_real_,AIC=if(f$valid)2*f$k-2*f$logLik else NA_real_,Converged=f$valid,Boundary=if(f$valid)f$boundary else NA)}))
 comparison$DeltaAIC<-comparison$Weight<-NA_real_
 keys<-vapply(maps,function(m)paste(ifelse(is.na(m$index),paste0('fixed:',m$fixed),paste0('free:',m$index)),collapse='|'),character(1))
 duplicate_models<-anyDuplicated(keys)>0
 if(duplicate_models)warn<-c(warn,'Equivalent joint constraints selected; comparison weights are withheld.')
 if(nrow(comparison)>1&&all(comparison$Converged)&&!duplicate_models){d<-comparison$AIC-min(comparison$AIC);comparison$DeltaAIC<-d;comparison$Weight<-exp(-d/2)/sum(exp(-d/2))}
 data$comparison<-comparison;data$estimates<-do.call(rbind,estimates);data$attempts<-do.call(rbind,attempts);data$controls<-do.call(rbind,effective);data$constraints<-do.call(rbind,lapply(models,function(m)data.frame(Model=m,maps[[m]]$table)));data$fits<-allfits;data$warnings<-unique(warn)
 data$inputs<-list(tree=original,nodes=data$nodes,sampling=data$regions[,c('Region','Sampling')],models=models,custom=custom,controls=controls,survival=survival,optimizer=optimizer,maxit=maxit,upper=upper,intervals=intervals,split_t=Inf)
 data$version<-as.character(utils::packageVersion('diversitree'));data
}

guane_rates_joint_plot <- function(result,type='joint_tree',model='SharedBD',parameter='lambda',palette='Guane',lang='en',labels=TRUE,node_labels=TRUE,cex=.7) {
 if(length(cex)!=1||!is.finite(cex)||cex<.2||cex>2)stop('Invalid joint graph settings.')
 txt<-function(x)guane_text(x,lang);old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old));graphics::par(mar=c(5,6,4,2))
 regions<-result$regions$Region;k<-length(regions);colors<-if(palette=='Grayscale')grDevices::gray.colors(k,.15,.65) else grDevices::colorRampPalette(if(palette=='Legacy')c('#02b2ce','#bf6800','#702887') else c('#2f7d4f','#b16d00','#4660a4'))(k)
 if(type=='joint_tree'){
  tr<-result$tree;ape::plot.phylo(tr,edge.color=colors[match(result$edges$Region,regions)],edge.width=2,tip.color=colors[match(result$membership$Region,regions)],show.tip.label=labels,cex=cex,no.margin=FALSE);ape::axisPhylo(backward=FALSE)
  nodes<-c(length(tr$tip.label)+1,result$nodes)
  if(node_labels)ape::nodelabels(text=regions,node=nodes,frame='circle',bg=colors,col='white',cex=cex)
  graphics::title(main=txt('Joint diversification regions'),xlab=txt('Branch-length units'))
  graphics::mtext(txt('Region 0 is background; shifts include the incoming branch.'),side=3,line=.3,cex=.65);return(invisible(result$edges))
 }
 if(type=='joint_comparison'){
  d<-result$comparison;if(!all(is.finite(d$DeltaAIC)))stop('At least two converged compatible fits are required for comparison.')
  graphics::barplot(d$DeltaAIC,names.arg=d$Model,col=colors[1],ylab='Delta AIC',main=txt('Joint whole-tree model comparison'),cex.names=.7);return(invisible(d))
 }
 if(type=='joint_attempts'){
  d<-result$attempts;good<-is.finite(d$LogLik);if(!any(good))stop('No valid joint likelihoods.')
  delta<-rep(NA_real_,nrow(d));for(m in unique(d$Model)){ix<-which(d$Model==m&good);if(length(ix))delta[ix]<-d$LogLik[ix]-max(d$LogLik[ix])}
  graphics::plot(seq_len(nrow(d)),delta,pch=ifelse(d$Convergence==0,16,4),xaxt='n',xlab='',ylab='Delta logLik',main=txt('Joint optimizer agreement'),ylim=range(c(-1e-4,0,delta),finite=TRUE));graphics::axis(1,at=seq_len(nrow(d)),labels=paste(d$Model,d$Start),las=2,cex.axis=.5);graphics::abline(h=0,lty=2);return(invisible(d))
 }
 if(type!='joint_rates')stop('Invalid joint graph settings.')
 d<-result$estimates;if(is.null(d)||!nrow(d))stop('No valid joint likelihoods.');d<-d[d$Model==model&d$Parameter==parameter,,drop=FALSE];if(is.null(d)||!nrow(d))stop('No saved estimate for this parameter.')
 lim<-range(c(0,d$Estimate,d$Lower,d$Upper),finite=TRUE);y<-seq_len(nrow(d))
 graphics::plot(d$Estimate,y,xlim=lim,ylim=c(.5,nrow(d)+.5),pch=19,col=colors[match(d$Region,regions)],yaxt='n',ylab='',xlab=paste(parameter,txt('per branch-length unit')),main=paste(model,txt('Joint regional rates')))
 graphics::axis(2,at=y,labels=paste(txt('Region'),d$Region),las=1,cex.axis=.8);good<-is.finite(d$Lower)&is.finite(d$Upper);graphics::segments(d$Lower[good],y[good],d$Upper[good],y[good],col=colors[match(d$Region[good],regions)],lwd=2)
 graphics::mtext(txt('Bars: approximate 95% curvature intervals where available'),side=3,line=.3,cex=.65);graphics::abline(v=0,lty=3);invisible(d)
}

guane_rates_joint_script <- function(result,type='joint_tree',model='SharedBD',parameter='lambda',palette='Guane',lang='en',labels=TRUE,node_labels=TRUE,cex=.7) {
 helpers<-c('guane_ltt','guane_rates_data','guane_rates_clade_catalog','guane_rates_joint_data','guane_rates_joint_map','guane_rates_joint_likelihood','guane_rates_joint_fit','guane_rates_joint_plot','guane_text')
 c('# Guane joint whole-tree split likelihood. Branch-base shifts only; a priori regions.',
 '# install.packages(c("ape", "diversitree"))',paste('# diversitree',result$version),
 '# AIC is conditional on fixed shifts/sampling/tree. No calibrated likelihood-ratio p-values.',
 vapply(helpers,function(n)paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),
 guane_r_assignment('result',result),guane_r_assignment('settings',list(type=type,model=model,parameter=parameter,palette=palette,lang=lang,labels=labels,node_labels=node_labels,cex=cex)),
 '# Optional refit: refitted <- do.call(guane_rates_joint_fit,result$inputs)',
 'opened <- grDevices::dev.cur()==1L','if(opened) grDevices::pdf("guane-joint-rates.pdf",width=10,height=7)',
 'do.call(guane_rates_joint_plot,c(list(result=result),settings))','if(opened) grDevices::dev.off()','sessionInfo()')
}
