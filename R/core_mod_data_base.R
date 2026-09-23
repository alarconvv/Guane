# Independent computations shared by the interface and exported scripts.
guane_example <- function() {
  folder<-file.path(guane_resource_root(),'example')
  list(tree=ape::read.tree(file.path(folder,'guane-example-tree.nwk')),
       traits=utils::read.csv(file.path(folder,'guane-example-traits.csv'),check.names=FALSE,stringsAsFactors=FALSE))
}

guane_read_tree <- function(path) {
  first <- readLines(path, n = 1, warn = FALSE)
  tree <- if (grepl('#NEXUS', first, ignore.case = TRUE)) ape::read.nexus(path) else ape::read.tree(path)
  if (!inherits(tree, 'phylo')) stop('Upload exactly one tree for this first workflow.')
  tree
}
guane_validate <- function(tree, traits, taxon, trait) {
  issues <- data.frame(level = character(), message = character())
  add <- function(level, message) issues[nrow(issues) + 1L, ] <<- c(level, message)
  if (is.null(tree)) add('Required', 'Load a phylogenetic tree.')
  if (is.null(traits)) add('Required', 'Load a CSV trait table.')
  if (!is.null(tree)) {
    if (anyDuplicated(tree$tip.label)) add('Error', 'Tree tip labels must be unique.')
    if (anyNA(tree$tip.label) || any(!nzchar(trimws(tree$tip.label)))) add('Error', 'Tree contains empty taxon labels.')
    if (is.null(tree$edge.length) || any(!is.finite(tree$edge.length)) || any(tree$edge.length <= 0)) add('Error', 'Signal analysis requires finite, positive branch lengths.')
    if (!ape::is.rooted(tree)) add('Error', 'Root the tree before signal analysis.')
    if (!ape::is.binary(tree)) add('Warning', 'Tree contains polytomies; inspect their biological meaning.')
    if (!is.null(tree$edge.length) && !ape::is.ultrametric(tree)) add('Note', 'Tree is not ultrametric. Signal analysis can use it; verify branch-length units.')
  }
  if (!is.null(traits)) {
    if (is.null(taxon) || !taxon %in% names(traits)) add('Required', 'Select the taxon column.') else {
      ids <- as.character(traits[[taxon]])
      if (anyNA(ids) || any(!nzchar(trimws(ids)))) add('Error', 'Trait table contains empty taxon labels.')
      if (anyDuplicated(ids)) add('Error', 'Trait taxon labels must be unique.')
      if (!is.null(tree) && !setequal(ids, tree$tip.label)) add('Error', paste0('Taxon mismatch: ', length(setdiff(tree$tip.label, ids)), ' tree tips without traits; ', length(setdiff(ids, tree$tip.label)), ' table taxa outside tree. Use matched taxa only after reviewing this report.'))
    }
    if (is.null(trait) || !trait %in% names(traits)) add('Required', 'Select a numeric trait.') else {
      x <- traits[[trait]]
      if (!is.numeric(x) || any(!is.finite(x))) add('Error', 'Selected trait must contain only finite numeric values; correct missing values before running.')
      else if (length(unique(x)) < 2) add('Error', 'Selected trait has no variation.')
    }
  }
  if (!is.null(tree) && length(tree$tip.label) < 4) add('Error', 'At least four matched taxa are required.')
  issues
}

