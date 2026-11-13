# Run from Guane/: Rscript validation/2026-11-10/refine_frogs.R CID-2
# Uses Guane's unchanged model, likelihood and verification adapter.
# Native restart objects preserve full parameter vectors from earlier checks;
# this restart facility is not exposed by the graphical card.
pkgload::load_all('.', quiet=TRUE)
model <- commandArgs(TRUE)[1]
stopifnot(model %in% c('HiSSE','CID-2','CID-4'))
out <- 'validation/2026-11-10'
old <- '../Guane-manuscript'
tag <- gsub('-','',model)
prior <- readRDS(file.path(old,'results',paste0('frog_',tag,'_bounded.rds')))
native <- prior$fits[[model]]$native
par <- native$guane_optimizer$verification_parameters
stopifnot(length(par)==length(native$starting.vals),all(is.finite(par)))
restart <- native
restart$solution[] <- c(exp(par),0)[restart$index.par]
fit <- guane_hidden_fit
scope <- new.env(parent=environment(fit))
attempt <- 0L
scope$guane_hidden_native <- function(...) {
  attempt <<- attempt+1L
  path <- file.path(out,paste0('frog_',tag,'_restart',attempt,'.rds'))
  if(file.exists(path)) return(readRDS(path))
  r <- restart
  if(attempt>1) {
    set.seed(20261110+attempt)
    p <- pmin(r$upper.bounds-.001,pmax(r$lower.bounds+.001,par+rnorm(length(par),0,.3)))
    r$solution[] <- c(exp(p),0)[r$index.par]
  }
  saveRDS(r,file.path(out,paste0('frog_',tag,'_initial',attempt,'.rds')))
  cat('Starting',model,attempt,format(Sys.time()),'\n');flush.console()
  ans <- guane_hidden_native(...,restart.obj=r)
  saveRDS(ans,path)
  cat('Saved',model,attempt,ans$loglik,format(Sys.time()),'\n');flush.console()
  ans
}
environment(fit) <- scope
tr <- ape::read.tree(file.path(old,'data/Moen_S2_tree.tre'))
d <- read.csv(file.path(old,'data/Moen_S1_traits.csv'))
stopifnot(length(tr$tip.label)==1579,setequal(tr$tip.label,d$species))
elapsed <- system.time(result <- fit(tr,d,'species','states','0',models=model,
  eps_mode='By diversification class',sampling=c(.4994893,.6666667),starts=2,
  seed=20261110,sann=FALSE,maxeval=3000,verify=TRUE,tolerance=1e-8,
  turnover_start=.05,eps_start=.5,transition_start=.01,
  turnover_upper=10,eps_upper=10,transition_upper=100))
result$validation_restart_files <- paste0('frog_',tag,'_initial',1:2,'.rds')
saveRDS(result,file.path(out,paste0('frog_',tag,'_refined.rds')))
for(field in c('comparison','attempts','estimates'))
  write.csv(result[[field]],file.path(out,paste0('frog_',tag,'_',field,'.csv')),row.names=FALSE)
print(elapsed);print(result$comparison);print(result$attempts)
capture.output(sessionInfo(),file=file.path(out,paste0('frog_',tag,'_session.txt')))
