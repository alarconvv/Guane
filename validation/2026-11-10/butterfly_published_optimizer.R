# Match the log-rate L-BFGS-B settings used by fitMk.parallel, without workers.
# Independent diversitree likelihood is checked against Guane after each fit.
pkgload::load_all('.',quiet=TRUE)
out<-'validation/2026-11-10'
b<-readRDS('../Guane-manuscript/results/butterfly_unordered_ARD.rds')
f<-diversitree::make.mkn(b$tree,setNames(match(b$x,b$states),names(b$x)),k=7,strict=FALSE)
ix<-vapply(diversitree::argnames(f),function(n){ij<-as.integer(strsplit(sub('q','',n),'')[[1]]);b$index[ij[1],ij[2]]},numeric(1))
ll<-function(q)f(c(0,q)[ix+1],root=diversitree::ROOT.GIVEN,root.p=rep(1/7,7))
stopifnot(abs(ll(b$rates)-b$logLik)<1e-6)
upper<-max(ape::node.depth.edgelength(b$tree))*100
rows<-list()
for(i in 1:20) {
  set.seed(20261200+i)
  p<-7/sum(b$tree$edge.length)*rexp(18)
  path<-file.path(out,paste0('butterfly_LBFGSB_',i,'.rds'))
  if(file.exists(path))z<-readRDS(path) else {
    z<-optim(log(p),function(p){v<-tryCatch(-ll(exp(p)),error=function(e)1e50);if(is.finite(v))v else 1e50},
      method='L-BFGS-B',lower=rep(log(1e-12),18),upper=rep(log(upper),18),
      control=list(maxit=2000))
    z$rates<-exp(z$par);z$initial<-p;z$seed<-20261200+i;z$upper<-upper;saveRDS(z,path)
  }
  Q<-b$Q;Q[]<-c(0,z$rates)[b$index+1];diag(Q)<-0;diag(Q)<- -rowSums(Q)
  r<-guane_asr_poly(b$tree,b$traits,b$taxon,b$trait,model='ARD',compare=FALSE,
    advanced=list(rate_mode='fixed',fixed_Q=Q))
  stopifnot(abs(r$logLik+z$value)<1e-5)
  saveRDS(r,sub('.rds$','_checked.rds',path))
  rows[[i]]<-data.frame(Start=i,LogLik=r$logLik,Convergence=z$convergence,
    MaxRate=max(z$rates),Difference=r$logLik+z$value,Message=z$message)
  write.csv(do.call(rbind,rows),file.path(out,'butterfly_LBFGSB.csv'),row.names=FALSE)
  print(rows[[i]]);flush.console()
}