guane_transform <- function(traits, trait, method) {
 x<-traits[[trait]]
 if(any(!is.finite(x))) stop('Correct nonfinite values first.')
 if(method=='log' && any(x<=0)) stop('Log requires positive values.')
 if(method=='reciprocal' && any(x==0)) stop('Reciprocal requires nonzero values.')
 y<-switch(method,log=log(x),exp=exp(x),quadratic=x^2,reciprocal=1/x)
 if(is.null(y) || any(!is.finite(y))) stop('Transformation produced nonfinite values.')
 dest<-paste0(trait,'_',method)
 if(dest %in% names(traits)) stop('That derived column already exists. Select another source or reset.')
 traits[[dest]]<-y
 list(traits=traits,column=dest)
}
guane_normality <- function(x) {
 if(any(!is.finite(x)) || length(x)<3 || length(x)>5000 || length(unique(x))<2) stop('Shapiro-Wilk requires 3–5000 finite, nonconstant values.')
 stats::shapiro.test(x)
}
guane_pic <- function(tree,traits,taxon,trait) {
 if(any(guane_validate(tree,traits,taxon,trait)$level %in% c('Error','Required'))) stop('Resolve data issues before computing contrasts.')
 if(!ape::is.binary(tree)) stop('Independent contrasts require a bifurcating tree.')
 x<-setNames(traits[[trait]],traits[[taxon]])
 z<-ape::pic(x,tree)
 data.frame(Node=names(z),Contrast=as.numeric(z))
}
guane_plot_tree <- function(tree,layout,direction,lengths,labels,font,edge,nodes,lang='en') {
 if(is.null(tree)) {plot.new();text(.5,.55,guane_text('Your tree will appear here',lang),col='#73847a',cex=1.3);text(.5,.43,guane_text('Load a tree or start with the example dataset',lang),col='#94a198',cex=.9);return(invisible())}
 old<-par(mar=c(2,2,2,3),fg='#345747');on.exit(par(old))
 ape::plot.phylo(tree,type=layout,direction=direction,use.edge.length=lengths,show.tip.label=labels,cex=font,edge.width=edge,edge.color='#34765b',no.margin=FALSE)
 if(isTRUE(nodes)) ape::nodelabels(frame='circle',cex=.65,bg='#edf3e9')
}

# Distribution displays never transform or remove values from the dataset.
guane_distribution <- function(x) {
 if(!is.numeric(x)) stop('Select a numeric trait.')
 list(values=x[is.finite(x)],excluded=sum(!is.finite(x)))
}
guane_plot_distribution <- function(x, type='hist', bins=15, rug=TRUE, label='Trait',lang='en') {
 d<-guane_distribution(x);x<-d$values
 if(!length(x)) {graphics::plot.new();graphics::text(.5,.5,guane_text('No finite numeric observations',lang));return(invisible(d))}
 old<-graphics::par(mar=c(4,4,2,1));on.exit(graphics::par(old))
 if(type=='qq') {
  stats::qqnorm(x,main='',xlab=guane_text('Theoretical quantiles',lang),ylab=label,col='#2f7d4f');if(length(unique(x))>1) stats::qqline(x,col='#0d5368')
 } else if(type=='density') {
  if(length(x)<2 || length(unique(x))<2) {graphics::plot.new();graphics::text(.5,.5,guane_text('Density requires varying observations',lang));return(invisible(d))}
  graphics::plot(stats::density(x),main='',xlab=label,ylab=guane_text('Density',lang),col='#2f7d4f',lwd=2)
  if(rug) graphics::rug(x,col='#0d5368')
 } else {
  graphics::hist(x,breaks=bins,main='',xlab=label,ylab=guane_text('Frequency',lang),col='#86b9a0',border='white')
  if(rug) graphics::rug(x,col='#0d5368')
 }
 invisible(d)
}

# dput preserves types, names, missing values and tree precision in a portable script.
guane_r_assignment <- function(name, value) {
 paste0(name,' <- ',paste(capture.output(dput(value, control=c("keepNA","keepInteger","showAttributes"))),collapse='\n'))
}
guane_preparation_script <- function(steps) {
 c('# Guane data preparation: run in a fresh R session.',
   '# Original input objects are embedded; no uploaded file paths are needed.',
   '# Install ape if needed: install.packages("ape")',
   'tree <- NULL', 'traits <- NULL',unlist(steps,use.names=FALSE),
   '# Prepared objects: tree and traits. Undone actions are not replayed.',
   'sessionInfo()')
}

# Embed the same plot functions and settings used on screen, without requiring Guane.
guane_data_plot_script <- function(kind, settings) {
 functions<-if(kind=='tree') c('guane_text','guane_plot_tree') else c('guane_text','guane_distribution','guane_plot_distribution')
 c('# Guane editable graph: open in RStudio and Source; edit settings below.',
   if(kind=='tree') '# Install ape if needed: install.packages("ape")',
   vapply(functions,function(name) paste0(name,' <- ',paste(deparse(get(name,mode='function')),collapse='\n')),character(1)),
   guane_r_assignment('settings',settings),
   sprintf('do.call(%s, settings)',if(kind=='tree') 'guane_plot_tree' else 'guane_plot_distribution'),
   'sessionInfo()')
}
