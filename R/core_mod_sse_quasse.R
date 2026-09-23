# Continuous-state SSE adapter. All computations are independent of Shiny.
core_mod_sse_quasse <- function() list(implemented=TRUE)
guane_quasse_function <- function(type) {
 switch(type,Constant=function(x,c)rep(c,length(x)),Exponential=function(x,base,slope)base*exp(slope*x),Sigmoid=function(x,y0,y1,xmid,r)y0+(y1-y0)*stats::plogis(r*(x-xmid)),stop('Select supported QuaSSE rate functions.'))
}
guane_quasse_data <- function(tree,traits,taxon,trait,error=1,error_column='') {
 guane_ltt(tree)
 if(!ape::is.binary(tree)||length(tree$tip.label)<4||inherits(tree,'clade.tree'))stop('QuaSSE requires a resolved binary tree with at least four tips.')
 if(!is.data.frame(traits)||anyDuplicated(names(traits))||length(taxon)!=1||length(trait)!=1||!all(c(taxon,trait)%in%names(traits))||taxon==trait)stop('Select separate taxon and continuous-trait columns.')
 ids<-as.character(traits[[taxon]]);x<-traits[[trait]]
 if(anyNA(ids)||anyDuplicated(ids)||any(!nzchar(trimws(ids)))||!setequal(ids,tree$tip.label))stop('Match tree and trait taxa explicitly in Data before QuaSSE.')
 if(!is.numeric(x)||any(!is.finite(x))||diff(range(x))<=0)stop('QuaSSE requires finite, nonconstant continuous observations.')
 if(length(error_column)!=1||is.na(error_column)||nzchar(error_column)&&!error_column%in%names(traits))stop('Select a valid measurement-error column.')
 sd<-if(nzchar(error_column))traits[[error_column]] else rep(error,length(x))
 if(!is.numeric(sd)||length(sd)!=length(x)||any(!is.finite(sd))||any(sd<=0))stop('QuaSSE measurement standard errors must be positive and finite.')
 i<-match(tree$tip.label,ids);states<-setNames(x[i],tree$tip.label);sd<-setNames(sd[i],tree$tip.label)
 attr(tree,'order')<-NULL;tree<-ape::reorder.phylo(tree,'cladewise');tree$root.edge<-NULL
 list(tree=tree,states=states,sd=sd)
}
guane_quasse_control <- function(d,nx=1024,r=4,step=.001,tc=.1,range_mult=5,xmid=NULL,w=5,method='fftC',tips=FALSE) {
 scalar<-function(x)is.numeric(x)&&length(x)==1&&is.finite(x)
 if(!scalar(nx)||!nx%in%c(128,256,512,1024,2048,4096)||!scalar(r)||!r%in%c(1,2,4,8)||!scalar(step)||step<1e-5||step>.05||!scalar(tc)||tc<=0||tc>=1||!scalar(range_mult)||range_mult<3||range_mult>30||!scalar(w)||w<3||w>10||length(method)!=1||!method%in%c('fftC','fftR')||!is.logical(tips)||length(tips)!=1||is.na(tips)||tips&&method!='fftC')stop('Invalid QuaSSE integration settings.')
 if(is.null(xmid))xmid<-mean(range(d$states))
 if(!scalar(xmid)||max(abs(d$states-xmid))>=diff(range(d$states))*range_mult/2)stop('The QuaSSE grid must contain all observed trait values.')
 age<-max(ape::branching.times(d$tree))
 list(nx=nx,r=r,dt.max=age*step,tc=age*tc,xr.mult=range_mult,xmid=xmid,w=w,method=method,tips.combined=tips)
}
guane_quasse_parameters <- function(d,lambda='Constant',mu='Constant',text='') {
 age<-max(ape::branching.times(d$tree));xr<-diff(range(d$states));mid<-mean(range(d$states));base<-(length(d$states)-2)/sum(d$tree$edge.length)
 part<-function(type,prefix,rate){
  vals<-switch(type,Constant=c(c=rate),Exponential=c(base=rate,slope=0),Sigmoid=c(y0=rate*.5,y1=rate*1.5,xmid=mid,r=1/xr),stop('Select supported QuaSSE rate functions.'))
  lo<-rep(0,length(vals));hi<-rep(100/age,length(vals))
  if(type=='Exponential'){lo[2]<--5/max(abs(d$states),xr);hi[2]<--lo[2]}
  if(type=='Sigmoid'){lo[3:4]<-c(min(d$states)-xr,-20/xr);hi[3:4]<-c(max(d$states)+xr,20/xr)}
  data.frame(Parameter=paste0(prefix,names(vals)),Group=paste0(prefix,gsub('[.]','_',names(vals))),Fixed=NA_real_,Start=unname(vals),Lower=lo,Upper=hi)
 }
 tab<-rbind(part(lambda,'l.',base),part(mu,'m.',base/2),data.frame(Parameter=c('drift','diffusion'),Group=c('drift','diffusion'),Fixed=c(0,NA),Start=c(0,stats::var(d$states)/age),Lower=c(-10*xr/age,xr^2/age*1e-7),Upper=c(10*xr/age,xr^2/age*10)))
 tab$Group<-gsub('[.]','_',tab$Group);expected<-tab$Parameter;positive<-!grepl('slope|xmid|[.]r$|^drift$',expected)
 if(length(text)!=1||is.na(text))stop('Invalid QuaSSE parameter table.')
 if(nzchar(trimws(text))){
  z<-tryCatch(utils::read.csv(text=text,stringsAsFactors=FALSE,check.names=FALSE,na.strings=c('','NA')),error=function(e)stop('Invalid QuaSSE parameter table.'))
  if(!identical(names(z),names(tab))||anyDuplicated(z$Parameter)||!setequal(z$Parameter,expected))stop('Invalid QuaSSE parameter table.')
  tab<-z[match(expected,z$Parameter),,drop=FALSE]
  for(n in c('Fixed','Start','Lower','Upper')){old<-tab[[n]];tab[[n]]<-suppressWarnings(as.numeric(old));if(any(!is.na(old)&is.na(tab[[n]])))stop('Invalid QuaSSE parameter table.')}
 }
 if(anyNA(tab$Group)||any(!grepl('^[A-Za-z][A-Za-z0-9_]*$',tab$Group))||any(!is.finite(as.matrix(tab[c('Start','Lower','Upper')])) )||any(tab$Lower>=tab$Upper)||any(tab$Start<tab$Lower|tab$Start>tab$Upper)||any(positive&tab$Lower<0)||tab$Lower[tab$Parameter=='diffusion']<=0||any(!is.na(tab$Fixed)&(!is.finite(tab$Fixed)|tab$Fixed<tab$Lower|tab$Fixed>tab$Upper)))stop('QuaSSE starts, fixed parameters and bounds are inconsistent.')
 guane_sse_constraint_groups(tab,'QuaSSE');tab
}
guane_quasse_likelihood <- function(d,lambda,mu,control,sampling=1,survival=TRUE,root='OBS',root_mean=0,root_sd=1) {
 if(length(sampling)!=1||!is.finite(sampling)||sampling<=0||sampling>1||length(survival)!=1||!is.logical(survival)||is.na(survival)||length(root)!=1||!root%in%c('OBS','FLAT','GIVEN')||length(root_mean)!=1||!is.finite(root_mean)||length(root_sd)!=1||!is.finite(root_sd)||root_sd<=0)stop('Invalid QuaSSE sampling or root settings.')
 f<-diversitree::make.quasse(d$tree,d$states,d$sd,guane_quasse_function(lambda),guane_quasse_function(mu),control=control,sampling.f=sampling)
 expected<-guane_quasse_parameters(d,lambda,mu)$Parameter
 if(!identical(diversitree::argnames(f),expected))stop('QuaSSE backend parameter order is incompatible.')
 rid<-switch(root,OBS=diversitree::ROOT.OBS,FLAT=diversitree::ROOT.FLAT,GIVEN=diversitree::ROOT.GIVEN)
 function(pars)f(pars,condition.surv=survival,root=rid,root.f=if(root=='GIVEN')function(x)stats::dnorm(x,root_mean,root_sd) else NULL)
}
guane_quasse_fit <- function(tree,traits,taxon,trait,error=1,error_column='',lambda='Constant',mu='Constant',parameter_text='',baseline=TRUE,sampling=1,survival=TRUE,root='OBS',root_mean=0,root_sd=1,nx=1024,r=4,step=.001,tc=.1,range_mult=5,xmid=NULL,w=5,method='fftC',tips=FALSE,optimizer='nlminb',starts=2,maxit=200,slices=FALSE,verify=TRUE) {
 inputs<-as.list(environment());d<-guane_quasse_data(tree,traits,taxon,trait,error,error_column)
 control<-guane_quasse_control(d,nx,r,step,tc,range_mult,xmid,w,method,tips)
 scalar<-function(x)is.numeric(x)&&length(x)==1&&is.finite(x)
 if(!scalar(starts)||starts<1||starts>8||starts!=floor(starts)||!scalar(maxit)||maxit<10||maxit>5000||maxit!=floor(maxit)||length(optimizer)!=1||!optimizer%in%c('nlminb','L-BFGS-B')||!all(vapply(list(baseline,slices),function(x)is.logical(x)&&length(x)==1&&!is.na(x),logical(1))))stop('Invalid QuaSSE optimizer settings.')
 specs<-list(Selected=c(lambda,mu));if(baseline&&(lambda!='Constant'||mu!='Constant'))specs$Constant<-c('Constant','Constant')
 fits<-list();all<-list();build_warnings<-character()
 for(model in names(specs)){
  types<-specs[[model]];tab<-guane_quasse_parameters(d,types[1],types[2],if(model=='Selected')parameter_text else '')
  con<-guane_sse_constraint_groups(tab,'QuaSSE')
  # Equal drift/diffusion treatment is essential for the optional constant comparator.
  if(model=='Constant'){
   selected<-fits$Selected$constraint
   # If the selected fit failed, use its validated input constraints instead.
   if(is.null(selected))selected<-guane_sse_constraint_groups(guane_quasse_parameters(d,lambda,mu,parameter_text),'QuaSSE')
   for(n in c('drift','diffusion')){j<-match(n,tab$Parameter);v<-selected$table[match(n,selected$table$Parameter),];tab[j,c('Fixed','Start','Lower','Upper')]<-v[c('Fixed','Start','Lower','Upper')]}
   con<-guane_sse_constraint_groups(tab,'QuaSSE')
  }
  build<-function(ctrl)withCallingHandlers(guane_quasse_likelihood(d,types[1],types[2],ctrl,sampling,survival,root,root_mean,root_sd),warning=function(w){build_warnings<<-unique(c(build_warnings,conditionMessage(w)));invokeRestart('muffleWarning')})
  lik<-build(control);fine<-control;fine$nx<-control$nx*2;fine$dt.max<-control$dt.max/2;precise_raw<-build(fine)
  # diversitree 0.10.1 make.rootfunc.quasse includes dx^2 under survival conditioning.
  # Keep fitted likelihoods native; put refinement on the original grid's normalization.
  adjustment<-if(survival)2*log(fine$nx/control$nx) else 0
  precise<-function(p)precise_raw(p)+adjustment
  ans<-guane_sse_optimize(model,setNames(list(con),model),lik,precise,1,optimizer,starts,maxit,slices,character(),'QuaSSE',verify)
  if(!is.null(ans$diagnostics)){ans$diagnostics$RawRefinedLogLik<-ans$diagnostics$TighterLogLik-adjustment;ans$diagnostics$GridNormalizationAdjustment<-adjustment}
  ans$warnings[ans$warnings=='QuaSSE likelihood changed under tighter integration tolerance. Ranking weights are withheld.']<-'QuaSSE likelihood changed after grid-normalized refinement. Model weights are withheld.'
  fits[[model]]<-ans$fits[[model]];all[[model]]<-ans
 }
 combine<-function(n)do.call(rbind,lapply(all,`[[`,n));comparison<-combine('comparison');comparison$Weight<-comparison$DeltaAIC<-NA_real_
 warnings<-unique(c(build_warnings,unlist(lapply(all,`[[`,'warnings')),'QuaSSE is exploratory: hidden rate heterogeneity can mimic trait dependence. No uncertainty intervals or hidden-state null models are provided.','Measurement errors are standard errors of trait means, in the supplied trait units. They are treated as known.','Grid and time-step sensitivity checks evaluate fitted parameters without refitting. They do not guarantee numerical convergence.','Refined likelihoods account for the backend grid-spacing constant under survival conditioning. Raw refined values and the adjustment are shown separately; compare AIC only within this run.'))
 coarse<-diff(range(d$states))*range_mult/nx/r>min(d$sd)
 if(coarse)warnings<-c(warnings,'The tip grid is coarser than a measurement standard error. Increase resolution; model weights are withheld.')
 if(length(d$states)<100)warnings<-c(warnings,'Few taxa or imbalanced states can give weakly identified rates. This is a screening warning, not a sufficiency threshold.')
 if(!is.null(tree$root.edge)&&tree$root.edge>0)warnings<-c(warnings,'Supplied stem excluded; this analysis uses a crown-tree likelihood.')
 # A selected rate function can represent the constant comparator unless custom constraints restrict it.
 if(length(fits)==2&&isTRUE(fits$Selected$valid)&&isTRUE(fits$Constant$valid)){
  p<-fits$Selected$par;q<-fits$Constant$par
  for(prefix in c('l.','m.')){idx<-startsWith(names(p),prefix);nm<-names(p)[idx];p[idx]<-vapply(substring(nm,3),function(n)switch(n,c=q[paste0(prefix,'c')],base=q[paste0(prefix,'c')],slope=0,y0=q[paste0(prefix,'c')],y1=q[paste0(prefix,'c')],xmid=mean(range(d$states)),r=1/diff(range(d$states))),numeric(1))}
  p[c('drift','diffusion')]<-q[c('drift','diffusion')];z<-fits$Selected$constraint$table
  feasible<-all(p>=z$Lower&p<=z$Upper)&&all(is.na(z$Fixed)|abs(p-z$Fixed)<1e-10)&&all(vapply(split(p,z$Group),function(v)diff(range(v))<1e-10,logical(1)))
  if(feasible&&fits$Constant$logLik>fits$Selected$logLik+1e-4){fits$Selected$better_failed<-TRUE;warnings<-c(warnings,'Another candidate supplies a better feasible point. Refit before interpreting model support.')}
 }
 rank<-length(fits)>1&&!coarse&&all(vapply(fits,function(f)isTRUE(f$valid)&&isTRUE(f$stable)&&!isTRUE(f$better_failed)&&f$spread<=1e-4&&isTRUE(f$verified)&&!isTRUE(f$boundary)&&isTRUE(f$all_converged)&&(starts>=2||f$k==0),logical(1)))
 if(rank){comparison$DeltaAIC<-comparison$AIC-min(comparison$AIC);comparison$Weight<-exp(-comparison$DeltaAIC/2)/sum(exp(-comparison$DeltaAIC/2))}
 c(d,list(trait=trait,specs=specs,control=control,fits=fits,comparison=comparison,estimates=combine('estimates'),diagnostics=combine('diagnostics'),attempts=combine('attempts'),slices=combine('slices'),warnings=unique(warnings),version=as.character(utils::packageVersion('diversitree')),inputs=inputs))
}
guane_quasse_settings <- function(type='rates',model='Selected',parameter='diffusion',palette='Guane',labels=TRUE,label_size=.7,width=10,height=7,lang='en') {
 if(length(type)!=1||!type%in%c('rates','tree','observations','comparison','starts','slice','robustness','verification'))stop('Select a supported QuaSSE graph.')
 s<-tryCatch(guane_bisse_settings('rates',model,parameter,palette,labels,label_size,width,height,lang),error=function(e)stop(sub('BiSSE','QuaSSE',conditionMessage(e),fixed=TRUE)));s$type<-type;s
}
guane_quasse_plot <- function(result,settings=guane_quasse_settings()) {
 if(identical(settings$type,'verification'))return(guane_sse_verification_plot(result,settings))
 if(identical(settings$type,'robustness'))return(guane_quasse_robustness_plot(result,settings))
 s<-do.call(guane_quasse_settings,settings);txt<-function(x)guane_text(x,s$lang)
 if(s$type%in%c('comparison','starts','slice'))return(tryCatch(guane_bisse_plot(result,s),error=function(e)stop(sub('BiSSE','QuaSSE',conditionMessage(e),fixed=TRUE))))
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old));graphics::par(mar=c(6,5,3,2))
 cols<-switch(s$palette,Grayscale=c('#222222','#888888'),Legacy=c('#02b2ce','#e52920'),c('#26734f','#bd6731'))
 if(s$type=='rates'){
  f<-result$fits[[s$model]];if(!isTRUE(f$valid))stop('No valid QuaSSE fit. Inspect diagnostics.')
  x<-seq(min(result$states),max(result$states),length.out=201);types<-result$specs[[s$model]]
  rate<-function(type,prefix)do.call(guane_quasse_function(type),c(list(x=x),unname(as.list(f$par[startsWith(names(f$par),prefix)]))))
  l<-rate(types[1],'l.');m<-rate(types[2],'m.')
  graphics::matplot(x,cbind(l,m),type='l',lty=1:2,lwd=2,col=cols,xlab=result$trait,ylab=txt('Rate per branch-length unit'),main=paste('QuaSSE:',txt(s$model)))
  graphics::rug(result$states,col='#777777');graphics::legend('topright',c('lambda','mu'),lty=1:2,lwd=2,col=cols,bty='n')
  graphics::mtext(txt('Point estimates only; uncertainty intervals are not available'),side=1,line=4.5,cex=.7)
 } else if(s$type=='observations'){
  n<-length(result$states);graphics::par(mar=c(6,if(s$labels)10 else 4,3,2))
  graphics::plot(result$states,seq_len(n),xlim=range(c(result$states-result$sd,result$states+result$sd)),yaxt='n',pch=19,cex=.7,col=cols[1],xlab=result$trait,ylab='',main=txt('Observed traits and measurement standard errors'))
  graphics::segments(result$states-result$sd,seq_len(n),result$states+result$sd,seq_len(n),col=cols[1]);graphics::axis(2,seq_len(n),if(s$labels)names(result$states) else seq_len(n),las=1,cex.axis=s$label_size);graphics::mtext(txt('Bars show plus/minus one measurement standard error, not confidence intervals.'),side=1,line=4.5,cex=.7)
 } else if(s$type=='tree'){
  pal<-if(s$palette=='Grayscale')grDevices::gray.colors(100,.15,.85) else grDevices::hcl.colors(100,'viridis');x<-result$states[result$tree$tip.label];i<-1+floor(99*(x-min(x))/diff(range(x)))
  ape::plot.phylo(result$tree,show.tip.label=s$labels,underscore=TRUE,cex=s$label_size,label.offset=max(ape::branching.times(result$tree))*.02,main=paste('QuaSSE:',result$trait),no.margin=FALSE)
  ape::tiplabels(pch=21,bg=pal[i],cex=.8);graphics::legend('topleft',legend=signif(seq(min(x),max(x),length.out=5),4),pch=21,pt.bg=pal[round(seq(1,100,length.out=5))],bty='n',cex=.7)
  graphics::mtext(txt('Observed tip states; no ancestral reconstruction'),side=1,line=4.5,cex=.7)
 }
 invisible(result)
}
guane_quasse_script <- function(result,settings=guane_quasse_settings()) {
 functions<-c('guane_sse_verification_plot','guane_quasse_robustness','guane_quasse_robustness_plot','guane_ltt','guane_sse_expand','guane_sse_constraint_groups','guane_sse_optimize','guane_bisse_settings','guane_bisse_plot','guane_quasse_function','guane_quasse_data','guane_quasse_control','guane_quasse_parameters','guane_quasse_likelihood','guane_quasse_fit','guane_quasse_settings','guane_quasse_plot','guane_text')
 c('# GUane QuaSSE: original data, saved fit and editable plotting settings.', '# Requires ape and diversitree; no GUane installation required.',paste('# Original diversitree version:',result$version),
 vapply(functions,function(n)paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),guane_r_assignment('result',result),guane_r_assignment('settings',settings),
 '# Optional refit: result <- do.call(guane_quasse_fit,result$inputs)',
 '# Optional robustness replay: result$robustness <- do.call(guane_quasse_robustness,c(list(result=result),result$robustness$settings))','opened <- grDevices::dev.cur() == 1L','if(opened) grDevices::pdf("guane-quasse.pdf",width=settings$width,height=settings$height)','guane_quasse_plot(result,settings)','if(opened) grDevices::dev.off()','print(result$comparison)','print(result$diagnostics)','print(result$warnings)','sessionInfo()')
}

