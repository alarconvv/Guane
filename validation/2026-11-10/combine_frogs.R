# Reapply Guane's comparison rules to completed native checkpoints; no refitting.
pkgload::load_all('.',quiet=TRUE)
out <- 'validation/2026-11-10'
models <- c('HiSSE','CID-2','CID-4')
paths <- unlist(lapply(models,function(m)file.path(out,paste0('frog_',gsub('-','',m),'_restart',1:2,'.rds'))))
stopifnot(all(file.exists(paths)))
saved <- lapply(paths,readRDS)
tr <- ape::read.tree('../Guane-manuscript/data/Moen_S2_tree.tre')
d <- read.csv('../Guane-manuscript/data/Moen_S1_traits.csv')
for(i in seq_along(saved)) {
  n <- saved[[i]];s <- guane_hidden_spec(rep(models,each=2)[i],'By diversification class')
  stopifnot(identical(n$phy,tr),identical(n$trans.matrix,s$trans),
    isTRUE(all.equal(n$f,c(.4994893,.6666667))),n$condition.on.survival,
    identical(n$root.type,'madfitz'),is.null(n$root.p))
}
f <- guane_hidden_fit;env <- new.env(parent=environment(f));i <- 0L
env$guane_hidden_native <- function(...) {i<<-i+1L;saved[[i]]}
environment(f) <- env
r <- f(tr,d,'species','states','0',models=models,eps_mode='By diversification class',
  sampling=c(.4994893,.6666667),starts=2,seed=20261110,sann=FALSE,maxeval=3000,
  verify=TRUE,tolerance=1e-8,turnover_start=.05,eps_start=.5,transition_start=.01,
  turnover_upper=10,eps_upper=10,transition_upper=100)
stopifnot(i==6L)
r$attempts$ScalarInitialIgnoredByRestart<-r$attempts$Initial
r$attempts$Initial<-vapply(saved,function(n)paste(format(exp(n$starting.vals),digits=12),collapse=', '),character(1))
r$attempts$InitialScale<-'Natural free parameters in index.par order'
r$attempts$RestartFile<-sub('_restart','_initial',basename(paths))
r$attempts$SeedBeforeRestartOverride<-r$attempts$Seed
r$attempts$Seed<-NULL
r$attempts$RNGInitialization<-rep(c('set.seed(20261110)',
  'set.seed(20261112), then rnorm(number of free parameters, 0, 0.3)'),3)
r$validation_note <- 'Comparison replays native checkpoints from refine_frogs.R. Initial contains actual free-parameter vectors; ScalarInitialIgnoredByRestart preserves the unused ordinary Guane settings.'
saveRDS(r,file.path(out,'frog_combined.rds'))
write.csv(r$comparison,file.path(out,'frog_combined_comparison.csv'),row.names=FALSE)
write.csv(r$attempts,file.path(out,'frog_combined_attempts.csv'),row.names=FALSE)
writeLines(r$warnings,file.path(out,'frog_combined_warnings.txt'))
pdf(file.path(out,'frog_verification.pdf'),width=10,height=7)
guane_hidden_plot(r,guane_hidden_settings(type='verification'))
dev.off()
print(r$comparison);print(r$warnings)
