# Run from Guane/: Rscript validation/2026-11-11-moen-fits/fit_six_models.R
# Uses Guane's unchanged fitting functions; checkpoints each completed start.
pkgload::load_all('.',quiet=TRUE)
run_dir <- 'validation/2026-11-11-moen-fits'
settings <- readRDS('validation/2026-11-11-specification/moen_custom_settings.rds')
counts <- read.csv('validation/2026-11-11-specification/model_parameter_counts.csv')
tree <- ape::read.tree('../Guane-manuscript/data/Moen_S2_tree.tre')
traits <- read.csv('../Guane-manuscript/data/Moen_S1_traits.csv')
stopifnot(length(tree$tip.label)==1579,nrow(traits)==1579,
 !anyDuplicated(traits$species),setequal(tree$tip.label,traits$species),
 identical(as.integer(table(traits$states)),c(1467L,112L)))
common <- list(tree=tree,traits=traits,taxon='species',trait='states',state0='0',
 sampling=c(.4994893,.6666667),survival=TRUE,root_type='madfitz',root_mode='Likelihood',
 starts=2,seed=20261111,sann=FALSE,sann_its=10000,tolerance=sqrt(.Machine$double.eps),
 turnover_start=.05,eps_start=.5,transition_start=.01,
 turnover_upper=10,eps_upper=10,transition_upper=100,ode_eps=0,
 verify=TRUE,maxeval=100000)
saveRDS(list(common=common,settings=settings),file.path(run_dir,'inputs.rds'))
capture.output(sessionInfo(),file=file.path(run_dir,'sessionInfo.txt'))
run_one <- function(model) {
 final <- file.path(run_dir,paste0(model,'_result.rds'))
 if(file.exists(final))return(model)
 log <- file.path(run_dir,paste0(model,'.log'))
 note <- function(...)cat(format(Sys.time()),..., '\n',file=log,append=TRUE)
 fit <- guane_hidden_fit
 scope <- new.env(parent=environment(fit));attempt <- 0L
 scope$guane_hidden_native <- function(...) {
  attempt <<- attempt+1L
  path <- file.path(run_dir,paste0(model,'_start',attempt,'.rds'))
  if(file.exists(path))return(readRDS(path))
  note('Starting',model,'start',attempt)
  ans <- guane_hidden_native(...)
  saveRDS(ans,paste0(path,'.tmp'));file.rename(paste0(path,'.tmp'),path)
  note('Saved start',attempt,'logLik',ans$loglik,'status',ans$guane_optimizer$status,
       'verified',ans$guane_optimizer$verified)
  ans
 }
 environment(fit) <- scope
 tryCatch({
  elapsed <- system.time(result <- do.call(fit,c(common,settings[[model]])))
  stopifnot(result$comparison$Finite,
   result$comparison$Parameters==counts$Total[counts$Model==model])
  result$moen_model <- model
  result$elapsed <- elapsed
  saveRDS(result,paste0(final,'.tmp'));file.rename(paste0(final,'.tmp'),final)
  for(field in c('comparison','attempts','estimates','transitions')) {
   tab <- result[[field]];tab$Model <- model
   write.csv(tab,file.path(run_dir,paste0(model,'_',field,'.csv')),row.names=FALSE)
  }
  note('Completed',model,'elapsed seconds',elapsed[['elapsed']])
  model
 },error=function(e){note('ERROR',conditionMessage(e));paste(model,conditionMessage(e))})
}
# Three independent R processes; each native likelihood uses one data.table thread.
status <- parallel::mclapply(names(settings),run_one,mc.cores=3,mc.preschedule=FALSE)
writeLines(unlist(status),file.path(run_dir,'completion.txt'))
