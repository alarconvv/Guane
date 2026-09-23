core_mod_asr_poly <- function() list(implemented=TRUE,framework='Maximum likelihood',models=c('ER','SYM','ARD','transient'),stochastic_mapping=TRUE,bayesian=TRUE)

# Intraspecific coexistence is one observed state, never an ambiguous tip likelihood.
guane_poly_data <- function(tree,traits,taxon,trait,ordered=FALSE,state_order=NULL,max_poly=NULL) {
 if(!inherits(tree,'phylo') || !ape::is.rooted(tree) || !ape::is.binary(tree)) stop('Mk reconstruction requires a rooted, bifurcating tree.')
 if(is.null(tree$edge.length) || length(tree$edge.length)!=nrow(tree$edge) || any(!is.finite(tree$edge.length)) || any(tree$edge.length<=0)) stop('Mk reconstruction requires finite, positive branch lengths.')
 if(!is.data.frame(traits) || anyDuplicated(names(traits)) || length(taxon)!=1 || length(trait)!=1 || taxon==trait || !all(c(taxon,trait)%in%names(traits))) stop('Select distinct taxon and discrete trait columns.')
 ids<-as.character(traits[[taxon]])
 if(length(tree$tip.label)<3 || anyNA(tree$tip.label) || any(!nzchar(trimws(tree$tip.label))) || anyDuplicated(tree$tip.label) || anyNA(ids) || any(!nzchar(trimws(ids))) || anyDuplicated(ids) || !setequal(ids,tree$tip.label)) stop('Match unique taxon labels explicitly in Data before reconstruction; at least three taxa are required.')
 traits<-traits[match(tree$tip.label,ids),,drop=FALSE];raw<-as.character(traits[[trait]])
 if(anyNA(raw) || any(!nzchar(raw)) || any(grepl('[&/|;?]',raw)) || any(grepl('(^[+]|[+]$|[+][+])',raw))) stop('Code coexisting states with +, such as A+B. Missing, ambiguous and empty states are not supported.')
 parts<-strsplit(raw,'+',fixed=TRUE)
 if(any(vapply(parts,function(z)anyDuplicated(z)>0 || any(trimws(z)!=z) || any(!nzchar(z)),logical(1)))) stop('Use unique state names without surrounding spaces in each combination.')
 base<-sort(unique(unlist(parts)))
 if(length(base)<2 || length(base)>3 || !any(lengths(parts)>1)) stop('Use two or three constituent states and at least one polymorphic taxon.')
 if(!is.logical(ordered)||length(ordered)!=1||is.na(ordered))stop('Choose ordered or unordered polymorphism.')
 if(ordered) {
  if(!is.character(state_order)||anyNA(state_order)||anyDuplicated(state_order)||!setequal(state_order,base))stop('State order must contain every constituent exactly once.')
  if(length(max_poly)!=1||!is.numeric(max_poly)||!is.finite(max_poly)||max_poly!=floor(max_poly)||max_poly<2||max_poly>length(base))stop('Maximum polymorphism must be an integer from 2 to the number of constituent states.')
  states<-unlist(lapply(seq_along(state_order),function(i)vapply(i:min(length(base),i+max_poly-1),function(j)paste(sort(state_order[i:j]),collapse='+'),character(1))),use.names=FALSE)
 } else {state_order<-NULL;max_poly<-length(base)
 states<-unlist(lapply(seq_along(base),function(k)utils::combn(base,k,FUN=function(z)paste(z,collapse='+'))),use.names=FALSE)
 }
 x<-setNames(vapply(parts,function(z)paste(sort(z),collapse='+'),character(1)),tree$tip.label)
 if(any(!x%in%states))stop('Observed combinations violate the state order or maximum polymorphism. Change the model settings; no taxa are removed.')
 X<-matrix(0,length(x),length(states),dimnames=list(names(x),states));X[cbind(seq_along(x),match(x,states))]<-1
 list(tree=tree,traits=traits,taxon=taxon,trait=trait,x=x,states=states,tip_likelihood=X,polymorphic=TRUE,ordered=ordered,state_order=state_order,max_poly=max_poly,
 coding=data.frame(Taxon=names(x),Original=raw,Canonical=unname(x),check.names=FALSE))
}

