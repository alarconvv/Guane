# From submission-mammals. Installs nothing; uses the declared example version.
stopifnot(as.character(packageVersion('phytools'))=='2.5.2')
data(mammal.data,package='phytools');data(mammal.tree,package='phytools')
audit<-read.csv('evidence/table1-value-audit.csv',check.names=FALSE)
stopifnot(identical(audit$taxon,rownames(mammal.data)),all(round(mammal.data$bodyMass,2)==audit$Table_mass_kg),all(round(mammal.data$homeRange,3)==audit$Table_area_km2))
z<-data.frame(taxon=rownames(mammal.data),body_mass_kg=mammal.data$bodyMass,home_range_km2=mammal.data$homeRange)
z$ln_body_mass_kg<-log(z$body_mass_kg);z$ln_home_range_km2<-log(z$home_range_km2)
z<-z[match(mammal.tree$tip.label,z$taxon),]
stopifnot(nrow(z)==49,identical(z$taxon,mammal.tree$tip.label),all(is.finite(as.matrix(z[-1]))),!anyDuplicated(z$taxon),ape::is.ultrametric(mammal.tree),ape::is.binary(mammal.tree),all(mammal.tree$edge.length>0))
write.csv(z,'data/mammals-49-traits.csv',row.names=FALSE);ape::write.tree(mammal.tree,'data/mammals-49-tree.nwk',digits=17)
saveRDS(list(tree=mammal.tree,traits=z),'data/prepared.rds')
capture.output(packageDescription('phytools'),file='evidence/phytools-DESCRIPTION.txt')
cat('PASS: published precision, declared units, one explicit natural-log transform, 49 matching taxa.\n')
