# Small synthetic execution check, not frog evidence or convergence validation.
source('validation/2026-11-11-specification/moen_models.R')
set.seed(20261111)
tree<-ape::rcoal(12)
traits<-data.frame(species=tree$tip.label,states=rep(0:1,6))
rows<-list()
for(n in names(moen_settings)) {
  r<-do.call(guane_hidden_fit,c(list(tree=tree,traits=traits,taxon='species',
    trait='states',state0='0',starts=1,verify=FALSE,maxeval=10,
    sampling=c(.4994893,.6666667),seed=20261111),moen_settings[[n]]))
  native<-r$fits$Custom$native
  stopifnot(r$comparison$Finite,r$comparison$Parameters==counts$Total[counts$Model==n],
    identical(zero_na(native$trans.matrix),zero_na(moen_specs[[n]]$trans)))
  s<-moen_specs[[n]]
  for(field in c('turnover','eps')) {
    values<-native$solution[paste0(field,s$states)]
    for(j in unique(s[[field]]))stopifnot(diff(range(values[s[[field]]==j]))==0)
  }
  rows[[n]]<-data.frame(Model=n,Expected=counts$Total[counts$Model==n],
    Native=r$comparison$Parameters,NativeStatus=r$attempts$Convergence,
    Weight=r$comparison$Weight)
}
write.csv(do.call(rbind,rows),file.path(out,'synthetic_native_checks.csv'),row.names=FALSE)
capture.output(sessionInfo(),file=file.path(out,'sessionInfo.txt'))
cat('All six synthetic native index and parameter-sharing checks passed.\n')
