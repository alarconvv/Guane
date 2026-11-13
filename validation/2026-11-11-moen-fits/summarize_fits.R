# Run from Guane/ after or during fit_six_models.R; never presents incomplete weights.
run_dir <- 'validation/2026-11-11-moen-fits'
inputs <- readRDS(file.path(run_dir,'inputs.rds'))
models <- names(inputs$settings)
expected_specs <- readRDS('validation/2026-11-11-specification/moen_exact_specs.rds')
results <- setNames(lapply(models,function(m){
 p <- file.path(run_dir,paste0(m,'_result.rds'))
 if(file.exists(p))readRDS(p) else NULL
}),models)
finished <- names(results)[!vapply(results,is.null,logical(1))]
if(!length(finished))stop('No completed models yet.')
rows <- lapply(finished,function(m){
 r <- results[[m]];s <- inputs$settings[[m]]
 for(n in names(inputs$common))stopifnot(identical(r$inputs[[n]],inputs$common[[n]]))
 for(n in names(s))stopifnot(identical(r$inputs[[n]],s[[n]]))
 stopifnot(length(r$tree$tip.label)==1579,
  identical(r$specs$Custom,expected_specs[[m]]),
  identical(r$fits$Custom$native$trans.matrix,expected_specs[[m]]$trans))
 row <- r$comparison;row$Model <- m
 row$AllStartsConverged <- all(r$attempts$Converged)
 row$AllStartsVerified <- all(r$attempts$Verified)
 row$BetterUnconverged <- r$fits$Custom$better_failed
 row$ElapsedSeconds <- r$elapsed[['elapsed']]
 row
})
comparison <- do.call(rbind,rows)
comparison$DeltaAIC <- if(length(finished)==length(models))comparison$AIC-min(comparison$AIC) else NA_real_
edges <- list(full2=c('full3','suicide4','suicide6','CID2'),full3=c('suicide6','CID2'),
 suicide4=c('suicide6','CID2'),suicide6='CID2')
nesting <- do.call(rbind,lapply(names(edges),function(parent)do.call(rbind,
 lapply(edges[[parent]],function(child){
  a<-results[[parent]];b<-results[[child]]
  delta<-if(is.null(a)||is.null(b))NA_real_ else a$comparison$LogLik-b$comparison$LogLik
  data.frame(Parent=parent,Submodel=child,LogLikDifference=delta,
   Passed=if(is.na(delta))NA else delta>= -1e-4)
 }))))
eligible <- length(finished)==length(models) &&
 all(comparison$Finite & comparison$Converged & comparison$Verified &
 comparison$AllStartsConverged & comparison$AllStartsVerified &
 !comparison$Boundary & !comparison$BetterUnconverged & comparison$StartSpread<=1e-4) &&
 all(nesting$Passed)
comparison$Weight <- NA_real_
if(eligible){w<-exp(-comparison$DeltaAIC/2);comparison$Weight<-w/sum(w)}
comparison$Interpretation <- if(eligible)'Passed numerical checks; assess biological adequacy separately' else
 'Provisional optimization results; model weights withheld'
write.csv(comparison,file.path(run_dir,'six_model_comparison.csv'),row.names=FALSE)
write.csv(nesting,file.path(run_dir,'nested_likelihood_checks.csv'),row.names=FALSE)
attempts <- do.call(rbind,lapply(finished,function(m){x<-results[[m]]$attempts;x$Model<-m;x}))
write.csv(attempts,file.path(run_dir,'all_attempts.csv'),row.names=FALSE)
print(comparison);print(nesting)
cat('Completed:',length(finished),'of',length(models),'models. Weight eligibility:',eligible,'\n')
bounds <- do.call(rbind,lapply(finished,function(m){
 a<-results[[m]]$fits$Custom$native
 j<-seq_along(a$starting.vals)
 pos<-vapply(j,function(i)which(a$index.par==i)[1],integer(1))
 value<-unname(a$solution[pos])
 data.frame(Model=m,Parameter=names(a$solution)[pos],Value=value,
  Lower=exp(a$lower.bounds),Upper=exp(a$upper.bounds),
  AtLower=log(value)<=a$lower.bounds+1e-5,
  AtUpper=log(value)>=a$upper.bounds-1e-5)
}))
write.csv(bounds,file.path(run_dir,'free_parameter_bounds.csv'),row.names=FALSE)