# Refits preserve the saved original estimates. Raw and normalized scores remain separate.
guane_quasse_robustness <- function(result,domain_factor=1.5) {
 if(length(domain_factor)!=1||!is.finite(domain_factor)||domain_factor<=1||domain_factor>2||result$inputs$nx>2048||result$inputs$range_mult*domain_factor>30)stop('Robustness requires nx at most 2048 and a widened domain multiplier at most 30.')
 if(!all(vapply(result$fits,function(f)isTRUE(f$valid),logical(1))))stop('Resolve failed fits before robustness refits.')
 original<-result$inputs;variants<-list(Refined=modifyList(original,list(nx=original$nx*2,step=max(1e-5,original$step/2),slices=FALSE,verify=TRUE)),Wider=modifyList(original,list(range_mult=original$range_mult*domain_factor,nx=original$nx*2,slices=FALSE,verify=TRUE)))
 rows<-list();refits<-list()
 for(name in names(variants)){
  o<-variants[[name]];a<-tryCatch(do.call(guane_quasse_fit,o),error=identity);refits[name]<-list(if(inherits(a,'error'))NULL else a)
  for(model in names(result$fits)){
   f<-if(inherits(a,'error'))NULL else a$fits[[model]];valid<-isTRUE(f$valid)
   adjustment<-if(original$survival)2*log((o$nx/original$nx)*(original$range_mult/o$range_mult)) else 0
   compatible<-!(name=='Wider'&&original$root=='FLAT')
   aligned<-if(valid&&compatible)f$logLik+adjustment else NA_real_
   rows[[length(rows)+1]]<-data.frame(Variant=name,Model=model,Nx=o$nx,DomainMultiplier=o$range_mult,Step=o$step,RawLogLik=if(valid)f$logLik else NA_real_,NormalizationAdjustment=adjustment,Comparable=compatible,AlignedLogLik=aligned,Change=aligned-result$fits[[model]]$logLik,Converged=valid,Verified=valid&&isTRUE(f$verified),Stable=valid&&isTRUE(f$stable),Repeatable=valid&&f$spread<=1e-4&&!isTRUE(f$better_failed)&&isTRUE(f$all_converged),Boundary=if(valid)f$boundary else NA,Message=if(inherits(a,'error'))conditionMessage(a) else if(!compatible)'Wider FLAT root domain changes the root prior; likelihoods are not compared.' else paste(a$warnings,collapse=' | '))
  }
 }
 table<-do.call(rbind,rows)
 pass<-all(table$Comparable&table$Converged&table$Verified&table$Stable&table$Repeatable&!table$Boundary&is.finite(table$Change)&abs(table$Change)<=1e-4)
 list(table=table,refits=refits,passed=pass,settings=list(domain_factor=domain_factor),warning='Robustness refits preserve original estimates. Unresolved grid or domain sensitivity withholds weights; no uncertainty interval is implied.')
}
guane_quasse_robustness_plot <- function(result,settings) {
 x<-result$robustness$table;if(is.null(x))stop('Run robustness refits first.')
 ok<-is.finite(x$Change);if(!any(ok))stop('No comparable robustness refit; inspect diagnostics.')
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old));txt<-function(x)guane_text(x,settings$lang)
 graphics::par(mar=c(6,10,3,2));graphics::barplot(x$Change[ok],names.arg=paste(vapply(x$Variant[ok],txt,character(1)),vapply(x$Model[ok],txt,character(1)),sep="\n"),horiz=TRUE,las=1,col=if(settings$palette=='Grayscale')'#777777' else '#26734f',xlab=guane_text('Change in aligned log likelihood',settings$lang),main=guane_text('Grid and domain refits',settings$lang));graphics::abline(v=0,lty=2)
}
