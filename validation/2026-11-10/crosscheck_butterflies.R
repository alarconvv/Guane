# Independent optimization of Guane's exact Q constraints using diversitree.
# Each candidate optimum is checked in Guane before accepting its likelihood.
pkgload::load_all('.',quiet=TRUE)
out <- 'validation/2026-11-10'
rows <- list()
for(ordered in c(FALSE,TRUE)) {
  tag <- if(ordered)'ordered' else 'unordered'
  b <- readRDS(paste0('../Guane-manuscript/results/butterfly_',tag,'_ARD.rds'))
  k <- length(b$states)
  x <- setNames(match(b$x,b$states),names(b$x))
  f <- diversitree::make.mkn(b$tree,x,k=k,strict=FALSE)
  ix <- vapply(diversitree::argnames(f),function(n) {
    ij<-as.integer(strsplit(sub('q','',n),'')[[1]]);b$index[ij[1],ij[2]]
  },numeric(1))
  ll <- function(q) f(c(0,q)[ix+1],root=diversitree::ROOT.GIVEN,root.p=rep(1/k,k))
  stopifnot(abs(ll(b$rates)-b$logLik)<1e-6)
  for(i in 1:10) {
    set.seed(20261110+i)
    p <- switch(as.character(i),'1'=pmin(99,pmax(1e-9,b$rates)),
      '2'=rep(.01,length(b$rates)),'3'=rep(.1,length(b$rates)),
      exp(runif(length(b$rates),log(.001),log(1))))
    logscale <- i%%2==1
    path <- file.path(out,paste0('butterfly_independent_',tag,'_',i,'.rds'))
    cat('Starting',tag,i,format(Sys.time()),'\n');flush.console()
    if(file.exists(path)) z<-readRDS(path) else {
      objective <- function(p) {v<-tryCatch(-ll(if(logscale)exp(p) else p),error=function(e)1e50);if(is.finite(v))v else 1e50}
      z <- nlminb(if(logscale)log(p) else p,objective,
        lower=rep(if(logscale)log(1e-10) else 1e-10,length(p)),
        upper=rep(if(logscale)log(100) else 100,length(p)),
        control=list(iter.max=2000,eval.max=5000,rel.tol=1e-10))
      z$rates <- if(logscale)exp(z$par) else z$par
      z$logscale <- logscale;z$initial <- p;z$seed <- 20261110+i
      saveRDS(z,path)
    }
    Q<-b$Q;Q[]<-c(0,z$rates)[b$index+1];diag(Q)<-0;diag(Q)<- -rowSums(Q)
    r <- guane_asr_poly(b$tree,b$traits,b$taxon,b$trait,model='ARD',compare=FALSE,
      ordered=ordered,state_order=if(ordered)b$state_order else NULL,max_poly=if(ordered)3 else NULL,
      advanced=list(rate_mode='fixed',fixed_Q=Q))
    stopifnot(abs(r$logLik+z$objective)<1e-5,max(abs(rowSums(r$probabilities)-1))<1e-8)
    saveRDS(r,file.path(out,paste0('butterfly_checked_',tag,'_',i,'.rds')))
    rows[[length(rows)+1]]<-data.frame(Ordering=tag,Run=i,LogScale=logscale,
      LogLik=r$logLik,Convergence=z$convergence,Iterations=z$iterations,
      Difference=r$logLik+z$objective,Boundary=any(z$rates<=1e-9|z$rates>=99),Message=z$message)
    write.csv(do.call(rbind,rows),file.path(out,'butterfly_independent_search.csv'),row.names=FALSE)
    print(tail(rows,1));flush.console()
  }
}
