# BiSSE adapter to diversitree; no backend likelihood code is copied.
guane_bisse_backend <- function() guane_sse_backend()
guane_bisse_names <- function() c('lambda0','lambda1','mu0','mu1','q01','q10')
guane_bisse_models <- function() c('Full','Equal speciation','Equal extinction','Equal transitions','Trait-independent diversification','No extinction','Custom')

guane_bisse_data <- function(tree,traits,taxon,trait,state0) {
 # Reuse the platform's structural/branch checks, without modifying the input.
 guane_ltt(tree)
 if(!ape::is.binary(tree)||length(tree$tip.label)<4||inherits(tree,'clade.tree'))stop('BiSSE requires a resolved binary tree with at least four tips.')
 if(!is.data.frame(traits)||anyDuplicated(names(traits))||length(taxon)!=1||length(trait)!=1||!all(c(taxon,trait)%in%names(traits))||taxon==trait)stop('Select a taxon column and a binary trait.')
 ids<-as.character(traits[[taxon]])
 if(anyNA(ids)||anyDuplicated(ids)||any(!nzchar(trimws(ids)))||!setequal(ids,tree$tip.label))stop('Match tree and trait taxa explicitly in Data before BiSSE.')
 raw<-traits[[trait]][match(tree$tip.label,ids)]
 if(is.numeric(raw)&&any(!is.finite(raw)))stop('BiSSE requires two observed states, no missing values and an explicit state 0.')
 x<-as.character(raw)
 if(anyNA(x)||any(!nzchar(trimws(x)))||length(unique(x))!=2||length(state0)!=1||!state0%in%x)stop('BiSSE requires two observed states, no missing values and an explicit state 0.')
 labels<-c(state0,setdiff(unique(x),state0));states<-setNames(as.integer(x!=state0),tree$tip.label)
 attr(tree,'order')<-NULL;tree<-ape::reorder.phylo(tree,'cladewise');tree$root.edge<-NULL
 list(tree=tree,states=states,mapping=data.frame(Code=0:1,State=labels,Count=as.integer(table(factor(states,levels=0:1)))))
}

guane_bisse_parameters <- function(tree,text='') {
 age<-max(ape::branching.times(tree));base<-(length(tree$tip.label)-2)/sum(tree$edge.length)
 n<-guane_bisse_names()
 d<-data.frame(Parameter=n,Group=n,Fixed=NA_real_,Start=c(base,base,base/2,base/2,base/5,base/5),Lower=0,Upper=100/age)
 guane_sse_parameters(d,n,text,age,'BiSSE')
}

guane_bisse_constraint <- function(table,model) {
 d<-table
 if(!model%in%guane_bisse_models())stop('Select supported BiSSE models.')
 if(model!='Custom') {
  d$Group<-d$Parameter;d$Fixed<-NA_real_
  if(model%in%c('Equal speciation','Trait-independent diversification'))d$Group[2]<-d$Group[1]
  if(model%in%c('Equal extinction','Trait-independent diversification'))d$Group[4]<-d$Group[3]
  if(model=='Equal transitions')d$Group[6]<-d$Group[5]
  if(model=='No extinction'){d$Fixed[3:4]<-0;if(any(d$Lower[3:4]>0))stop('No extinction requires lower bounds of zero for mu.')}
 }
 guane_sse_constraint_groups(d,'BiSSE')
}
guane_bisse_expand <- function(pars,constraint) guane_sse_expand(pars,constraint)

guane_bisse_likelihood <- function(prepared,sampling,survival,root,root_p,backend,tolerance,eps) {
 lik<-diversitree::make.bisse(prepared$tree,prepared$states,sampling.f=sampling,strict=TRUE,control=list(backend=backend,tol=tolerance,eps=eps))
 root_id<-switch(root,OBS=diversitree::ROOT.OBS,FLAT=diversitree::ROOT.FLAT,EQUI=diversitree::ROOT.EQUI,GIVEN=diversitree::ROOT.GIVEN)
 function(pars)lik(pars,condition.surv=survival,root=root_id,root.p=if(root=='GIVEN')root_p else NULL)
}

