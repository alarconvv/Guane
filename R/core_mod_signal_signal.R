guane_signal <- function(tree, traits, taxon, trait, seed = 999, nsim = 999) {
  if(length(nsim)!=1 || !is.finite(nsim) || nsim<99 || nsim>9999 || nsim!=floor(nsim)) stop('Choose 99–9999 integer randomizations.')
  if(length(seed)!=1 || !is.finite(seed) || seed<0 || seed>2147483647 || seed!=floor(seed)) stop('Choose a nonnegative integer seed up to 2147483647.')
  issues <- guane_validate(tree, traits, taxon, trait)
  if (any(issues$level %in% c('Error', 'Required'))) stop('Resolve data issues before running.')
  x <- setNames(traits[[trait]], as.character(traits[[taxon]]))[tree$tip.label]
  set.seed(seed)
  k <- phytools::phylosig(tree, x, method = 'K', test = TRUE, nsim = nsim)
  lambda <- phytools::phylosig(tree, x, method = 'lambda', test = TRUE)
  if(any(!is.finite(c(k$K,k$P,lambda$lambda,lambda$P,lambda$logL,lambda$logL0)))) stop('Signal analysis returned nonfinite estimates. Inspect the inputs.')
  answer <- data.frame(Metric = c("Blomberg's K", "Pagel's lambda"), Estimate = c(k$K, lambda$lambda),
    P_value = c(k$P, lambda$P), Test = c(paste(nsim, 'test draws (including observed)'),  'Likelihood ratio: lambda = 0'))
  attr(answer,'snapshot')<-list(tree=tree,traits=traits[match(tree$tip.label,as.character(traits[[taxon]])),c(taxon,trait),drop=FALSE],taxon=taxon,trait=trait,seed=seed,nsim=nsim,x=x)
  attr(answer,'randomized_K')<-k$sim.K[-1]
  answer
}


# Colors show observed tips only; no ancestral values are inferred by this display.
guane_signal_plot <- function(result, type='tree', palette='Guane', font=.8, lang='en') {
 snapshot<-attr(result,'snapshot');x<-snapshot$x;tree<-snapshot$tree
 colors<-grDevices::colorRampPalette(if(palette=='Grayscale') c('#eeeeee','#222222') else c('#e4f1cf','#54a37a','#0d5368'))(256)
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old))
 if(type=='null') {
  values<-attr(result,'randomized_K')
  graphics::par(mar=c(5,5,3,1))
  graphics::hist(values,breaks='FD',xlim=range(c(values,result$Estimate[1])),main=guane_text('Randomized K values',lang),xlab="Blomberg's K",ylab=guane_text('Frequency',lang),col=colors[150],border='white')
  graphics::abline(v=result$Estimate[1],lwd=2,lty=2,col=colors[256])
  graphics::legend('topright',legend=paste(guane_text('Observed K',lang),formatC(result$Estimate[1],digits=4,format='fg')),lty=2,lwd=2,col=colors[256],bty='n')
 } else {
  limits<-range(x);indices<-pmax(1,pmin(256,1+floor((x-limits[1])/diff(limits)*255)))
  reserve<-max(3,length(x)*.15)
  graphics::par(mar=c(1,1,2,1))
  ape::plot.phylo(tree,tip.color='#345747',cex=font,edge.color='#607369',edge.width=1.5,no.margin=FALSE,
    y.lim=c(-reserve,length(x)+1),label.offset=max(ape::node.depth.edgelength(tree))*.02)
  ape::tiplabels(pch=21,bg=colors[indices],col='#345747',cex=1)
  graphics::title(main=guane_text('Observed tip values',lang),cex.main=1)
  bounds<-graphics::par('usr')[1:2];width<-diff(bounds)
  positions<-seq(bounds[1]+width*.08,bounds[2]-width*.08,length.out=257)
  graphics::rect(positions[-257],-reserve*.35,positions[-1],-reserve*.15,col=colors,border=NA)
  anchors<-seq(1,257,length.out=5)
  graphics::text(positions[anchors],-reserve*.53,labels=format(signif(seq(limits[1],limits[2],length.out=5),3)),cex=.8)
  graphics::text(mean(positions),-reserve*.83,labels=snapshot$trait,cex=.85)

 }
 invisible(x)
}

guane_signal_script <- function(result, type='tree', palette='Guane', font=.8, lang='en', height=7) {
 s<-attr(result,'snapshot')
 helpers<-c('guane_validate','guane_signal','guane_text','guane_signal_plot')
 c('# Guane phylogenetic signal: open in RStudio and Source.',
   '# Prepared inputs and plotting functions are embedded. Edit plot_settings below.',
   '# Install once if needed: install.packages(c("ape", "phytools"))',
   paste0('# R ',getRversion(),'; ape ',utils::packageVersion('ape'),'; phytools ',utils::packageVersion('phytools')),
   vapply(helpers,function(name) paste0(name,' <- ',paste(deparse(get(name,mode='function')),collapse='\n')),character(1)),
   guane_r_assignment('inputs',s[c('tree','traits','taxon','trait','seed','nsim')]),
   'result <- do.call(guane_signal, inputs)','print(result)',
   guane_r_assignment('plot_settings',list(type=type,palette=palette,font=font,lang=lang)),
   guane_r_assignment('figure_height',height),
   'do.call(guane_signal_plot, c(list(result=result), plot_settings))',
   '# Optional PDF using the same settings:',
   '# pdf("guane-signal.pdf", width=9, height=figure_height)',
   '# do.call(guane_signal_plot, c(list(result=result), plot_settings)); dev.off()',
   'sessionInfo()')
}
