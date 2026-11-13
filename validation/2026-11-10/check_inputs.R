# Non-optimization checks; run from Guane/.
pkgload::load_all('.',quiet=TRUE)
old <- '../Guane-manuscript'
out <- 'validation/2026-11-10'
rows <- list()
for(ordered in c(TRUE,FALSE)) for(model in c('ER','transient','ARD')) {
  tag <- paste(if(ordered)'ordered' else 'unordered',model,sep='_')
  b <- readRDS(file.path(old,'results',paste0('butterfly_',tag,'.rds')))
  d <- guane_poly_data(b$tree,b$traits,b$taxon,b$trait,ordered,b$state_order,if(ordered)3 else NULL)
  index <- guane_poly_matrix(d$states,model)
  stopifnot(identical(index,b$index))
  p <- phytools::fitpolyMk(b$tree,d$x,model=model,ordered=ordered,
    order=if(ordered)b$state_order else NULL,max.poly=3,quiet=TRUE,
    fixedQ=b$Q,pi='equal',lik.func='lik')
  stopifnot(max(abs(p$logLik-b$logLik))<1e-6,
    max(abs(rowSums(b$probabilities)-1))<1e-8,
    max(abs(rowSums(b$Q)))<1e-8)
  rows[[length(rows)+1]] <- data.frame(Model=tag,Guane=b$logLik,
    DirectFitpolyMk=p$logLik,Difference=p$logLik-b$logLik)
}
write.csv(do.call(rbind,rows),file.path(out,'butterfly_fixedQ_parity.csv'),row.names=FALSE)
for(model in c('HiSSE','CID-2','CID-4')) {
  s <- guane_hidden_spec(model,'By diversification class')
  oldspec <- readRDS(file.path(old,'results/frog_planned_constraints.rds'))[[model]]
  stopifnot(identical(s,oldspec))
}
h<-guane_hidden_spec('HiSSE','By diversification class')
c2<-guane_hidden_spec('CID-2','By diversification class')
stopifnot(identical(is.na(h$trans),is.na(c2$trans)))
for(j in unique(as.vector(h$trans[!is.na(h$trans)])))
  stopifnot(length(unique(c2$trans[h$trans==j & !is.na(h$trans)]))==1)
tr <- ape::read.tree(file.path(old,'data/Moen_S2_tree.tre'))
d <- read.csv(file.path(old,'data/Moen_S1_traits.csv'))
stopifnot(length(tr$tip.label)==1579,setequal(tr$tip.label,d$species),
  sum(d$states==0)==1467,sum(d$states==1)==112)
cat('All six butterfly likelihood checks and all three frog constraint checks passed.\n')
capture.output(sessionInfo(),file=file.path(out,'validation_session.txt'))