guane_bisse_fit <- function(tree,traits,taxon,trait,state0,models=c('Full','Trait-independent diversification'),sampling=c(1,1),survival=TRUE,root='OBS',root_p=c(.5,.5),parameter_text='',optimizer='nlminb',starts=3,maxit=500,backend=guane_bisse_backend(),tolerance=1e-8,eps=0,slices=TRUE,verify=TRUE) {
 original<-tree;d<-guane_bisse_data(tree,traits,taxon,trait,state0);age<-max(ape::branching.times(d$tree))
 scalar<-function(x) is.numeric(x)&&length(x)==1&&is.finite(x)
 if(!length(models)||anyNA(models)||anyDuplicated(models)||any(!models%in%guane_bisse_models()))stop('Select supported BiSSE models.')
 if(!is.numeric(sampling)||length(sampling)!=2||any(!is.finite(sampling))||any(sampling<=0|sampling>1))stop('Both state sampling fractions must be greater than zero and at most one.')
 if(!is.numeric(root_p)||length(root_p)!=2||any(!is.finite(root_p))||any(root_p<0)||abs(sum(root_p)-1)>1e-8)stop('Root probabilities must be nonnegative and sum to one.')
 if(length(root)!=1||!root%in%c('OBS','FLAT','EQUI','GIVEN')||!all(vapply(list(survival,slices),function(x)is.logical(x)&&length(x)==1&&!is.na(x),logical(1))))stop('Invalid BiSSE likelihood settings.')
 if(length(optimizer)!=1||!optimizer%in%c('nlminb','L-BFGS-B')||!scalar(starts)||starts<1||starts>8||starts!=floor(starts)||!scalar(maxit)||maxit<10||maxit>5000||maxit!=floor(maxit))stop('Invalid BiSSE optimizer settings.')
 if(length(backend)!=1||!backend%in%c('deSolve','gslode')||!scalar(tolerance)||tolerance<1e-12||tolerance>1e-4||!scalar(eps)||eps<0||eps>1e-3)stop('Invalid BiSSE integration settings.')
 tab<-guane_bisse_parameters(d$tree,parameter_text)
 constraints<-setNames(lapply(models,function(m)guane_bisse_constraint(tab,m)),models)
 # Canonicalize ignored settings in the saved effective call.
 if(root!='GIVEN')root_p<-c(.5,.5)
 lik<-guane_bisse_likelihood(d,sampling,survival,root,root_p,backend,tolerance,eps)
 precise<-guane_bisse_likelihood(d,sampling,survival,root,root_p,backend,max(1e-13,tolerance/10),eps)
 warnings<-c('BiSSE support is exploratory. Use the Hidden-state and null models card to refit compatible binary candidates.','Rates condition on one tree, observed states, sampling fractions and root treatment. Optional profile intervals require verified fits; calibrated likelihood-ratio tests are not provided.')
 if(nrow(traits)<100||min(d$mapping$Count)<10)warnings<-c(warnings,'Few taxa or an imbalanced binary trait can give weakly identified rates. This is a screening warning, not a sufficiency threshold.')
 if(!is.null(original$root.edge)&&original$root.edge>0)warnings<-c(warnings,'Supplied stem excluded; this analysis uses a crown-tree likelihood.')
 fitted<-guane_sse_optimize(models,constraints,lik,precise,age,optimizer,starts,maxit,slices,warnings,'BiSSE',verify)
 c(list(tree=d$tree,states=d$states,mapping=d$mapping,trait=trait),fitted,list(version=as.character(utils::packageVersion('diversitree')),inputs=list(tree=original,traits=traits,taxon=taxon,trait=trait,state0=state0,models=models,sampling=sampling,survival=survival,root=root,root_p=root_p,parameter_text=parameter_text,optimizer=optimizer,starts=starts,maxit=maxit,backend=backend,tolerance=tolerance,eps=eps,slices=slices,verify=verify)))
}

