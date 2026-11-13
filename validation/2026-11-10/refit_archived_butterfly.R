# Reference-informed replication, not recovery from blind random starts.
# Original fitted objects are from Revell's CC-BY-4.0 manuscript repository.
pkgload::load_all('.',quiet=TRUE)
out<-'validation/2026-11-10'
archive<-new.env();load(file.path(out,'revell_butterfly_fitted_models.rda'),envir=archive)
checks<-list()
for(n in ls(archive)) {
  x<-archive[[n]]
  ordered<-!grepl('unordered',n)
  model<-sub('butterfly[.]','',sub('_(un)?ordered$','',n))
  b<-readRDS(paste0('../Guane-manuscript/results/butterfly_',if(ordered)'ordered' else 'unordered','_',model,'.rds'))
  d<-guane_poly_data(b$tree,b$traits,b$taxon,b$trait,ordered,b$state_order,if(ordered)3 else NULL)
  stopifnot(isTRUE(ape::all.equal.phylo(b$tree,x$tree,use.edge.length=TRUE)),
    isTRUE(all.equal(unname(d$tip_likelihood),unname(x$data[rownames(d$tip_likelihood),colnames(d$tip_likelihood)]))))
  Q<-x$index.matrix;Q[]<-c(0,x$rates)[x$index.matrix+1];diag(Q)<- -rowSums(Q)
  r<-guane_asr_poly(b$tree,b$traits,b$taxon,b$trait,model=model,compare=FALSE,
    ordered=ordered,state_order=if(ordered)b$state_order else NULL,max_poly=if(ordered)3 else NULL,
    advanced=list(rate_mode='fixed',fixed_Q=Q))
  stopifnot(abs(r$logLik-x$logLik)<1e-6)
  checks[[n]]<-data.frame(Model=n,Published=x$logLik,Guane=r$logLik,Difference=r$logLik-x$logLik,MaxRate=max(x$rates))
}
write.csv(do.call(rbind,checks),file.path(out,'published_models_guane_parity.csv'),row.names=FALSE)
b<-readRDS('../Guane-manuscript/results/butterfly_unordered_ARD.rds')
x<-archive$butterfly.ARD_unordered
stopifnot(identical(b$index,x$index.matrix))
rows<-list()
for(upper in c(100,1000,10000)) for(i in 1:2) {
  set.seed(20261110+i)
  start<-x$rates
  if(upper==10000) {
    start<-readRDS(file.path(out,'butterfly_archive_start_bound1000_1.rds'))$rates
    start[start>10]<-10*start[start>10]
  }
  p<-pmin(upper*.999,pmax(1e-10,start*if(i==1)1 else exp(rnorm(18,0,.05))))
  path<-file.path(out,paste0('butterfly_archive_start_bound',upper,'_',i,'.rds'))
  cat(if(file.exists(path))'Reusing completed Guane refit' else 'Starting Guane refit',upper,i,format(Sys.time()),'\n');flush.console()
  r<-if(file.exists(path))readRDS(path) else guane_asr_poly(b$tree,b$traits,b$taxon,b$trait,
    model='ARD',compare=FALSE,max_rate=upper,
    advanced=list(start_mode='custom',q_init=p,optimizer='nlminb',logscale=TRUE))
  saveRDS(r,path)
  stopifnot(max(abs(rowSums(r$probabilities)-1))<1e-8)
  rows[[length(rows)+1]]<-data.frame(Upper=upper,Start=i,LogLik=r$logLik,
    Convergence=r$attempts$Convergence[1],MaxRate=max(r$rates),Message=paste(r$warnings,collapse='; '))
  write.csv(do.call(rbind,rows),file.path(out,'butterfly_archive_start_refits.csv'),row.names=FALSE)
  print(tail(rows,1));flush.console()
}
f<-diversitree::make.mkn(b$tree,setNames(match(b$x,b$states),names(b$x)),k=7,strict=FALSE)
parity<-list()
for(upper in c(100,1000,10000))for(i in 1:2) {
  r<-readRDS(file.path(out,paste0('butterfly_archive_start_bound',upper,'_',i,'.rds')))
  p<-vapply(diversitree::argnames(f),function(n){ij<-as.integer(strsplit(sub('q','',n),'')[[1]]);r$Q[ij[1],ij[2]]},numeric(1))
  independent<-f(p,root=diversitree::ROOT.GIVEN,root.p=rep(1/7,7))
  stopifnot(abs(independent-r$logLik)<1e-5)
  parity[[length(parity)+1]]<-data.frame(Upper=upper,Start=i,Guane=r$logLik,Independent=independent,Difference=independent-r$logLik)
}
write.csv(do.call(rbind,parity),file.path(out,'butterfly_archive_refit_parity.csv'),row.names=FALSE)
r<-readRDS(file.path(out,'butterfly_archive_start_bound10000_1.rds'))
writeLines(guane_asr_poly_script(r,labels=FALSE),file.path(out,'butterfly_unordered_export.R'))
