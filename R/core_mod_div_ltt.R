# Pure LTT functions. ape coordinates preserve simultaneous branching events.
guane_ltt <- function(tree, include_stem=FALSE, tol=1e-6) {
 if(!inherits(tree,'phylo'))stop('Load a phylogenetic tree.')
 n<-length(tree$tip.label);m<-tree$Nnode;e<-tree$edge
 if(n<2 || anyNA(tree$tip.label) || any(!nzchar(trimws(tree$tip.label))) || anyDuplicated(tree$tip.label))stop('LTT requires at least two uniquely named tips.')
 if(length(m)!=1 || !is.finite(m) || m<1 || m!=floor(m) || !is.matrix(e) || ncol(e)!=2 || anyNA(e) || any(e!=floor(e)) || any(e<1) || any(e>n+m) || nrow(e)!=n+m-1 || any(e[,1]<=n) || anyDuplicated(e[,2]) || !setequal(e[,2],setdiff(seq_len(n+m),n+1)))stop('Invalid tree structure for LTT.')
 # Check reachability before calling routines that assume an acyclic phylo.
 reached<-n+1L
 for(i in seq_len(m)){next_nodes<-unique(c(reached,e[e[,1]%in%reached,2]));if(identical(next_nodes,reached))break;reached<-next_nodes}
 if(length(reached)!=n+m || any(tabulate(e[,1],nbins=n+m)[(n+1):(n+m)]<2))stop('Invalid tree structure for LTT.')
 attr(tree,'order')<-NULL;tree<-ape::reorder.phylo(tree,'cladewise')
 if(!ape::is.rooted(tree))stop('LTT requires an explicitly rooted tree.')
 if(is.null(tree$edge.length) || length(tree$edge.length)!=nrow(e) || any(!is.finite(tree$edge.length)) || any(tree$edge.length<=0))stop('LTT requires finite, positive branch lengths.')
 if(length(tol)!=1 || !is.finite(tol) || tol<=0 || tol>1e-3)stop('LTT tolerance must be positive and at most 0.001.')
 if(!ape::is.ultrametric(tree,tol=tol))stop('LTT requires an ultrametric tree; calibrate it before analysis.')
 if(!is.logical(include_stem)||length(include_stem)!=1||is.na(include_stem))stop('Invalid stem setting.')
 if(!is.null(tree$root.edge) && (length(tree$root.edge)!=1 || !is.finite(tree$root.edge) || tree$root.edge<0))stop('Stem length must be finite and nonnegative.')
 used<-tree;if(!include_stem || identical(as.numeric(used$root.edge),0))used$root.edge<-NULL
 z<-ape::ltt.plot.coords(used,backward=FALSE,tol=tol,type='s')
 data.frame(Time=unname(z[,1]),Lineages=unname(z[,2]))
}

guane_ltt_run <- function(trees,include_stem=FALSE,tol=1e-6) {
 if(inherits(trees,'phylo'))trees<-list(Data=trees)
 if(!is.list(trees)||!length(trees)||length(trees)>25)stop('Choose one to 25 trees for LTT.')
 if(is.null(names(trees)))names(trees)<-paste('Tree',seq_along(trees))
 names(trees)[is.na(names(trees))|!nzchar(names(trees))]<-paste('Tree',which(is.na(names(trees))|!nzchar(names(trees))))
 names(trees)<-make.unique(names(trees))
 curves<-lapply(seq_along(trees),function(i){z<-tryCatch(guane_ltt(trees[[i]],include_stem,tol),error=function(e)stop(paste(names(trees)[i],conditionMessage(e),sep=': '),call.=FALSE));data.frame(Tree=names(trees)[i],z,Time_before_present=max(z$Time)-z$Time)})
 result<-do.call(rbind,curves);rownames(result)<-NULL
 attr(result,'inputs')<-list(trees=trees,include_stem=include_stem,tol=tol)
 attr(result,'summary')<-do.call(rbind,lapply(seq_along(trees),function(i){t<-trees[[i]];attr(t,'order')<-NULL;t<-ape::reorder.phylo(t,'cladewise');depth<-ape::node.depth.edgelength(t)[seq_along(t$tip.label)];data.frame(Tree=names(trees)[i],Tips=length(t$tip.label),Crown_age=max(depth),Stem=if(is.null(t$root.edge))0 else t$root.edge,Tip_depth_range=diff(range(depth)),Events=t$Nnode)}))
 result
}

