# Compare retained package data with a separately distributed author-maintained example.
g<-readRDS('data/raw/geospiza-geiger-2.0.12.rds')
b<-read.delim('evidence/provenance-review/BEAST-finches-traits.txt',row.names=1,check.names=FALSE)
a<-do.call(rbind,lapply(rownames(g$dat),function(id){
 hits<-rownames(b)[apply(b,1,function(z)all(abs(z-g$dat[id,])<1e-12))]
 data.frame(Geiger_label=id,BEAST_label=if(length(hits))paste(hits,collapse='; ') else NA,All_five_values_match=length(hits)==1)
}))
stopifnot(nrow(a)==13,all(a$All_five_values_match),a$BEAST_label[a$Geiger_label=='fusca']=='Certhidea olivacea')
write.csv(a,'evidence/provenance-review/cross-distribution-label-audit.csv',row.names=FALSE)
cat('All 65 numeric values agree. A numeric match does not resolve taxon identity, original units, aggregation or transformation.\n')
