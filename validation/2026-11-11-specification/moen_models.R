# Run/source from Guane/. Builds specifications only; no empirical fitting.
# Moen S4: https://doi.org/10.5281/zenodo.4708174 (GPL-3.0-or-later).
# Historical hisse source is retained for verification, not installed.
pkgload::load_all('.',quiet=TRUE)
out <- 'validation/2026-11-11-specification'
legacy <- new.env(parent=baseenv())
for(f in c('historical_transMat.R','historical_transMatfHiSSE.R')) {
  expressions <- parse(file.path(out,f))
  stopifnot(all(vapply(expressions,function(x)is.call(x) &&
    as.character(x[[1]])%in%c('<-','=') && is.call(x[[3]]) &&
    identical(x[[3]][[1]],as.name('function')),logical(1))))
  for(x in expressions) eval(x,legacy)
}
# Evaluate only the reviewed model-construction assignments in S4.
# Excludes library/source calls, data imports, fitting, plotting and file writes.
s4 <- parse('../Guane-manuscript/data/Moen_S4_original.R')
lhs <- vapply(s4,function(x)if(is.call(x) && identical(x[[1]],as.name('<-')))
  paste(deparse(x[[2]]),collapse='') else '',character(1))
first <- which(lhs=='trans_rates');last <- which(lhs=='models$CID4')
stopifnot(length(first)==1,length(last)==1,first<last)
construction <- s4[first:last]
stopifnot(all(vapply(construction,function(x)is.call(x) &&
  as.character(x[[1]])%in%c('<-','rm'),logical(1))))
for(x in construction) eval(x,legacy)
selected <- c('full2','full3','suicide4','suicide6','CID2','CID4')
historical <- legacy$models[selected]
zero_na <- function(x){x[is.na(x)]<-0;x}
expected4 <- matrix(c(0,3,5,0, 1,0,0,7, 2,0,0,8, 0,4,6,0),4,byrow=TRUE)
expected8 <- matrix(c(
  0,2,3,0,4,0,5,0, 1,0,0,3,0,4,0,5,
  3,0,0,2,6,0,7,0, 0,3,1,0,0,6,0,7,
  4,0,6,0,0,2,8,0, 0,4,0,6,1,0,0,8,
  5,0,7,0,8,0,0,2, 0,5,0,7,0,8,1,0),8,byrow=TRUE)
stopifnot(identical(unname(zero_na(historical$full2[[3]])),expected4),
  identical(unname(zero_na(historical$CID4[[3]])),expected8))
csv_text <- function(x)paste(apply(zero_na(x),1,paste,collapse=','),collapse='\n')
moen_settings <- lapply(historical,function(m)list(models='Custom',
  custom_classes=length(m[[1]])/2,eps_mode='By diversification class',
  turnover_text=paste(m[[1]],collapse=','),eps_text=paste(m[[2]],collapse=','),
  transition_text=csv_text(m[[3]])))
moen_specs <- lapply(moen_settings,function(a)do.call(guane_hidden_spec,
  c(list(model=a$models),a[setdiff(names(a),'models')])))
make_Q <- function(index,rates){
  Q<-index;Q[]<-c(0,rates)[zero_na(index)+1];diag(Q)<-0;diag(Q)<- -rowSums(Q);Q
}
for(n in selected) {
  a<-historical[[n]];b<-moen_specs[[n]]
  stopifnot(identical(as.numeric(a[[1]]),b$turnover),identical(as.numeric(a[[2]]),b$eps),
    identical(zero_na(a[[3]]),zero_na(b$trans)))
  for(rates in list(seq_len(8)/100,rev(seq_len(8))/10,exp(seq(-7,0,length.out=8))))
    stopifnot(identical(make_Q(a[[3]],rates),make_Q(b$trans,rates)))
  writeLines(moen_settings[[n]]$transition_text,file.path(out,paste0(n,'_transitions.csv')))
}
counts <- data.frame(Model=selected,HiddenClasses=vapply(moen_specs,`[[`,numeric(1),'classes'),
  Turnover=vapply(moen_specs,function(s)max(s$turnover),numeric(1)),
  Extinction=vapply(moen_specs,function(s)max(s$eps),numeric(1)),
  Transitions=vapply(moen_specs,function(s)max(s$trans,na.rm=TRUE),numeric(1)))
counts$Total<-rowSums(counts[c('Turnover','Extinction','Transitions')])
stopifnot(identical(counts$Total,c(16,14,14,13,12,16)))
saveRDS(moen_settings,file.path(out,'moen_custom_settings.rds'))
saveRDS(moen_specs,file.path(out,'moen_exact_specs.rds'))
write.csv(counts,file.path(out,'model_parameter_counts.csv'),row.names=FALSE)
write.csv(data.frame(Model=selected,
  Turnover=vapply(moen_settings,`[[`,character(1),'turnover_text'),
  Extinction=vapply(moen_settings,`[[`,character(1),'eps_text')),
  file.path(out,'custom_vectors.csv'),row.names=FALSE)

# Explicit empirical entry point. Requires a chosen evaluation budget.
# Uses Moen's bounded protocol, not a claimed reproduction of his search history.
fit_moen_model <- function(model,tree,traits,maxeval,starts=2,seed=20261111,
  sann=FALSE,sann_its=10000,turnover_start=.05,eps_start=.5,transition_start=.01) {
  stopifnot(length(model)==1,model%in%names(moen_settings))
  result<-do.call(guane_hidden_fit,c(list(tree=tree,traits=traits,taxon='species',
    trait='states',state0='0',sampling=c(.4994893,.6666667),survival=TRUE,
    root_type='madfitz',root_mode='Likelihood',starts=starts,seed=seed,
    sann=sann,sann_its=sann_its,tolerance=sqrt(.Machine$double.eps),
    turnover_start=turnover_start,eps_start=eps_start,transition_start=transition_start,
    turnover_upper=10,eps_upper=10,transition_upper=100,ode_eps=0,
    verify=TRUE,maxeval=maxeval),moen_settings[[model]]))
  result$moen_model<-model
  result$specification_source<-'Moen S4, hisse 1.9.8 constructors; fitted using current Guane/hisse backend'
  result
}
print(counts)
cat('All six specifications, state directions, equality groups and Q-matrix checks passed. No empirical fits run.\n')