guane_ltt_read <- function(paths,names) {
 names<-make.unique(names)
 trees<-list()
 for(i in seq_along(paths)) {
  x<-ape::read.tree(paths[i]);if(inherits(x,'phylo'))x<-list(x)
  for(t in x)guane_check_tree_size(t)
  if(!is.list(x)||!length(x))stop('No trees found in the uploaded Newick file.')
  for(j in seq_along(x))trees[[paste0(names[i],' [',j,']')]]<-x[[j]]
  if(length(trees)>25)stop('Choose one to 25 trees for LTT.')
 }
 if(length(trees)>25)stop('Choose one to 25 trees for LTT.')
 trees
}

guane_ltt_settings <- function(logarithmic=FALSE,backward=FALSE,palette='Guane',width=10,height=7,dpi=150,line_width=2,line_type=1,legend=TRUE,lang='en') {
 vals<-c(width,height,dpi,line_width,line_type)
 if(length(vals)!=5||any(!is.finite(vals))||width<4||width>30||height<3||height>30||dpi<72||dpi>600||line_width<.5||line_width>6||!line_type%in%1:6||!palette%in%c('Guane','Legacy','Grayscale'))stop('Invalid LTT graph settings.')
 if(!all(vapply(list(logarithmic,backward,legend),function(x)is.logical(x)&&length(x)==1&&!is.na(x),logical(1))))stop('Invalid LTT graph settings.')
 list(logarithmic=logarithmic,backward=backward,palette=palette,width=width,height=height,dpi=dpi,line_width=line_width,line_type=line_type,legend=legend,lang=lang)
}

guane_ltt_plot <- function(result,settings=guane_ltt_settings()) {
 s<-do.call(guane_ltt_settings,settings);ids<-unique(result$Tree);k<-length(ids)
 colors<-if(s$palette=='Grayscale')grDevices::gray.colors(k,start=.15,end=.65) else if(s$palette=='Legacy')rep(c('#02b2ce','#ffd004','#e52920'),length.out=k) else if(k==1)'#2f7d4f' else grDevices::hcl.colors(k,'Dark 3')
 age<-max(result$Time);xr<-if(s$backward)c(age,0) else c(0,age)
 padding<-if(s$legend)1.25+min(k,10)*.03 else 1.04
 yr<-c(1,if(s$logarithmic)max(result$Lineages)^padding else max(result$Lineages)*padding)
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old));graphics::par(mar=c(5,5,3,2))
 graphics::plot(xr,yr,xlim=xr,ylim=yr,type='n',log=if(s$logarithmic)'y' else '',xlab=guane_text(if(s$backward)'Time before present (branch-length units)' else if(isTRUE(attr(result,'inputs')$include_stem))'Time since origin (branch-length units)' else 'Time since root (branch-length units)',s$lang),ylab=guane_text('Lineages',s$lang),main=guane_text('Lineage through time',s$lang))
 for(i in seq_along(ids)){z<-result[result$Tree==ids[i],];x<-if(s$backward)max(z$Time)-z$Time else z$Time;graphics::lines(x,z$Lineages,type='s',col=colors[i],lwd=s$line_width,lty=if(k==1)s$line_type else (i+s$line_type-2)%%6+1)}
 if(s$legend)graphics::legend('topleft',legend=ids,col=colors,lwd=s$line_width,lty=if(k==1)s$line_type else (seq_len(k)+s$line_type-2)%%6+1,bty='n',cex=max(.35,min(.85,12/k,.85*graphics::par('pin')[1]*.9/max(graphics::strwidth(ids,units='inches',cex=.85)))))
 invisible(result)
}

guane_ltt_script <- function(tree,logarithmic=FALSE,lang='en',settings=NULL) {
 result<-if(is.data.frame(tree))tree else guane_ltt_run(tree)
 if(is.null(settings))settings<-guane_ltt_settings(logarithmic=logarithmic,lang=lang)
 c('# Guane LTT: saved curves and editable settings; no calibration or rate inference.',
 '# install.packages("ape")',paste0('# ape ',utils::packageVersion('ape')),
 vapply(c('guane_ltt','guane_ltt_run','guane_ltt_settings','guane_ltt_plot','guane_text'),function(n)paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),
 guane_r_assignment('result',result),guane_r_assignment('inputs',attr(result,'inputs')),guane_r_assignment('settings',settings),
 '# Optional recalculation: result <- do.call(guane_ltt_run,inputs)',
 'opened <- grDevices::dev.cur() == 1L','if(opened) grDevices::pdf("guane-ltt.pdf",width=settings$width,height=settings$height)',
 'guane_ltt_plot(result,settings)','if(opened) grDevices::dev.off()','sessionInfo()')
}