guane_bisse_settings <- function(type='rates',model='Full',parameter='lambda0',palette='Guane',labels=TRUE,label_size=.7,width=10,height=7,lang='en') {
 if(!type%in%c('rates','tree','transitions','comparison','starts','slice','profile','verification')||!palette%in%c('Guane','Legacy','Grayscale')||!is.logical(labels)||length(labels)!=1||is.na(labels)||length(c(label_size,width,height))!=3||any(!is.finite(c(label_size,width,height)))||label_size<.2||label_size>2||width<5||width>24||height<4||height>24)stop('Invalid BiSSE graph settings.')
 list(type=type,model=model,parameter=parameter,palette=palette,labels=labels,label_size=label_size,width=width,height=height,lang=lang)
}
guane_bisse_plot <- function(result,settings=guane_bisse_settings()) {
 if(identical(settings$type,'verification'))return(guane_sse_verification_plot(result,settings))
 if(identical(settings$type,'profile'))return(guane_sse_profile_plot(result,settings))
 s<-do.call(guane_bisse_settings,settings);txt<-function(x)guane_text(x,s$lang)
 cols<-switch(s$palette,Grayscale=c('#333333','#999999'),Legacy=c('#02b2ce','#e52920'),c('#28734f','#d99628'))
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old));graphics::par(mar=c(5,5,3,2))
 state_labels<-vapply(paste0(result$mapping$Code,': ',result$mapping$State),function(x)paste(strwrap(x,width=35),collapse='\n'),character(1))
 if(s$type=='tree') {
  ape::plot.phylo(result$tree,show.tip.label=s$labels,underscore=TRUE,label.offset=max(ape::branching.times(result$tree))*.02,cex=s$label_size,no.margin=FALSE,main=paste('BiSSE:',result$trait))
  ape::tiplabels(pch=21,bg=cols[result$states[result$tree$tip.label]+1L],cex=.8)
  graphics::legend('topleft',legend=state_labels,pch=21,pt.bg=cols,bty='n',y.intersp=max(lengths(strsplit(state_labels,'\n')))*1.2,cex=min(.85,s$label_size));graphics::mtext(txt('Observed tip states; no ancestral reconstruction'),side=1,line=3)
 } else if(s$type=='comparison') {
  z<-result$comparison;ok<-is.finite(z$AIC);if(!any(ok))stop('No valid BiSSE fit. Inspect diagnostics.')
  graphics::par(mar=c(5,14,3,2));graphics::barplot(z$AIC[ok]-min(z$AIC[ok]),names.arg=vapply(z$Model[ok],txt,character(1)),horiz=TRUE,las=1,col=cols[1],xlab='Delta AIC',main=txt('Model comparison'),cex.names=.8)
 } else if(s$type=='starts') {
  z<-result$attempts[result$attempts$Model==s$model,];if(!nrow(z)||!any(is.finite(z$LogLik)))stop('No valid BiSSE fit. Inspect diagnostics.')
  graphics::plot(z$Start,z$LogLik,pch=ifelse(z$Convergence==0,19,4),col=ifelse(z$Convergence==0,cols[1],cols[2]),xlab=txt('Optimizer start'),ylab='logLik',main=txt(s$model))
  graphics::legend('bottomright',c(txt('Converged'),txt('Failed convergence')),pch=c(19,4),col=cols,bty='n')
 } else {
  f<-result$fits[[s$model]];if(!isTRUE(f$valid))stop('No valid BiSSE fit. Inspect diagnostics.')
  if(s$type=='rates') {
   z<-rbind(f$par[c('lambda0','mu0','q01')],f$par[c('lambda1','mu1','q10')]);colnames(z)<-c('lambda','mu','q (0->1 / 1->0)')
   graphics::barplot(z,beside=TRUE,col=cols,names.arg=colnames(z),ylab=txt('Rate per branch-length unit'),main=txt(s$model),ylim=c(0,max(z,1e-8)*1.3),legend.text=state_labels,args.legend=list(bty='n',cex=.8,y.intersp=max(lengths(strsplit(state_labels,'\n')))*1.2))
   graphics::mtext(txt('Rate point estimates; profile intervals are shown separately.'),side=1,line=3,cex=.8)
  } else if(s$type=='transitions') {
   graphics::par(mar=c(2,2,3,2));graphics::plot(c(-1,1),c(-1,1),type='n',axes=FALSE,xlab='',ylab='',main=txt('BiSSE transition rates'))
   graphics::points(c(-.65,.65),c(0,0),pch=21,bg=cols,cex=6);graphics::text(c(-.65,.65),c(0,0),labels=0:1,col=c('white','black'))
   graphics::arrows(-.4,.18,.4,.18,length=.12,lwd=2);graphics::arrows(.4,-.18,-.4,-.18,length=.12,lwd=2)
   graphics::text(0,.32,paste('q01 =',signif(f$par['q01'],4)));graphics::text(0,-.32,paste('q10 =',signif(f$par['q10'],4)))
   graphics::text(c(-.6,.6),c(-.65,-.65),vapply(state_labels,function(x)paste(strwrap(x,width=25),collapse='\n'),character(1)),cex=s$label_size)
   graphics::mtext(txt('Rate per branch-length unit'),side=1)
  } else if(s$type=='slice') {
   z<-result$slices;z<-z[z$Model==s$model&z$Parameter==s$parameter,,drop=FALSE]
   if(is.null(z)||!nrow(z)||!any(is.finite(z$DeltaLogLik)))stop('No likelihood slice for this parameter.')
   graphics::plot(z$Rate,z$DeltaLogLik,type='l',lwd=2,col=cols[1],xlab=s$parameter,ylab='Delta logLik',main=txt('Likelihood slice: other free rates fixed'));graphics::abline(v=f$free[match(s$parameter,f$constraint$free)],lty=2)
  }
 }
 invisible(result)
}
guane_bisse_script <- function(result,settings=guane_bisse_settings()) {
 functions<-c('guane_sse_verification_plot','guane_sse_profile','guane_sse_profile_plot','guane_bisse_profile','guane_sse_backend','guane_sse_expand','guane_sse_parameters','guane_sse_constraint_groups','guane_sse_optimize','guane_ltt','guane_bisse_backend','guane_bisse_names','guane_bisse_models','guane_bisse_data','guane_bisse_parameters','guane_bisse_constraint','guane_bisse_expand','guane_bisse_likelihood','guane_bisse_fit','guane_bisse_settings','guane_bisse_plot','guane_text')
 c('# GUane BiSSE: saved results and editable plotting settings. Research data are embedded.',
 '# Required packages: ape and diversitree. No GUane installation required.',paste('# Original diversitree version:',result$version),
 vapply(functions,function(n)paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),
 guane_r_assignment('result',result),guane_r_assignment('settings',settings),
 '# Optional refit using the complete original settings:', '# result <- do.call(guane_bisse_fit, result$inputs)',
 '# Optional profile replay: result$profile <- do.call(guane_bisse_profile,c(list(result=result,model=result$profile$model),result$profile$settings))','opened <- grDevices::dev.cur() == 1L','if(opened) grDevices::pdf("guane-bisse.pdf", width=settings$width, height=settings$height)',
 'guane_bisse_plot(result, settings)','if(opened) grDevices::dev.off()','print(result$comparison)','print(result$warnings)','sessionInfo()')
}

guane_bisse_profile <- function(result,model,parameter,lower,upper,points=15,level=.95,maxit=500) {
 o<-result$inputs;d<-list(tree=result$tree,states=result$states)
 lik<-guane_bisse_likelihood(d,o$sampling,o$survival,o$root,o$root_p,o$backend,o$tolerance,o$eps)
 fine<-guane_bisse_likelihood(d,o$sampling,o$survival,o$root,o$root_p,o$backend,max(1e-13,o$tolerance/10),o$eps)
 p<-guane_sse_profile(result$fits[[model]],lik,fine,parameter,lower,upper,points,level,maxit,max(ape::branching.times(result$tree)));p$model<-model;p
}
