# MuSSE likelihood adapter; strict observed states with explicit named sampling.
core_mod_sse_musse <- function() list(implemented=TRUE)
guane_musse_names <- function(k) {
 if(length(k)!=1||!is.finite(k)||k!=floor(k)||k<2||k>8)stop('MuSSE supports two to eight observed states.')
 c(paste0('lambda',seq_len(k)),paste0('mu',seq_len(k)),unlist(lapply(seq_len(k),function(i)paste0('q',i,setdiff(seq_len(k),i)))))
}
guane_musse_models <- function() c('Full','Equal speciation','Equal extinction','Equal transitions','Symmetric transitions','Trait-independent diversification','Equal diversification and transitions','No extinction','Custom')
guane_musse_state_table <- function(traits,trait,text='') {
 if(!is.data.frame(traits)||anyDuplicated(names(traits))||length(trait)!=1||!trait%in%names(traits))stop('Select a discrete trait for MuSSE.')
 raw<-traits[[trait]];x<-as.character(raw)
 if(anyNA(x)||any(!nzchar(trimws(x)))||is.numeric(raw)&&any(!is.finite(raw)))stop('MuSSE requires nonmissing finite categorical observations.')
 states<-sort(unique(x),method='radix');k<-length(states);guane_musse_names(k)
 if(length(text)!=1||is.na(text))stop('Invalid MuSSE state table.')
 tab<-data.frame(State=states,Sampling=rep(1,k),RootWeight=rep(1/k,k))
 if(nzchar(trimws(text))){
  tab<-tryCatch(utils::read.csv(text=text,colClasses='character',check.names=FALSE,stringsAsFactors=FALSE,na.strings=NULL),error=function(e)stop('Invalid MuSSE state table.'))
  if(!identical(names(tab),c('State','Sampling','RootWeight'))||nrow(tab)!=k||anyNA(tab$State)||anyDuplicated(tab$State)||!setequal(tab$State,states))stop('The MuSSE state table must list each observed state exactly once.')
  for(n in c('Sampling','RootWeight'))tab[[n]]<-suppressWarnings(as.numeric(tab[[n]]))
 }
 if(any(!is.finite(tab$Sampling))||any(tab$Sampling<=0|tab$Sampling>1))stop('MuSSE sampling fractions must be greater than zero and at most one.')
 if(any(!is.finite(tab$RootWeight))||any(tab$RootWeight<0)||abs(sum(tab$RootWeight)-1)>1e-8)stop('Root probabilities must be nonnegative and sum to one.')
 tab
}
guane_musse_data <- function(tree,traits,taxon,trait,state_text='') {
 guane_ltt(tree)
 if(!ape::is.binary(tree)||length(tree$tip.label)<4||inherits(tree,'clade.tree'))stop('MuSSE requires a resolved binary tree with at least four tips.')
 if(length(taxon)!=1||!taxon%in%names(traits)||identical(taxon,trait))stop('Select separate taxon and discrete-trait columns.')
 table<-guane_musse_state_table(traits,trait,state_text);ids<-as.character(traits[[taxon]])
 if(anyNA(ids)||anyDuplicated(ids)||any(!nzchar(trimws(ids)))||!setequal(ids,tree$tip.label))stop('Match tree and trait taxa explicitly in Data before MuSSE.')
 states<-setNames(match(as.character(traits[[trait]][match(tree$tip.label,ids)]),table$State),tree$tip.label);k<-nrow(table)
 attr(tree,'order')<-NULL;tree<-ape::reorder.phylo(tree,'cladewise');tree$root.edge<-NULL
 list(tree=tree,states=states,k=k,mapping=data.frame(Code=seq_len(k),table,Count=as.integer(table(factor(states,levels=seq_len(k))))))
}
guane_musse_parameters <- function(tree,k,text='') {
 n<-guane_musse_names(k);age<-max(ape::branching.times(tree));base<-(length(tree$tip.label)-2)/sum(tree$edge.length)
 d<-data.frame(Parameter=n,Group=n,Fixed=NA_real_,Start=c(rep(base,k),rep(base/2,k),rep(base/5/(k-1),k*(k-1))),Lower=0,Upper=100/age)
 guane_sse_parameters(d,n,text,age,'MuSSE')
}
guane_musse_constraint <- function(table,model,k) {
 d<-table;n<-guane_musse_names(k)
 if(!identical(as.character(d$Parameter),n)||!model%in%guane_musse_models())stop('Select supported MuSSE models.')
 if(model!='Custom'){
  d$Group<-d$Parameter;d$Fixed<-NA_real_
  if(model%in%c('Equal speciation','Trait-independent diversification','Equal diversification and transitions'))d$Group[seq_len(k)]<-'lambda1'
  if(model%in%c('Equal extinction','Trait-independent diversification','Equal diversification and transitions'))d$Group[k+seq_len(k)]<-'mu1'
  if(model%in%c('Equal transitions','Equal diversification and transitions'))d$Group[seq.int(2*k+1,nrow(d))]<-'q12'
  if(model=='Symmetric transitions')for(i in seq_len(k))for(j in seq_len(k))if(i!=j)d$Group[d$Parameter==paste0('q',i,j)]<-paste0('q',min(i,j),max(i,j))
  if(model=='No extinction'){i<-k+seq_len(k);d$Fixed[i]<-0;if(any(d$Lower[i]>0))stop('No extinction requires lower bounds of zero for mu.')}
 }
 guane_sse_constraint_groups(d,'MuSSE')
}
guane_musse_likelihood <- function(prepared,survival,root,backend,tolerance,eps) {
 if(length(root)!=1||!root%in%c('OBS','FLAT','GIVEN'))stop('MuSSE supports observed, equal or given root weights; equilibrium roots are unavailable.')
 lik<-diversitree::make.musse(prepared$tree,prepared$states,k=prepared$k,sampling.f=prepared$mapping$Sampling,strict=TRUE,control=list(backend=backend,tol=tolerance,eps=eps))
 if(!identical(diversitree::argnames(lik),guane_musse_names(prepared$k)))stop('MuSSE backend parameter order is incompatible.')
 root_id<-switch(root,OBS=diversitree::ROOT.OBS,FLAT=diversitree::ROOT.FLAT,GIVEN=diversitree::ROOT.GIVEN)
 function(pars)lik(pars,condition.surv=survival,root=root_id,root.p=if(root=='GIVEN')prepared$mapping$RootWeight else NULL)
}
guane_musse_fit <- function(tree,traits,taxon,trait,models=c('Equal transitions','Equal diversification and transitions'),state_text='',parameter_text='',survival=TRUE,root='OBS',optimizer='nlminb',starts=3,maxit=500,backend=guane_sse_backend(),tolerance=1e-8,eps=0,slices=TRUE,verify=TRUE) {
 original<-tree;d<-guane_musse_data(tree,traits,taxon,trait,state_text);age<-max(ape::branching.times(d$tree));k<-d$k
 scalar<-function(x)is.numeric(x)&&length(x)==1&&is.finite(x)
 if(!length(models)||anyNA(models)||anyDuplicated(models)||any(!models%in%guane_musse_models()))stop('Select supported MuSSE models.')
 if(!all(vapply(list(survival,slices),function(x)is.logical(x)&&length(x)==1&&!is.na(x),logical(1))))stop('Invalid MuSSE likelihood settings.')
 if(length(optimizer)!=1||!optimizer%in%c('nlminb','L-BFGS-B')||!scalar(starts)||starts<1||starts>8||starts!=floor(starts)||!scalar(maxit)||maxit<10||maxit>5000||maxit!=floor(maxit))stop('Invalid MuSSE optimizer settings.')
 if(length(backend)!=1||!backend%in%c('deSolve','gslode')||!scalar(tolerance)||tolerance<1e-12||tolerance>1e-4||!scalar(eps)||eps<0||eps>1e-3)stop('Invalid MuSSE integration settings.')
 tab<-guane_musse_parameters(d$tree,k,parameter_text);constraints<-setNames(lapply(models,function(m)guane_musse_constraint(tab,m,k)),models)
 lik<-guane_musse_likelihood(d,survival,root,backend,tolerance,eps);precise<-guane_musse_likelihood(d,survival,root,backend,max(1e-13,tolerance/10),eps)
 warnings<-c('MuSSE support is exploratory: unmodeled rate heterogeneity can mimic trait dependence. Multistate hidden-state null models are not implemented; the hidden-state card supports binary traits only.','Rates condition on one tree, observed states, sampling fractions and root treatment. Optional profile intervals require verified fits; calibrated likelihood-ratio tests are not provided.')
 if(nrow(traits)<100||min(d$mapping$Count)<10)warnings<-c(warnings,'Few taxa or imbalanced states can give weakly identified rates. This is a screening warning, not a sufficiency threshold.')
 if(any(vapply(constraints,function(x)length(x$free)>=length(d$states),logical(1))))warnings<-c(warnings,'A candidate has at least as many free rates as observed tips. Interpretability is severely limited.')
 if(!is.null(original$root.edge)&&original$root.edge>0)warnings<-c(warnings,'Supplied stem excluded; this analysis uses a crown-tree likelihood.')
 fitted<-guane_sse_optimize(models,constraints,lik,precise,age,optimizer,starts,maxit,slices,warnings,'MuSSE',verify)
 c(list(tree=d$tree,states=d$states,mapping=d$mapping,k=k,trait=trait),fitted,list(version=as.character(utils::packageVersion('diversitree')),inputs=list(tree=original,traits=traits,taxon=taxon,trait=trait,models=models,state_text=state_text,parameter_text=parameter_text,survival=survival,root=root,optimizer=optimizer,starts=starts,maxit=maxit,backend=backend,tolerance=tolerance,eps=eps,slices=slices,verify=verify)))
}

