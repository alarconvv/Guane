guane_rates_clade_select <- function(tree,nodes,sampling=NULL) {
 catalog<-guane_rates_clade_catalog(tree)
 if(!is.numeric(nodes)||!length(nodes)||length(nodes)>10||anyNA(nodes)||any(!is.finite(nodes))||any(nodes!=floor(nodes))||anyDuplicated(nodes)||any(!nodes%in%catalog$table$Node))stop('Select one to ten internal nodes with at least four descendant tips each.')
 nodes<-sort(as.integer(nodes));tips<-catalog$descendants[nodes]
 if(anyDuplicated(unlist(tips)))stop('Selected clades overlap. Choose non-overlapping crown clades.')
 if(is.null(sampling))sampling<-data.frame(Node=nodes,Sampling=1)
 if(!is.data.frame(sampling)||!identical(sort(names(sampling)),c('Node','Sampling'))||nrow(sampling)!=length(nodes)||!is.numeric(sampling$Node)||anyNA(sampling$Node)||anyDuplicated(sampling$Node)||!setequal(sampling$Node,nodes)||!is.numeric(sampling$Sampling)||any(!is.finite(sampling$Sampling))||any(sampling$Sampling<=0|sampling$Sampling>1))stop('Sampling table must contain exactly Node,Sampling, one selected node per row and fractions in (0,1].')
 meta<-catalog$table[match(nodes,catalog$table$Node),,drop=FALSE]
 meta$Sampling<-sampling$Sampling[match(nodes,sampling$Node)]
 membership<-do.call(rbind,lapply(seq_along(nodes),function(i)data.frame(Node=nodes[i],Taxon=tree$tip.label[tips[[i]]])))
 list(tree=catalog$tree,clades=meta,membership=membership,descendants=catalog$descendants,
      excluded=tree$tip.label[!seq_along(tree$tip.label)%in%unlist(tips)],fits=NULL)
}

guane_rates_clade_sampling <- function(text,nodes) {
 if(is.null(text)||!nzchar(trimws(text)))return(data.frame(Node=nodes,Sampling=1))
 tryCatch(utils::read.csv(text=text,check.names=FALSE,stringsAsFactors=FALSE),error=function(e)stop('Sampling table must contain exactly Node,Sampling, one selected node per row and fractions in (0,1].'))
}

guane_rates_clade_fit <- function(tree,nodes,sampling=NULL,models=c('Yule','BD'),survival=TRUE,optimizer='nlminb',maxit=2000,upper=NULL,start_lambda=NULL,start_mu=NULL,intervals=TRUE,slices=TRUE,profiles=TRUE,level=.95,points=31) {
 result<-guane_rates_clade_select(tree,nodes,sampling)
 if(!is.logical(profiles)||length(profiles)!=1||is.na(profiles))stop('Invalid profile settings.')
 if(profiles&&(length(level)!=1||!is.finite(level)||level<.8||level>.99||length(points)!=1||!is.finite(points)||points!=floor(points)||points<21||points>201))stop('Invalid profile settings.')
 shared<-list(models=models,survival=survival,optimizer=optimizer,maxit=maxit,upper=upper,start_lambda=start_lambda,start_mu=start_mu,intervals=intervals,slices=slices)
 fits<-list();audit<-list();trees<-list()
 for(i in seq_len(nrow(result$clades))){
  node<-result$clades$Node[i];key<-as.character(node)
  # Explicit user-selected descendants only. The ancestral stem is never included.
  sub<-ape::extract.clade(result$tree,node=node,root.edge=0,collapse.singles=TRUE)
  sub$root.edge<-NULL;trees[[key]]<-sub
  fit<-tryCatch(do.call(guane_rates_fit,c(list(tree=sub,sampling=result$clades$Sampling[i]),shared)),error=identity)
  message<-character()
  if(inherits(fit,'error')){message<-conditionMessage(fit);fit<-NULL} else {
   if(profiles&&any(fit$comparison$Converged))fit$profile<-tryCatch(guane_rates_profile(fit,level,points),error=function(e){message<<-c(message,conditionMessage(e));NULL})
   message<-c(message,fit$warnings);fits[[key]]<-fit
  }
  audit[[key]]<-data.frame(Node=node,Successful_models=if(is.null(fit))0 else sum(fit$comparison$Converged),Requested_models=length(models),Profile_available=!is.null(fit$profile),Message=paste(unique(message),collapse=' | '))
 }
 result$fits<-fits;result$trees<-trees;result$audit<-do.call(rbind,audit)
 result$inputs<-c(list(tree=tree,nodes=result$clades$Node,sampling=result$clades[,c('Node','Sampling')]),shared,list(profiles=profiles,level=level,points=points))
 result$version<-as.character(utils::packageVersion('diversitree'))
 result
}

# Tables are stacked for display only; DeltaAIC and weights remain within each clade.
guane_rates_clade_table <- function(result,field='estimates') {
 pieces<-lapply(names(result$fits),function(node){
  f<-result$fits[[node]];d<-switch(field,profile=f$profile$intervals,profile_curves=f$profile$curves,f[[field]])
  if(is.null(d)||!nrow(d))return(NULL)
  data.frame(Node=as.integer(node),Sampling=result$clades$Sampling[match(as.integer(node),result$clades$Node)],d,check.names=FALSE,row.names=NULL)
 })
 if(!length(pieces)||all(vapply(pieces,is.null,logical(1))))return(NULL)
 do.call(rbind,pieces)
}

