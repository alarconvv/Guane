# Initialize alternate routes through the unobserved forest+open state.
# These are starts, not extra constraints: all 18 ARD parameters remain free.
pkgload::load_all('.',quiet=TRUE)
out<-'validation/2026-11-10'
b<-readRDS('../Guane-manuscript/results/butterfly_unordered_ARD.rds')
o<-readRDS(file.path(out,'butterfly_ordered_guane_refit.rds'))
f<-diversitree::make.mkn(b$tree,setNames(match(b$x,b$states),names(b$x)),k=7,strict=FALSE)
ix<-vapply(diversitree::argnames(f),function(n){ij<-as.integer(strsplit(sub('q','',n),'')[[1]]);b$index[ij[1],ij[2]]},numeric(1))
ll<-function(q)f(c(0,q)[ix+1],root=diversitree::ROOT.GIVEN,root.p=rep(1/7,7))
stopifnot(abs(ll(b$rates)-b$logLik)<1e-6)
neighbors<-c('forest','open','forest+fringe+open');rows<-list();i<-0L
for(incoming in neighbors)for(outgoing in neighbors) {
  i<-i+1L;Q<-b$Q;Q[]<-0;Q[rownames(o$Q),colnames(o$Q)]<-o$Q
  Q['forest+open',neighbors]<-.001;Q[neighbors,'forest+open']<-.001
  Q[incoming,'forest+open']<-.1;Q['forest+open',outgoing]<-10
  p<-vapply(1:18,function(j)Q[which(b$index==j)[1]],numeric(1));p<-pmax(1e-10,p)
  path<-file.path(out,paste0('butterfly_path_',i,'.rds'))
  if(file.exists(path))z<-readRDS(path) else {
    z<-nlminb(p,function(p){v<-tryCatch(-ll(p),error=function(e)1e50);if(is.finite(v))v else 1e50},
      lower=rep(1e-10,18),upper=rep(100,18),control=list(iter.max=2000,eval.max=5000,rel.tol=1e-10))
    z$initial<-p;z$incoming<-incoming;z$outgoing<-outgoing;saveRDS(z,path)
  }
  Q[]<-c(0,z$par)[b$index+1];diag(Q)<-0;diag(Q)<- -rowSums(Q)
  r<-guane_asr_poly(b$tree,b$traits,b$taxon,b$trait,model='ARD',compare=FALSE,
    advanced=list(rate_mode='fixed',fixed_Q=Q))
  stopifnot(abs(r$logLik+z$objective)<1e-5)
  saveRDS(r,sub('.rds$','_checked.rds',path))
  rows[[i]]<-data.frame(Start=i,Incoming=incoming,Outgoing=outgoing,LogLik=r$logLik,
    Convergence=z$convergence,MaxRate=max(z$par),Difference=r$logLik+z$objective,Message=z$message)
  write.csv(do.call(rbind,rows),file.path(out,'butterfly_path_starts.csv'),row.names=FALSE)
  print(rows[[i]]);flush.console()
}
