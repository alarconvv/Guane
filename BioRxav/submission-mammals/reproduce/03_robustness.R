r<-readRDS('terminal/fits.rds');tree<-r$tree;z<-r$traits
source('source/core_mod_signal_PGLS.R');source('source/core_mod_signal_signal.R');source('source/app_tasks.R');source('source/core_mod_data_base.R')
loo<-do.call(rbind,lapply(tree$tip.label,function(id){t<-ape::drop.tip(tree,id);d<-z[z$taxon!=id,];fit<-guane_pgls(t,d,'taxon','ln_home_range_km2','ln_body_mass_kg',model='BM',method='REML');b<-fit$coefficients[2,];s<-guane_signal(t,d,'taxon','ln_home_range_km2',seed=20261201,nsim=999);data.frame(Omitted=id,Slope=b$Estimate,Lower=b$Lower,Upper=b$Upper,K=s$Estimate[1],K_P=s$P_value[1],Lambda=s$Estimate[2],Lambda_P=s$P_value[2],Warnings=paste(fit$warnings,collapse='; '))}))
stopifnot(nrow(loo)==49,all(is.finite(loo$Slope)),setequal(loo$Omitted,tree$tip.label))
write.csv(loo,'supplement/leave-one-out.csv',row.names=FALSE)
ind<-guane_pgls(tree,z,'taxon','ln_home_range_km2','ln_body_mass_kg',model='Pagel',value=0,fixed=TRUE,method='REML');write.csv(ind$coefficients,'supplement/independence-reference.csv',row.names=FALSE)
s<-data.frame(LOO_min=min(loo$Slope),LOO_max=max(loo$Slope),All_positive=all(loo$Slope>0),All_lower_positive=all(loo$Lower>0),K_P_min=min(loo$K_P),K_P_max=max(loo$K_P),Lambda_P_min=min(loo$Lambda_P),Lambda_P_max=max(loo$Lambda_P),Independence_slope=ind$coefficients$Estimate[2],Largest_change_taxon=loo$Omitted[which.max(abs(loo$Slope-r$pgls$coefficients$Estimate[2]))])
write.csv(s,'supplement/robustness-summary.csv',row.names=FALSE);print(s)
