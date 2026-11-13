# Run from Guane/. Guane fits; additional starts and parameterization checks.
pkgload::load_all('.',quiet=TRUE)
out <- 'validation/2026-11-10'
old <- '../Guane-manuscript/results'
rows <- list()
for(ordered in c(FALSE,TRUE)) {
  tag <- if(ordered)'ordered' else 'unordered'
  b <- readRDS(file.path(old,paste0('butterfly_',tag,'_ARD.rds')))
  for(i in 1:10) {
    path <- file.path(out,paste0('butterfly_',tag,'_',i,'.rds'))
    set.seed(20261110+i)
    # Two direct-rate backend searches, then heterogeneous random starts.
    advanced <- if(i<=2) list(start_mode='backend',optimizer='nlminb') else
      list(start_mode='custom',q_init=if(i<=6) exp(runif(length(b$rates),log(.001),log(1))) else
        pmin(99,pmax(1e-9,b$rates*exp(rnorm(length(b$rates),0,2)))),
        optimizer=if(i%%2)'nlminb' else 'optim',logscale=i%%2==1)
    if(i==2) advanced <- list(start_mode='custom',q_init=.01,optimizer='optim',logscale=FALSE)
    cat(tag,i,format(Sys.time()),'\n');flush.console()
    r <- if(file.exists(path))readRDS(path) else tryCatch(guane_asr_poly(b$tree,b$traits,b$taxon,b$trait,
      model='ARD',compare=FALSE,ordered=ordered,state_order=if(ordered)b$state_order else NULL,
      max_poly=if(ordered)3 else NULL,advanced=advanced),error=function(e)list(error=conditionMessage(e)))
    saveRDS(r,path)
    rows[[length(rows)+1]] <- data.frame(Ordering=tag,Run=i,LogLik=if(is.null(r$logLik))NA_real_ else r$logLik,
      Message=if(is.null(r$error))paste(r$warnings,collapse='; ') else r$error)
    write.csv(do.call(rbind,rows),file.path(out,'butterfly_search.csv'),row.names=FALSE)
    print(tail(rows,1));flush.console()
  }
}
capture.output(sessionInfo(),file=file.path(out,'butterfly_session.txt'))
