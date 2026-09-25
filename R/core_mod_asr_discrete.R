# Rows are source states, columns destination states. Zero forbids a transition.
guane_mk_matrix <- function(states,model='ER',custom=NULL) {
 k<-length(states);m<-matrix(0,k,k,dimnames=list(states,states))
 if(k<2 || k>10) stop('Select a discrete trait with 2 to 10 observed states.')
 if(model=='ER') m[row(m)!=col(m)]<-1
 else if(model=='SYM') {m[lower.tri(m)]<-seq_len(k*(k-1)/2);m<-m+t(m)}
 else if(model=='ARD') m[row(m)!=col(m)]<-seq_len(k*(k-1))
 else if(model=='Custom') {
  if(is.character(custom) && length(custom)==1) {
   lines<-strsplit(trimws(custom),'\n',fixed=TRUE)[[1]]
   rows<-lapply(lines,function(s)strsplit(trimws(s),'[,[:space:]]+')[[1]])
   if(length(rows)!=k || any(lengths(rows)!=k)) stop('Custom matrix must have one row and column per state, without headers.')
   m<-matrix(suppressWarnings(as.numeric(unlist(rows))),k,k,byrow=TRUE)
  } else m<-custom
  if(!is.matrix(m) || !is.numeric(m) || !identical(dim(m),c(k,k)) || any(!is.finite(m)) || any(m<0) || any(m!=floor(m)) || any(diag(m)!=0)) stop('Custom matrix requires nonnegative integer indices and a zero diagonal.')
  if(!is.null(rownames(m)) && !identical(rownames(m),states) || !is.null(colnames(m)) && !identical(colnames(m),states)) stop('Custom matrix names must match the displayed state order.')
  groups<-sort(unique(as.numeric(m[m>0])))
  if(!length(groups) || !identical(groups,as.numeric(seq_len(length(groups))))) stop('Positive rate indices must be consecutive: 1, 2, 3, and so on.')
  dimnames(m)<-list(states,states)
 } else stop('Unknown Mk model.')
 reach<-m>0;diag(reach)<-TRUE
 for(i in seq_len(k)) reach<-reach | outer(reach[,i],reach[i,],'&')
 if(!any(rowSums(reach)==k)) stop('No ancestral state can reach all observed states under this custom model.')
 m
}

guane_mk_data <- function(tree,traits,taxon,trait) {
 if(!inherits(tree,'phylo') || !ape::is.rooted(tree) || !ape::is.binary(tree)) stop('Mk reconstruction requires a rooted, bifurcating tree.')
 if(is.null(tree$edge.length) || length(tree$edge.length)!=nrow(tree$edge) || any(!is.finite(tree$edge.length)) || any(tree$edge.length<=0)) stop('Mk reconstruction requires finite, positive branch lengths.')
 if(!is.data.frame(traits) || anyDuplicated(names(traits)) || length(taxon)!=1 || length(trait)!=1 || taxon==trait || !all(c(taxon,trait)%in%names(traits))) stop('Select distinct taxon and discrete trait columns.')
 ids<-as.character(traits[[taxon]])
 if(length(tree$tip.label)<3 || anyNA(tree$tip.label) || any(!nzchar(trimws(tree$tip.label))) || anyDuplicated(tree$tip.label) || anyNA(ids) || any(!nzchar(trimws(ids))) || anyDuplicated(ids) || !setequal(ids,tree$tip.label)) stop('Match unique taxon labels explicitly in Data before reconstruction; at least three taxa are required.')
 traits<-traits[match(tree$tip.label,ids),,drop=FALSE];v<-traits[[trait]]
 if(is.numeric(v) && any(!is.finite(v) | v!=floor(v))) stop('Numeric discrete states must be finite integers; continuous values are not binned.')
 x<-setNames(as.character(v),tree$tip.label)
 if(anyNA(x) || any(!nzchar(trimws(x))) || any(grepl('[+&/|;?]',x))) stop('Use one unambiguous state per taxon. Missing and polymorphic states are not supported here.')
 states<-sort(unique(unname(x)),method='radix')
 if(length(states)<2 || length(states)>10) stop('Select a discrete trait with 2 to 10 observed states.')
 list(tree=tree,traits=traits,taxon=taxon,trait=trait,x=x,states=states)
}