guane_musse_settings <- function(type='rates',model='Equal transitions',parameter='lambda1',palette='Guane',labels=TRUE,label_size=.7,width=10,height=7,lang='en') {
 # The card shares the validated display contract, not the binary state renderer.
 tryCatch(guane_bisse_settings(type,model,parameter,palette,labels,label_size,width,height,lang),error=function(e)stop(sub('BiSSE','MuSSE',conditionMessage(e),fixed=TRUE)))
}
guane_musse_plot <- function(result,settings=guane_musse_settings()) {
 if(identical(settings$type,'verification'))return(guane_sse_verification_plot(result,settings))
 s<-do.call(guane_musse_settings,settings);k<-result$k;txt<-function(x)guane_text(x,s$lang)
 # These three diagnostic views do not depend on state count or binary coding.
 if(s$type%in%c('comparison','starts','slice','profile'))return(tryCatch(guane_bisse_plot(result,s),error=function(e)stop(sub('BiSSE','MuSSE',conditionMessage(e),fixed=TRUE))))
 cols<-switch(s$palette,Grayscale=grDevices::gray.colors(k,start=.15,end=.85),Legacy=grDevices::colorRampPalette(c('#02b2ce','#ffd004','#e52920'))(k),grDevices::hcl.colors(k,'Dark 3'))
 state_labels<-vapply(paste0(result$mapping$Code,': ',result$mapping$State),function(x)paste(strwrap(x,width=32),collapse='\n'),character(1))
 old<-graphics::par(no.readonly=TRUE);on.exit({graphics::layout(1);graphics::par(old)});graphics::layout(matrix(1:2,1),widths=c(4,1.5));graphics::par(mar=c(5,5,3,1))
 if(s$type=='tree'){
  # Separate legend panel avoids hiding branches when many state labels are long.
  graphics::par(mar=c(5,1,3,0));ape::plot.phylo(result$tree,show.tip.label=s$labels,underscore=TRUE,label.offset=max(ape::branching.times(result$tree))*.02,cex=s$label_size,no.margin=FALSE,main=paste('MuSSE:',result$trait))
  ape::tiplabels(pch=21,bg=cols[result$states[result$tree$tip.label]],cex=.8)
  graphics::mtext(txt('Observed tip states; no ancestral reconstruction'),side=1,line=3,cex=.7)
 } else {
  f<-result$fits[[s$model]];if(!isTRUE(f$valid))stop('No valid MuSSE fit. Inspect diagnostics.')
  if(s$type=='rates'){
   z<-cbind(lambda=f$par[paste0('lambda',seq_len(k))],mu=f$par[paste0('mu',seq_len(k))]);graphics::barplot(z,beside=TRUE,col=cols,ylim=c(0,max(z,1e-8)*1.5),names.arg=colnames(z),ylab=txt('Rate per branch-length unit'),main=txt(s$model))
   graphics::mtext(txt('Rate point estimates; profile intervals are shown separately.'),side=1,line=3,cex=.7)
  } else if(s$type=='transitions'){
   Q<-matrix(NA_real_,k,k)
   for(i in seq_len(k))for(j in seq_len(k))if(i!=j)Q[i,j]<-f$par[paste0('q',i,j)]
   ramp<-if(s$palette=='Grayscale')grDevices::gray.colors(100,start=.95,end=.2) else grDevices::colorRampPalette(c('#f5f5f5','#26734f'))(100)
   graphics::par(mar=c(6,5,3,1));graphics::plot(c(.5,k+.5),c(.5,k+.5),type='n',axes=FALSE,xlab=txt('Destination state code'),ylab=txt('Source state code'),main=txt('MuSSE transition rates'))
   for(i in seq_len(k))for(j in seq_len(k)){
    val<-Q[i,j];shade<-if(is.na(val))'#eeeeee' else ramp[1+floor(99*val/max(Q,1e-12,na.rm=TRUE))]
    graphics::rect(j-.5,k-i+.5,j+.5,k-i+1.5,col=shade,border='white')
    graphics::text(j,k-i+1,if(is.na(val))'-' else format(signif(val,3),trim=TRUE),cex=s$label_size,col=if(!is.na(val)&&val>max(Q,1e-12,na.rm=TRUE)*.6)'white' else 'black')
   }
   graphics::axis(1,seq_len(k),seq_len(k));graphics::axis(2,seq_len(k),rev(seq_len(k)),las=1)
   graphics::mtext(txt('Rate per branch-length unit'),side=1,line=4.5)
  }
 }
  graphics::par(mar=c(1,0,3,1));graphics::plot.new();graphics::legend('topleft',legend=state_labels,pch=21,pt.bg=cols,bty='n',cex=min(.8,s$label_size),y.intersp=max(lengths(strsplit(state_labels,'\n')))*1.2)
 invisible(result)
}
guane_musse_script <- function(result,settings=guane_musse_settings()) {
 functions<-c('guane_sse_verification_plot','guane_sse_profile','guane_sse_profile_plot','guane_musse_profile','guane_ltt','guane_sse_backend','guane_sse_expand','guane_bisse_settings','guane_bisse_plot','guane_sse_parameters','guane_sse_constraint_groups','guane_sse_optimize','guane_musse_names','guane_musse_models','guane_musse_state_table','guane_musse_data','guane_musse_parameters','guane_musse_constraint','guane_musse_likelihood','guane_musse_fit','guane_musse_settings','guane_musse_plot','guane_text')
 c('# GUane MuSSE: saved results, original data, state coding and editable plotting settings.',
 '# Required packages: ape and diversitree. No GUane installation required.',paste('# Original diversitree version:',result$version),
 vapply(functions,function(n)paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),
 guane_r_assignment('result',result),guane_r_assignment('settings',settings),
 '# Optional refit: result <- do.call(guane_musse_fit, result$inputs)',
 '# Optional profile replay: result$profile <- do.call(guane_musse_profile,c(list(result=result,model=result$profile$model),result$profile$settings))','opened <- grDevices::dev.cur() == 1L','if(opened) grDevices::pdf("guane-musse.pdf", width=settings$width, height=settings$height)',
 'guane_musse_plot(result,settings)','if(opened) grDevices::dev.off()','print(result$mapping)','print(result$comparison)','print(result$warnings)','sessionInfo()')
}

guane_musse_profile <- function(result,model,parameter,lower,upper,points=15,level=.95,maxit=500) {
 o<-result$inputs;d<-list(tree=result$tree,states=result$states,k=result$k,mapping=result$mapping)
 lik<-guane_musse_likelihood(d,o$survival,o$root,o$backend,o$tolerance,o$eps)
 fine<-guane_musse_likelihood(d,o$survival,o$root,o$backend,max(1e-13,o$tolerance/10),o$eps)
 p<-guane_sse_profile(result$fits[[model]],lik,fine,parameter,lower,upper,points,level,maxit,max(ape::branching.times(result$tree)));p$model<-model;p
}
