# Same independent Mk objective; compare finite upper bounds and diverse starts.
pkgload::load_all('.',quiet=TRUE)
out <- 'validation/2026-11-10'
b <- readRDS('../Guane-manuscript/results/butterfly_unordered_ARD.rds')
f <- diversitree::make.mkn(b$tree,setNames(match(b$x,b$states),names(b$x)),k=7,strict=FALSE)
ix <- vapply(diversitree::argnames(f),function(n){ij<-as.integer(strsplit(sub('q','',n),'')[[1]]);b$index[ij[1],ij[2]]},numeric(1))
ll<-function(q)f(c(0,q)[ix+1],root=diversitree::ROOT.GIVEN,root.p=rep(1/7,7))
stopifnot(abs(ll(b$rates)-b$logLik)<1e-6)
rows <- list()
for(upper in c(100,1000,10000)) for(i in 1:12) {
  set.seed(20261120+i)
  p <- if(i==1)pmin(upper*.99,pmax(1e-10,b$rates)) else
    if(i<=6) rep(.01,18)*rexp(18) else exp(runif(18,log(.0001),log(10)))
  path<-file.path(out,paste0('butterfly_bound',upper,'_start',i,'.rds'))
  if(file.exists(path)) z<-readRDS(path) else {
    z<-nlminb(p,function(p){v<-tryCatch(-ll(p),error=function(e)1e50);if(is.finite(v))v else 1e50},
      lower=rep(1e-10,18),upper=rep(upper,18),control=list(iter.max=2000,eval.max=5000,rel.tol=1e-10))
    z$initial<-p;z$upper<-upper;z$seed<-20261120+i;saveRDS(z,path)
  }
  Q<-b$Q;Q[]<-c(0,z$par)[b$index+1];diag(Q)<-0;diag(Q)<- -rowSums(Q)
  r<-guane_asr_poly(b$tree,b$traits,b$taxon,b$trait,model='ARD',compare=FALSE,
    advanced=list(rate_mode='fixed',fixed_Q=Q))
  stopifnot(abs(r$logLik+z$objective)<1e-5)
  saveRDS(r,sub('.rds$','_checked.rds',path))
  rows[[length(rows)+1]]<-data.frame(Upper=upper,Start=i,LogLik=r$logLik,
    Convergence=z$convergence,Iterations=z$iterations,MaxRate=max(z$par),
    Difference=r$logLik+z$objective,Message=z$message)
  write.csv(do.call(rbind,rows),file.path(out,'butterfly_bound_sensitivity.csv'),row.names=FALSE)
  print(tail(rows,1));flush.console()
}
