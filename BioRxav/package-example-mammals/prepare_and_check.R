# Run from this folder: Rscript --vanilla prepare_and_check.R
stopifnot(as.character(packageVersion('phytools'))=='2.5.2')
data(mammal.data,package='phytools');data(mammal.tree,package='phytools')
dir.create('data',showWarnings=FALSE);dir.create('results',showWarnings=FALSE)
# Independent transcription: Garland et al. 1993, Table 1, p.273.
mass<-c(265,251.3,93.4,4.4,7,2.5,11.6,35.3,13.3,20,8.8,3.7,4.8,26.8,52,58.8,52.4,161,155.8,250,2000,1200,200,350,235,95,550,1075,620,865,511,62.5,20.5,37.5,5,113.5,85,226.5,53.25,216,130,136,50,300,55,384,100,57,74)
area<-c(115.6,82.8,56.8,1.05,1.14,2.5,.87,202.8,45,160,9.1,1.1,3.87,152.8,25,62.1,23.2,69.6,236,2,6.65,15.6,35,22.5,165,.5,100,84.6,138,133,87.5,20,5.3,6.5,.043,22.75,14.33,80,3.8,75,2.2,5,10,12.93,1.3,16.1,30,1.96,2.85)
audit<-data.frame(taxon=rownames(mammal.data),Package_mass_kg=mammal.data$bodyMass,Table_mass_kg=mass,Package_area_km2=mammal.data$homeRange,Table_area_km2=area)
audit$Mass_agrees<-round(audit$Package_mass_kg,2)==audit$Table_mass_kg
audit$Area_agrees<-round(audit$Package_area_km2,3)==audit$Table_area_km2
write.csv(audit,'evidence/table1-value-audit.csv',row.names=FALSE)
stopifnot(nrow(audit)==49,all(audit$Mass_agrees),all(audit$Area_agrees),setequal(rownames(mammal.data),mammal.tree$tip.label),!anyDuplicated(rownames(mammal.data)),all(is.finite(as.matrix(mammal.data))),all(mammal.data>0),ape::is.ultrametric(mammal.tree),ape::is.rooted(mammal.tree),ape::is.binary(mammal.tree),all(mammal.tree$edge.length>0))
z<-data.frame(taxon=rownames(mammal.data),body_mass_kg=mammal.data$bodyMass,home_range_km2=mammal.data$homeRange)
z$ln_body_mass_kg<-log(z$body_mass_kg);z$ln_home_range_km2<-log(z$home_range_km2)
z<-z[match(mammal.tree$tip.label,z$taxon),]
write.csv(z,'data/mammals-49-traits.csv',row.names=FALSE)
ape::write.tree(mammal.tree,'data/mammals-49-tree.nwk',digits=17)
saveRDS(list(tree=mammal.tree,traits=z),'data/prepared.rds')
for(f in c('app_tasks.R','core_mod_data_base.R','core_mod_signal_signal.R','core_mod_signal_PGLS.R'))source(file.path('..','source',f))
sig<-guane_signal(mammal.tree,z,'taxon','ln_home_range_km2',seed=20261201,nsim=999)
fit<-guane_pgls(mammal.tree,z,'taxon','ln_home_range_km2','ln_body_mass_kg',model='BM',method='REML')
write.csv(sig,'results/signal.csv',row.names=FALSE);write.csv(fit$coefficients,'results/pgls.csv',row.names=FALSE)
saveRDS(list(signal=sig,pgls=fit),'results/fits.rds');capture.output(sessionInfo(),file='results/sessionInfo.txt')
writeLines(c('PASS: all 98 raw values agree with Table 1 at its printed precision (mass 2 decimal places; area 3).','PASS: 49 unique matched taxa; no pruning or imputation.','PASS: kg and km^2 retained; natural logs created once in separate columns.','PASS: GUANE core signal and BM/REML regression completed.','Mammal GUI replay not yet performed.'),'results/checks.txt')
cat('PASS: 98 values, 49 matched taxa, explicit units; GUANE core analyses completed.\n')