guane_rates_clade_plot <- function(result,type='clade_tree',model='Yule',parameter='lambda',palette='Guane',lang='en',node=NULL,labels=TRUE,node_labels=TRUE,cex=.7) {
 txt<-function(x)guane_text(x,lang)
 if(length(cex)!=1||!is.finite(cex)||cex<.2||cex>2||!all(vapply(list(labels,node_labels),function(x)is.logical(x)&&length(x)==1&&!is.na(x),logical(1))))stop('Invalid clade graph settings.')
 if(type%in%c('clade_profile','clade_slice','clade_comparison')){
  f<-result$fits[[as.character(node)]];if(is.null(f))stop('Run clade models and select a saved clade first.')
  out<-guane_rates_plot(f,sub('clade_','',type),model,parameter,palette,lang)
  graphics::mtext(paste(txt('Node'),node,if(type!='clade_comparison')model else ''),side=1,line=4,cex=.7);return(invisible(out))
 }
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old))
 graphics::par(mar=c(5,5,4,2))
 nodes<-result$clades$Node;k<-length(nodes)
 colors<-if(palette=='Grayscale')grDevices::gray.colors(k,start=.15,end=.65) else grDevices::colorRampPalette(if(palette=='Legacy')c('#02b2ce','#bc6500','#702887') else c('#2f7d4f','#b16d00','#4660a4'))(k)
 if(type=='clade_tree'){
  tree<-result$tree;edgecol<-rep('grey75',nrow(tree$edge));tipcol<-rep('grey50',length(tree$tip.label));edges<-rep(1,nrow(tree$edge))
  for(i in seq_along(nodes)){
   inside<-c(nodes[i],which(vapply(result$descendants,function(x)length(x)>0&&all(x%in%result$descendants[[nodes[i]]]),logical(1))))
   take<-tree$edge[,1]%in%inside;edgecol[take]<-colors[i];edges[take]<-2.5
   tipcol[result$descendants[[nodes[i]]]]<-colors[i]
  }
  ape::plot.phylo(tree,edge.color=edgecol,edge.width=edges,tip.color=tipcol,show.tip.label=labels,cex=cex,no.margin=FALSE)
  ape::axisPhylo(backward=FALSE)
  if(node_labels){eligible<-setdiff(guane_rates_clade_catalog(tree)$table$Node,nodes);if(length(eligible))ape::nodelabels(text=eligible,node=eligible,frame='none',cex=cex,col='black',adj=c(1.1,-.3))}
  ape::nodelabels(text=nodes,node=nodes,frame='circle',bg=colors,col='white',cex=cex)
  graphics::title(main=txt('Selected crown clades'),xlab=txt('Branch-length units'))
  graphics::mtext(txt('Grey branches are outside selected crowns; stems are excluded.'),side=3,line=.25,cex=.65)
  return(invisible(result$membership))
 }
 if(type!='clade_rates')stop('Invalid clade graph settings.')
 d<-guane_rates_clade_table(result,'estimates');if(is.null(d))stop('Run clade models and select a saved clade first.')
 d<-d[d$Parameter==parameter,,drop=FALSE];if(!nrow(d))stop('No saved estimate for this parameter.')
 y<-seq_len(nrow(d));lim<-range(c(0,d$Estimate,d$Lower,d$Upper),finite=TRUE)
 graphics::par(mar=c(5,9,4,2))
 graphics::plot(d$Estimate,y,xlim=lim,ylim=c(.5,nrow(d)+.5),yaxt='n',ylab='',xlab=paste(parameter,txt('per branch-length unit')),pch=ifelse(d$Model=='Yule',16,17),col=colors[match(d$Node,nodes)],main=txt('Clade-specific rate estimates'))
 graphics::axis(2,at=y,labels=paste(txt('Node'),d$Node,d$Model),las=1,cex.axis=.8)
 good<-is.finite(d$Lower)&is.finite(d$Upper)
 graphics::segments(d$Lower[good],y[good],d$Upper[good],y[good],col=colors[match(d$Node[good],nodes)],lwd=2)
 graphics::abline(v=0,lty=3,col='grey60')
 graphics::mtext(txt('Bars: approximate 95% curvature intervals where available'),side=3,line=.25,cex=.65)
 invisible(d)
}

guane_rates_clade_script <- function(result,type='clade_tree',model='Yule',parameter='lambda',palette='Guane',lang='en',node=NULL,labels=TRUE,node_labels=TRUE,cex=.7) {
 helpers<-c('guane_ltt','guane_rates_data','guane_rates_fit','guane_rates_profile','guane_rates_plot','guane_rates_clade_catalog','guane_rates_clade_select','guane_rates_clade_fit','guane_rates_clade_table','guane_rates_clade_plot','guane_text')
 c('# Guane: separate crown-clade fits, not a joint shift test. AIC weights are within-clade only.',
 '# install.packages(c("ape", "diversitree"))',
 '# Sampling fractions and tree are fixed; intervals do not include selection or tree uncertainty.',
 guane_script_helpers(helpers),
 guane_r_assignment('result',result),guane_r_assignment('settings',list(type=type,model=model,parameter=parameter,palette=palette,lang=lang,node=node,labels=labels,node_labels=node_labels,cex=cex)),
 '# Optional refit (after analysis): refitted <- do.call(guane_rates_clade_fit, result$inputs)',
 'opened <- grDevices::dev.cur()==1L','if(opened) grDevices::pdf("guane-clades.pdf",width=10,height=7)',
 'do.call(guane_rates_clade_plot,c(list(result=result),settings))','if(opened) grDevices::dev.off()','sessionInfo()')
}

# Joint whole-tree partitions using the public diversitree split likelihood.
