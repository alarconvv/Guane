# Return an independently optimized starting vector to Guane's own optimizer.
pkgload::load_all('.',quiet=TRUE)
out<-'validation/2026-11-10'
t<-read.csv(file.path(out,'butterfly_independent_search.csv'))
t<-t[t$Ordering=='ordered' & t$Convergence==0,]
best<-t$Run[which.max(t$LogLik)]
z<-readRDS(file.path(out,paste0('butterfly_independent_ordered_',best,'.rds')))
b<-readRDS('../Guane-manuscript/results/butterfly_ordered_ARD.rds')
r<-guane_asr_poly(b$tree,b$traits,b$taxon,b$trait,model='ARD',compare=FALSE,
  ordered=TRUE,state_order=b$state_order,max_poly=3,
  advanced=list(start_mode='custom',q_init=pmin(99.999,pmax(1e-10,z$rates)),optimizer='nlminb',logscale=TRUE))
stopifnot(r$logLik>=b$logLik-1e-5,max(abs(rowSums(r$probabilities)-1))<1e-8)
saveRDS(r,file.path(out,'butterfly_ordered_guane_refit.rds'))
write.csv(r$comparison,file.path(out,'butterfly_ordered_guane_refit.csv'),row.names=FALSE)
delta<-r$probabilities-b$probabilities[rownames(r$probabilities),colnames(r$probabilities)]
cat('Maximum absolute change in node probability:',max(abs(delta)),'\n')
print(r$comparison);print(r$attempts);print(r$warnings)
write.csv(data.frame(State=colnames(r$probabilities),Previous=b$probabilities[1,],Refined=r$probabilities[1,]),
  file.path(out,'butterfly_ordered_root_comparison.csv'),row.names=FALSE)
writeLines(guane_asr_poly_script(r,labels=FALSE),file.path(out,'butterfly_ordered_export.R'))