# Same unordered, full-combination constraints as phytools::fitpolyMk.
# Only one constituent can be gained or lost; no direct monomorphic substitutions.
guane_poly_matrix <- function(states,model='ER') {
 if(!model%in%c('ER','SYM','ARD','transient'))stop('Unknown polymorphic model.')
 sets<-strsplit(states,'+',fixed=TRUE);m<-matrix(0,length(states),length(states),dimnames=list(states,states));index<-0
 for(i in seq_along(states)) for(j in seq_along(states)) if(j>i) {
  a<-sets[[i]];b<-sets[[j]]
  if(length(intersect(a,b))>0 && length(union(setdiff(a,b),setdiff(b,a)))==1) {
   if(model=='ER') m[i,j]<-m[j,i]<-1
   else if(model=='transient') {m[i,j]<-if(length(a)>length(b))1 else 2;m[j,i]<-3-m[i,j]}
   else {index<-index+1;m[i,j]<-index;if(model=='ARD')index<-index+1;m[j,i]<-index}
  }
 }
 m
}

guane_asr_poly <- function(tree,traits,taxon,trait,model='ER',compare=TRUE,max_rate=100,ordered=FALSE,state_order=NULL,max_poly=NULL,advanced=list()) {
 d<-guane_poly_data(tree,traits,taxon,trait,ordered,state_order,max_poly)
 if(identical(advanced$rate_mode,'fixed') && compare)stop('Turn off model comparison when supplying fixed Q.')
 if(compare && identical(advanced$start_mode,'custom'))stop('Turn off model comparison when supplying custom starting rates.')
 models<-if(compare)unique(c(model,'ER','SYM','ARD','transient')) else model
 matrices<-setNames(lapply(models,function(m)guane_poly_matrix(d$states,m)),models)
 fits<-lapply(matrices,function(m)guane_mk_fit(d,m,max_rate,advanced));selected<-fits[[model]]
 if(is.null(selected$fit))stop(paste(selected$warnings,paste(selected$attempts$Message,collapse='; ')))
 fit<-selected$fit;warnings<-selected$warnings
 rec<-withCallingHandlers(phytools::ancr(fit,type='marginal'),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
 nodes<-as.character(seq_len(tree$Nnode)+length(tree$tip.label));prob<-rec$ace[nodes,d$states,drop=FALSE]
 if(any(!is.finite(prob)) || any(prob< -1e-8) || any(abs(rowSums(prob)-1)>1e-6) || abs(as.numeric(rec$logLik)-fit$logLik)>1e-6)stop('Invalid marginal probabilities or inconsistent reconstruction likelihood.')
 index<-matrices[[model]];Q<-index*0;Q[index>0]<-fit$rates[index[index>0]];diag(Q)<- -rowSums(Q);if(!is.null(selected$options$args$fixedQ))Q<-selected$options$args$fixedQ
 comparison<-do.call(rbind,lapply(models,function(m){f<-fits[[m]];ok<-!is.null(f$fit);ll<-if(ok)f$fit$logLik else NA_real_;p<-if(is.null(f$options$args$fixedQ))max(matrices[[m]]) else 0;data.frame(Model=m,Parameters=p,LogLik=ll,AIC=2*p-2*ll,Status=if(ok)'Converged' else 'Failed',Message=paste(f$warnings,collapse='\n'))}))
 if(identical(advanced$rate_mode,'fixed'))comparison$AIC<-NA_real_
 comparison$Delta_AIC<-comparison$Weight<-NA_real_;valid<-which(is.finite(comparison$AIC))
 if(length(valid)>=2){delta<-comparison$AIC[valid]-min(comparison$AIC[valid]);comparison$Delta_AIC[valid]<-delta;comparison$Weight[valid]<-exp(-delta/2)/sum(exp(-delta/2))}
 attempts<-do.call(rbind,lapply(models,function(m)cbind(Model=m,fits[[m]]$attempts)))
 c(d,list(model=model,index=index,probabilities=prob,Q=Q,rates=fit$rates,logLik=fit$logLik,root_prior=fit$pi,comparison=comparison,attempts=attempts,warnings=unique(warnings),max_rate=max_rate,compare=compare,advanced=advanced,resolved_backend_defaults=lapply(fits,function(f)f$options$backend_defaults),effective_calls=lapply(fits,`[[`,'calls'),package_version=as.character(utils::packageVersion('phytools')),joint=guane_mk_joint(fit,selected$options)))
}

guane_asr_poly_plot <- function(result,type='tree',palette='Guane',labels=TRUE,node_labels=FALSE,label_size=.7,pie_size=.6,lang='en',history=1,appearance=list(),parameter='q1') {
 if(type%in%c('trace','posterior_density','rate_intervals'))return(guane_mk_bayes_plot(result,type,parameter,palette,lang,appearance))
 if(type %in% c('history','frequencies','changes','times','mc','density','transition'))return(guane_asr_map_plot(result,type,palette,labels,node_labels,label_size,pie_size,lang,history,appearance))
 guane_asr_state_plot(result,type,palette,labels,node_labels,label_size,pie_size,lang,appearance)
}

guane_asr_poly_script <- function(result,type='tree',palette='Guane',labels=TRUE,node_labels=FALSE,label_size=.7,pie_size=.6,lang='en',history=1,appearance=list(),parameter='q1') {
 if(!is.null(result$bayes))return(guane_mk_bayes_script(result,type,palette,labels,node_labels,label_size,pie_size,lang,history,appearance,parameter))
 if(!is.null(result$mapping) && type!='density') {
  indices<-result$mapping$map_indices;if(is.null(indices))indices<-seq_along(result$mapping$maps)
  i<-match(history,indices);if(is.na(i))stop('Choose a saved history number within the simulated range.')
  result$mapping$maps<-result$mapping$maps[i];result$mapping$map_indices<-history
 }
 helpers<-c('guane_asr_graphics','guane_asr_colors','guane_asr_gradient','guane_asr_node_table','guane_asr_highlight','guane_asr_legend','guane_asr_density','guane_mk_options','guane_mk_joint','guane_asr_map','guane_asr_map_summary','guane_asr_map_plot','guane_poly_data','guane_poly_matrix','guane_mk_fit','guane_asr_poly','guane_asr_state_plot','guane_asr_poly_plot','guane_mk_bayes_plot','guane_text')
 c('# Guane polymorphic ML: explicit ordering/settings below; saved root weights over allowed combined states.',
 '# A+B means coexistence, not uncertainty. Rates/tree uncertainty is not integrated.',
 '# install.packages(c("ape", "phytools"))',paste0('# R ',getRversion(),'; phytools ',utils::packageVersion('phytools')),
 vapply(helpers,function(n)paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),
 guane_r_assignment('inputs',result[c('tree','traits','taxon','trait','model','compare','max_rate','advanced','ordered','state_order','max_poly')]),
 '# Uncomment to refit: refitted <- do.call(guane_asr_poly, inputs)',
 if(!is.null(result$mapping))paste0('# refitted <- guane_asr_map(refitted, nsim=',result$mapping$nsim,', seed=',result$mapping$seed,')'),
 '# Mapping exports embed one selected history and all summaries. Download RDS for all histories.',
 guane_r_assignment('result',result),guane_r_assignment('plot_settings',list(type=type,palette=palette,labels=labels,node_labels=node_labels,label_size=label_size,pie_size=pie_size,lang=lang,history=history,appearance=appearance)),
 'print(result$comparison)','print(result$coding)','print(result$warnings)',
 guane_asr_script_device(appearance),
 'do.call(guane_asr_poly_plot,c(list(result=result),plot_settings))',guane_asr_script_device(appearance,close=TRUE),'sessionInfo()')
}

# The full allowed combination space remains explicit even when some states have no tips.
guane_asr_poly_bayes <- function(tree,traits,taxon,trait,model='ER',ordered=FALSE,state_order=NULL,max_poly=NULL,nsim=200,burnin=1000,samplefreq=50,chains=2,seed=999,parameters=NULL,root='equal',root_weights=NULL,empirical=FALSE) {
 d<-guane_poly_data(tree,traits,taxon,trait,ordered,state_order,max_poly)
 index<-guane_poly_matrix(d$states,model)
 r<-guane_asr_bayes_rates(d,index,model,nsim,burnin,samplefreq,chains,seed,parameters,root,root_weights,empirical)
 r$inputs<-list(tree=tree,traits=traits,taxon=taxon,trait=trait,model=model,ordered=ordered,state_order=state_order,max_poly=max_poly,nsim=nsim,burnin=burnin,samplefreq=samplefreq,chains=chains,seed=seed,parameters=parameters,root=root,root_weights=root_weights,empirical=empirical)
 r
}