guane_asr_mk <- function(tree,traits,taxon,trait,model='ER',custom=NULL,compare=TRUE,max_rate=100,advanced=list()) {
 d<-guane_mk_data(tree,traits,taxon,trait)
 index<-guane_mk_matrix(d$states,model,custom)
 if(identical(advanced$rate_mode,'fixed') && compare)stop('Turn off model comparison when supplying fixed Q.')
 if(compare && identical(advanced$start_mode,'custom'))stop('Turn off model comparison when supplying custom starting rates.')
 models<-if(compare) unique(c(model,'ER','SYM','ARD')) else model
 matrices<-lapply(models,function(m)guane_mk_matrix(d$states,m,custom));names(matrices)<-models
 # Equivalent constraints (including binary ER/SYM) must not duplicate AIC weight.
 keys<-vapply(matrices,function(m)paste(match(as.vector(m),unique(as.vector(m))),collapse=','),character(1))
 aliases<-models[duplicated(keys)];matrices<-matrices[!duplicated(keys)]
 fits<-lapply(matrices,function(m)guane_mk_fit(d,m,max_rate,advanced))
 selected<-fits[[model]]
 if(is.null(selected$fit)) stop(paste(selected$warnings,paste(selected$attempts$Message,collapse='; ')))
 fit<-selected$fit
 warnings<-selected$warnings
 reconstruction<-withCallingHandlers(phytools::ancr(fit,type='marginal'),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
 nodes<-as.character(seq_len(tree$Nnode)+length(tree$tip.label))
 prob<-reconstruction$ace[nodes,d$states,drop=FALSE]
 if(any(!is.finite(prob)) || any(prob< -1e-8) || any(abs(rowSums(prob)-1)>1e-6) || !isTRUE(all.equal(as.numeric(reconstruction$logLik),fit$logLik,tolerance=1e-7))) stop('Invalid marginal probabilities or inconsistent reconstruction likelihood.')
 Q<-matrix(0,length(d$states),length(d$states),dimnames=list(d$states,d$states));Q[index>0]<-fit$rates[index[index>0]];diag(Q)<- -rowSums(Q);if(!is.null(selected$options$args$fixedQ))Q<-selected$options$args$fixedQ
 comparison<-do.call(rbind,lapply(names(fits),function(m){f<-fits[[m]];ok<-!is.null(f$fit);ll<-if(ok) f$fit$logLik else NA_real_;p<-if(is.null(f$options$args$fixedQ))max(matrices[[m]]) else 0;data.frame(Model=m,Parameters=p,LogLik=ll,AIC=if(ok) 2*p-2*ll else NA_real_,Status=if(ok)'Converged' else 'Failed',Message=paste(f$warnings,collapse='\n'))}))
 if(identical(advanced$rate_mode,'fixed'))comparison$AIC<-NA_real_
 comparison$Delta_AIC<-NA_real_;comparison$Weight<-NA_real_;valid<-which(is.finite(comparison$AIC))
 if(length(valid)>=2) {delta<-comparison$AIC[valid]-min(comparison$AIC[valid]);comparison$Delta_AIC[valid]<-delta;comparison$Weight[valid]<-exp(-delta/2)/sum(exp(-delta/2))}
 attempts<-do.call(rbind,lapply(names(fits),function(m)cbind(Model=m,fits[[m]]$attempts)))
 comparison$Equivalent<-vapply(names(matrices),function(m)paste(models[keys==keys[match(m,models)] & models!=m],collapse=', '),character(1))
 if(length(aliases)) warnings<-c(warnings,'Equivalent models share one comparison entry.')
 c(d,list(model=model,index=index,probabilities=prob,Q=Q,rates=fit$rates,logLik=fit$logLik,root_prior=fit$pi,comparison=comparison,attempts=attempts,warnings=unique(warnings),max_rate=max_rate,compare=compare,advanced=advanced,resolved_backend_defaults=lapply(fits,function(f)f$options$backend_defaults),effective_calls=lapply(fits,`[[`,'calls'),package_version=as.character(utils::packageVersion('phytools')),joint=guane_mk_joint(fit,selected$options)))
}

guane_asr_mk_plot <- function(result,type='tree',palette='Guane',labels=TRUE,node_labels=FALSE,label_size=.7,pie_size=.6,lang='en',history=1,appearance=list(),parameter='q1') {
 if(type%in%c('trace','posterior_density','rate_intervals'))return(guane_mk_bayes_plot(result,type,parameter,palette,lang,appearance))
 if(type %in% c('history','frequencies','changes','times','mc','density','transition'))return(guane_asr_map_plot(result,type,palette,labels,node_labels,label_size,pie_size,lang,history,appearance))
 guane_asr_state_plot(result,type,palette,labels,node_labels,label_size,pie_size,lang,appearance)
}

guane_asr_mk_script <- function(result,type='tree',palette='Guane',labels=TRUE,node_labels=FALSE,label_size=.7,pie_size=.6,lang='en',history=1,appearance=list(),parameter='q1') {
 if(!is.null(result$bayes))return(guane_mk_bayes_script(result,type,palette,labels,node_labels,label_size,pie_size,lang,history,appearance,parameter))
 # Include the displayed history and all numerical summaries; the separate RDS retains every map.
 if(!is.null(result$mapping) && type!='density') {
  indices<-result$mapping$map_indices;if(is.null(indices))indices<-seq_along(result$mapping$maps)
  i<-match(history,indices);if(is.na(i))stop('Choose a saved history number within the simulated range.')
  result$mapping$maps<-result$mapping$maps[i];result$mapping$map_indices<-history
 }
 helpers<-c('guane_asr_graphics','guane_asr_colors','guane_asr_gradient','guane_asr_node_table','guane_asr_highlight','guane_asr_legend','guane_asr_density','guane_mk_options','guane_mk_joint','guane_asr_state_plot','guane_mk_matrix','guane_mk_data','guane_mk_fit','guane_asr_mk','guane_asr_mk_plot','guane_asr_map','guane_asr_map_summary','guane_asr_map_plot','guane_mk_bayes_plot','guane_text')
 c('# Guane discrete Mk ML reconstruction. Saved root weights and analytical settings; global marginals and optional joint assignments.',
 '# install.packages(c("ape", "phytools"))',
 paste0('# R ',getRversion(),'; phytools ',utils::packageVersion('phytools')),
 vapply(helpers,function(n)paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),
 guane_r_assignment('inputs',c(result[c('tree','traits','taxon','trait','model','compare','max_rate','advanced')],list(custom=result$index))),
 '# Uncomment to refit the model from the embedded inputs:', '# refitted <- do.call(guane_asr_mk, inputs)',
 if(!is.null(result$mapping))paste0('# refitted <- guane_asr_map(refitted, nsim=',result$mapping$nsim,', seed=',result$mapping$seed,')'),
 '# Saved numerical results reproduce the exact displayed graph without optimization drift.',
 '# Mapping scripts embed the selected history plus all summaries. Rerun the mapping recipe for other histories, or use the full RDS download.',guane_r_assignment('result',result),
 guane_r_assignment('plot_settings',list(type=type,palette=palette,labels=labels,node_labels=node_labels,label_size=label_size,pie_size=pie_size,lang=lang,history=history,appearance=appearance)),
 'print(result$comparison)','print(result$probabilities)','print(result$Q)','print(result$attempts)','print(result$warnings)',
 guane_asr_script_device(appearance),
 'do.call(guane_asr_mk_plot, c(list(result=result), plot_settings))',
 '# Optional: pdf("guane-mk.pdf",width=10,height=8); do.call(guane_asr_mk_plot,c(list(result=result),plot_settings)); dev.off()', guane_asr_script_device(appearance,close=TRUE),'sessionInfo()')
}

guane_asr_mk_bayes <- function(tree,traits,taxon,trait,model='ER',custom=NULL,nsim=200,burnin=1000,samplefreq=50,chains=2,seed=999,parameters=NULL,root='equal',root_weights=NULL,empirical=FALSE) {
 d<-guane_mk_data(tree,traits,taxon,trait);index<-guane_mk_matrix(d$states,model,custom)
 r<-guane_asr_bayes_rates(d,index,model,nsim,burnin,samplefreq,chains,seed,parameters,root,root_weights,empirical)
 r$inputs<-list(tree=tree,traits=traits,taxon=taxon,trait=trait,model=model,custom=index,nsim=nsim,burnin=burnin,samplefreq=samplefreq,chains=chains,seed=seed,parameters=parameters,root=root,root_weights=root_weights,empirical=empirical)
 r
}
