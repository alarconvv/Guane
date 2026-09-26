# Shared Mk optimizer and saved-state displays for discrete and polymorphic cards.
# Deterministic starts; retain optimizer failures instead of silently treating them as fits.
# Validate analytical options independently of Shiny. Text inputs are data, never R expressions.
guane_mk_options <- function(d,index,max_rate=100,advanced=list()) {
 defaults<-list(root='equal',root_weights=NULL,rate_mode='estimate',fixed_Q=NULL,
  start_mode='deterministic',q_init=NULL,min_rate=1e-10,optimizer='nlminb',logscale=TRUE,
  reconstruction='marginal',joint_tol=1e-12)
 if(!is.list(advanced)||is.null(names(advanced))&&length(advanced)||anyDuplicated(names(advanced))||any(!names(advanced)%in%names(defaults)))stop('Unknown advanced Mk setting.')
 a<-utils::modifyList(defaults,advanced,keep.null=TRUE)
 if(any(!vapply(a[c('root','rate_mode','start_mode','optimizer','reconstruction')],function(v)is.character(v)&&length(v)==1&&!is.na(v),logical(1))))stop('Invalid advanced Mk choice.')
 if(!a$root%in%c('equal','custom')||!a$rate_mode%in%c('estimate','fixed')||!a$start_mode%in%c('deterministic','backend','custom')||!a$optimizer%in%c('nlminb','optim')||!a$reconstruction%in%c('marginal','joint'))stop('Invalid advanced Mk choice.')
 pi<-'equal'
 if(a$root=='custom') {
  w<-a$root_weights
  if(is.character(w)&&length(w)==1) {
   z<-tryCatch(utils::read.csv(text=w,header=FALSE,colClasses='character',strip.white=TRUE),error=function(e)NULL)
   if(is.null(z)||ncol(z)!=2)stop('Root weights require one state,weight row per allowed state, without a header.')
   w<-setNames(suppressWarnings(as.numeric(z[[2]])),z[[1]])
  }
  if(!is.numeric(w)||is.null(names(w))||anyDuplicated(names(w))||!setequal(names(w),d$states)||any(!is.finite(w))||any(w<0)||sum(w)<=0)stop('Root weights must name every allowed state once, be finite and nonnegative, and have a positive sum.')
  pi<-w[d$states]/sum(w)
 }
 fixed<-NULL
 if(a$rate_mode=='fixed') {
  fixed<-a$fixed_Q
  if(is.character(fixed)&&length(fixed)==1)fixed<-tryCatch(as.matrix(utils::read.csv(text=fixed,row.names=1,check.names=FALSE)),error=function(e)NULL)
  if(!is.matrix(fixed)||!is.numeric(fixed)||!identical(dim(fixed),dim(index))||!setequal(rownames(fixed),d$states)||!setequal(colnames(fixed),d$states)||anyDuplicated(rownames(fixed))||anyDuplicated(colnames(fixed)))stop('Fixed Q requires a named numeric square CSV matrix with all allowed states as row and column headers.')
  fixed<-fixed[d$states,d$states,drop=FALSE]
  if(any(!is.finite(fixed))||any(fixed[row(fixed)!=col(fixed)]<0)||any(abs(rowSums(fixed))>1e-10*pmax(1,-diag(fixed)))||any(fixed[index==0 & row(index)!=col(index)]!=0))stop('Fixed Q must have nonnegative off-diagonal rates, negative row-sum diagonals and preserve forbidden transitions.')
  if(any(vapply(seq_len(max(index)),function(i)diff(range(fixed[index==i]))>1e-10,logical(1))))stop('Fixed Q must preserve the selected model rate-sharing constraints.')
 }
 if(length(a$joint_tol)!=1||!is.numeric(a$joint_tol)||!is.finite(a$joint_tol)||a$joint_tol<=0)stop('Joint tolerance must be finite and positive.')
 lower<-a$min_rate;upper<-max_rate
 backend<-a$start_mode=='backend'
 if(backend){lower<-1e-12;upper<-max(phytools::nodeHeights(d$tree))*100}
 if(a$rate_mode=='estimate' && (length(lower)!=1||length(upper)!=1||!is.finite(lower)||!is.finite(upper)||lower<=0||upper<=max(1e-8,lower)||!is.logical(a$logscale)||length(a$logscale)!=1||is.na(a$logscale)))stop('Rate bounds must be positive and finite, with the upper bound greater than the lower bound and 1e-8.')
 starts<-list(NULL)
 if(!backend && a$rate_mode=='estimate') {
  if(a$start_mode=='custom') {
   q<-a$q_init
   if(is.character(q))q<-suppressWarnings(as.numeric(strsplit(trimws(q),'[,[:space:]]+')[[1]]))
   if(!is.numeric(q)||!length(q)||!length(q)%in%c(1,max(index))||any(!is.finite(q))||any(q<lower|q>upper))stop('Starting rates must be one number or one per rate index, within the bounds.')
   starts<-list(q)
  } else starts<-as.list(pmax(lower,pmin(upper*.9,pmax(lower*10,length(d$states)/sum(d$tree$edge.length)*c(.1,1,10)))))
 }
 args<-list(model=index,pi=pi,lik.func='pruning')
 if(!is.null(fixed))args$fixedQ<-fixed
 else if(!backend)args<-c(args,list(min.q=lower,max.q=upper,logscale=a$logscale,opt.method=a$optimizer))
 raw_x<-if(is.null(d$tip_likelihood))setNames(factor(d$x,levels=d$states),names(d$x)) else d$tip_likelihood
 resolved<-if(backend && is.null(fixed))list(q.init=length(unique(raw_x))/sum(d$tree$edge.length),min.q=lower,max.q=upper,logscale=FALSE,opt.method='nlminb') else NULL
 list(requested=a,args=args,starts=starts,lower=lower,upper=upper,backend_defaults=resolved)
}

guane_mk_fit <- function(d,index,max_rate=100,advanced=list()) {
 o<-guane_mk_options(d,index,max_rate,advanced);lower<-o$lower;max_rate<-o$upper
 fits<-vector('list',length(o$starts));attempts<-vector('list',length(o$starts));calls<-vector('list',length(o$starts))
 for(i in seq_along(o$starts)) {
  warnings<-character();args<-o$args
  if(!is.null(o$starts[[i]]))args$q.init<-o$starts[[i]]
  calls[[i]]<-args
  fit<-tryCatch(withCallingHandlers(do.call(phytools::fitMk,c(list(tree=d$tree,x=if(is.null(d$tip_likelihood))setNames(factor(d$x,levels=d$states),names(d$x)) else d$tip_likelihood),args)),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')}),error=identity)
  fixed<-!is.null(args$fixedQ)
  ok<-!inherits(fit,'error') && (fixed||identical(fit$opt_results$convergence,0L)) && is.finite(fit$logLik) && all(is.finite(fit$rates)) && all(fit$rates>=0)
  if(ok)fits[[i]]<-fit
  attempts[[i]]<-data.frame(Start=i,Initial=if(is.null(o$starts[[i]]))NA_real_ else o$starts[[i]][1],Convergence=if(inherits(fit,'error')||fixed)NA_integer_ else fit$opt_results$convergence,LogLik=if(inherits(fit,'error'))NA_real_ else fit$logLik,Valid=ok,Message=paste(c(if(inherits(fit,'error'))conditionMessage(fit) else if(fixed)'Fixed Q: no optimization.' else fit$opt_results$message,warnings),collapse='; '))
 }
 attempts<-do.call(rbind,attempts);valid<-which(attempts$Valid)
 if(!length(valid))return(list(fit=NULL,attempts=attempts,warnings='No converged finite fit. Inspect optimizer messages.',calls=calls))
 best<-valid[which.max(attempts$LogLik[valid])];fit<-fits[[best]];warnings<-character()
 if(any(!attempts$Valid))warnings<-c(warnings,'Some starting values failed. Inspect optimizer messages.')
 if(!fixed && any(fit$rates<=lower*10 | fit$rates>=max_rate*.99))warnings<-c(warnings,'A rate is near an optimization bound. Estimates and model rankings may be unstable.')
 if(diff(range(attempts$LogLik[valid]))>1e-4)warnings<-c(warnings,'Starting values reached different likelihoods. The highest converged likelihood is shown; a global optimum is not guaranteed.')
 if(!fixed && max(index)>=length(d$x)-1)warnings<-c(warnings,'There are many rate parameters relative to taxa. Interpret this fit cautiously.')
 if(any(tabulate(match(d$x,d$states),length(d$states))<3))warnings<-c(warnings,'Some states have fewer than three observed taxa.')
 list(fit=fit,attempts=attempts,warnings=warnings,calls=calls,options=o)
}

# Keep global marginals available for mapping diagnostics; joint assignments are separate.
guane_mk_joint <- function(fit,options) {
 if(options$requested$reconstruction!='joint')return(NULL)
 messages<-capture.output(z<-phytools::ancr(fit,type='joint',tol=options$requested$joint_tol))
 if(anyNA(z$ace)||any(!as.character(z$ace)%in%fit$states)||!is.finite(z$logLik))stop('Invalid joint ancestral reconstruction.')
 list(states=setNames(as.character(z$ace),names(z$ace)),logLik=as.numeric(z$logLik),tol=options$requested$joint_tol,messages=messages)
}

# A prospective call preview validates settings without running a model.
guane_mk_call_preview <- function(d,index,max_rate=100,advanced=list()) {
 o<-guane_mk_options(d,index,max_rate,advanced)
 c('# Validated selected-model calls; tree and named tip data come from Data.',
  guane_r_assignment('state_order',d$states),
  guane_r_assignment('backend_defaults',o$backend_defaults),
  unlist(lapply(seq_along(o$starts),function(i){a<-o$args;if(!is.null(o$starts[[i]]))a$q.init<-o$starts[[i]];c(guane_r_assignment(paste0('args_',i),a),paste0('fit_',i,' <- do.call(phytools::fitMk, c(list(tree=tree, x=x), args_',i,'))'))})),
  if(length(o$starts)==1)'fit <- fit_1' else c(paste0('candidates <- list(',paste0('fit_',seq_along(o$starts),collapse=', '),')'),'valid <- vapply(candidates, function(f) identical(f$opt_results$convergence, 0L) && is.finite(f$logLik), logical(1))','stopifnot(any(valid))','fit <- candidates[valid][[which.max(vapply(candidates[valid], function(f) f$logLik, numeric(1)))]]'),
  'marginal <- phytools::ancr(fit, type="marginal")',
  if(o$requested$reconstruction=='joint')paste0('joint <- phytools::ancr(fit, type="joint", tol=',o$requested$joint_tol,')'))
}

guane_asr_state_plot <- function(result,type='tree',palette='Guane',labels=TRUE,node_labels=FALSE,label_size=.7,pie_size=.6,lang='en',appearance=list()) {
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old))
 txt<-function(x)guane_text(x,lang);r<-result;k<-length(r$states);g<-guane_asr_graphics(appearance)
 cols<-guane_asr_colors(r$states,palette,g$colors)
 key<-paste0('S',seq_len(k));legend_labels<-vapply(paste(key,r$states,sep=': '),function(s)paste(strwrap(s,width=36),collapse='\n'),character(1))
 if(type%in%c('tree','joint')) {
  if(type=='joint' && is.null(r$joint))stop('Run joint reconstruction before viewing assignments.')
  if(g$legend)graphics::layout(matrix(c(1,2),2,1),heights=c(5,1));on.exit(graphics::layout(1),add=TRUE)
  ape::plot.phylo(r$tree,type=g$layout,direction=g$direction,font=g$font,edge.width=g$edge_width,edge.lty=g$edge_type,underscore=g$underscore,show.tip.label=labels,cex=label_size,label.offset=g$label_offset*max(ape::node.depth.edgelength(r$tree)),no.margin=FALSE,main=paste(txt(if(type=='joint')'Joint ancestral assignments' else if(!is.null(r$bayes))'Bayesian Mk ancestral reconstruction' else if(isTRUE(r$polymorphic)) 'Polymorphic ancestral reconstruction' else 'Mk ancestral reconstruction'),r$trait,sep='\n'),cex.main=.85)
  ape::tiplabels(pch=21,bg=cols[r$x],cex=.9)
  if(type=='joint')ape::nodelabels(node=as.integer(names(r$joint$states)),pch=21,bg=cols[r$joint$states],cex=1.5*pie_size)
  else if(g$node_style=='best') {
   p<-r$probabilities;best<-max.col(p,ties.method='first');supported<-apply(p,1,function(v)sum(abs(v-max(v))<1e-10)==1 && max(v)>=g$support)
   ape::nodelabels(node=as.integer(rownames(p)),pch=ifelse(supported,21,4),bg=cols[best],cex=1.5*pie_size)
  } else ape::nodelabels(node=as.integer(rownames(r$probabilities)),pie=r$probabilities,piecol=cols,cex=pie_size)
  guane_asr_highlight(r,g)
  if(node_labels) ape::nodelabels(frame='none',cex=label_size*.8,adj=c(1.4,-.7))
  guane_asr_legend(r$states,cols,g,label_size)
 } else if(type=='rates') {
  if(g$legend)graphics::layout(matrix(c(1,2),2,1),heights=c(5,1));on.exit(graphics::layout(1),add=TRUE)
  q<-r$Q;dimnames(q)<-list(key,key);class(q)<-'Qmatrix'
  coords<-phytools::plot.Qmatrix(q,show.zeros=g$q_zeros,tol=g$q_threshold,signif=g$q_digits,width=g$q_width && length(unique(q[row(q)!=col(q) & q>0 & q>=g$q_threshold]))>1,logscale=FALSE,max.lwd=g$q_max_width,rotate=g$q_rotate,spacer=g$q_spacer,text=g$q_text,lwd=g$edge_width,cex.traits=label_size,cex.rates=label_size*.8,main=txt(if(is.null(r$bayes))'Transition rates per branch-length unit' else 'Posterior mean transition rates per branch-length unit'),cex.main=.85,mar=c(1,1,3,1))
  graphics::points(coords$x,coords$y,pch=21,bg=cols,cex=3)
  graphics::text(coords$x*1.13,coords$y*1.13,key,cex=label_size,col='black')
  guane_asr_legend(r$states,cols,g,label_size)
 } else if(type=='probabilities') {
  if(g$legend)graphics::layout(matrix(c(1,2),2,1),heights=c(5,1));on.exit(graphics::layout(1),add=TRUE)
  graphics::par(mar=c(5,5,3,1));p<-r$probabilities
  graphics::image(seq_len(nrow(p)),seq_len(k),p,zlim=c(0,1),col=gray.colors(101,start=1,end=0),axes=FALSE,xlab=txt('Node'),ylab='',main=txt(if(is.null(r$bayes))'Marginal state probabilities' else 'Posterior node probabilities'))
  graphics::axis(1,at=seq_len(nrow(p)),labels=rownames(p),cex.axis=label_size)
  graphics::axis(2,at=seq_len(k),labels=key,las=1,cex.axis=label_size)
  for(i in seq_len(nrow(p)))for(j in seq_len(k))graphics::text(i,j,format(round(p[i,j],2),nsmall=2),cex=label_size*.8,col=if(p[i,j]>.5)'white' else 'black')
  guane_asr_legend(r$states,cols,g,label_size)
 } else if(type=='node') {
  t<-guane_asr_node_table(r,g$focus_node)
  graphics::par(mar=c(6,5,3,1));graphics::barplot(t$Probability,names.arg=t$State,col=cols,ylim=c(0,1),las=2,cex.names=label_size,ylab=txt('Marginal state probabilities'),main=paste(txt('Selected node'),g$focus_node))
 } else if(type=='comparison') {
  t<-r$comparison;t<-t[is.finite(t$Delta_AIC),]
  graphics::par(mar=c(5,5,3,1))
  if(nrow(t)<2){graphics::plot.new();graphics::text(.5,.5,txt('At least two valid models are needed for comparison.'))}
  else graphics::barplot(t$Delta_AIC,names.arg=t$Model,col=cols[1],ylab=txt('Delta AIC (ML)'),main=txt('Model comparison'),cex.names=label_size)
 } else if(type=='starts') {
  t<-r$attempts;t<-t[is.finite(t$LogLik),]
  graphics::par(mar=c(6,5,3,1))
  graphics::plot(seq_len(nrow(t)),t$LogLik,pch=ifelse(t$Valid,19,4),col=cols[1],xaxt='n',xlab='',ylab=txt('Log likelihood (ML)'),main=txt('Optimizer starts'))
  graphics::axis(1,at=seq_len(nrow(t)),labels=paste(t$Model,t$Start),las=2,cex.axis=label_size)
 } else stop('Unknown Mk graph.')
 invisible(cols)
}

# Histories conditional on one selected Q, observed tips, tree and saved root weights.
# Preserve the caller's RNG state so one module cannot alter another module's seed.
guane_asr_map <- function(result,nsim=100,seed=999) {
 if(length(nsim)!=1 || !is.finite(nsim) || nsim!=floor(nsim) || nsim<2 || nsim>500) stop('Choose an integer number of histories between 2 and 500.')
 if(length(seed)!=1 || !is.finite(seed) || seed!=floor(seed) || seed<0 || seed>2147483646) stop('Choose an integer seed between 0 and 2147483646.')
 r<-result;k<-length(r$states);Q<-r$Q
 if(!is.matrix(Q) || !identical(dimnames(Q),list(r$states,r$states)) || any(!is.finite(Q)) || any(Q[row(Q)!=col(Q)]<0) || any(abs(rowSums(Q))>1e-7)) stop('Mapping requires a valid fitted Q matrix in the displayed state order.')
 # A conservative workload screen; this is not a statistical constraint.
 if(sum(r$tree$edge.length)*max(-diag(Q))*nsim>2e6) stop('Requested mapping workload is too large. Reduce the number of histories.')
 oldkind<-RNGkind();hadseed<-exists('.Random.seed',envir=.GlobalEnv,inherits=FALSE)
 if(hadseed)oldseed<-get('.Random.seed',envir=.GlobalEnv)
 on.exit({do.call(RNGkind,as.list(oldkind));if(hadseed)assign('.Random.seed',oldseed,envir=.GlobalEnv) else if(exists('.Random.seed',envir=.GlobalEnv,inherits=FALSE))rm('.Random.seed',envir=.GlobalEnv)},add=TRUE)
 set.seed(seed,kind='Mersenne-Twister',normal.kind='Inversion',sample.kind='Rejection')
 warnings<-character()
 maps<-withCallingHandlers(phytools::make.simmap(r$tree,if(is.null(r$tip_likelihood))r$x else r$tip_likelihood,model=r$index,nsim=nsim,Q=Q,pi=r$root_prior,tol=0,message=FALSE),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
 if(!inherits(maps,'multiSimmap') || length(maps)!=nsim)stop('Mapping did not return the requested number of histories.')
 guane_asr_map_summary(r,maps,seed,warnings)
}

# Validate and summarize saved histories without sampling; shared by fixed-Q and Bayesian maps.
guane_asr_map_summary <- function(r,maps,seed,warnings=character(),variable_Q=FALSE) {
 nsim<-length(maps);k<-length(r$states);Q<-r$Q
 nodes<-rownames(r$probabilities);node_states<-matrix('',nsim,length(nodes),dimnames=list(NULL,nodes))
 times<-matrix(0,nsim,k,dimnames=list(NULL,r$states))
 pairs<-which(row(Q)!=col(Q),arr.ind=TRUE)
 changes<-matrix(0,nsim,nrow(pairs));totals<-numeric(nsim)
 for(h in seq_len(nsim)) {
  tr<-maps[[h]];edge<-tr$edge
  if(variable_Q) {
   Q<-tr$Q
   if(!is.matrix(Q) || !identical(dimnames(Q),list(r$states,r$states)) || any(!is.finite(Q)) || any(Q[row(Q)!=col(Q)]<0) || any(abs(rowSums(Q))>1e-7) || any(Q[r$index==0 & row(Q)!=col(Q)]!=0))stop('A sampled history does not match the fitted model or taxa.')
  }
  if(!identical(tr$tip.label,r$tree$tip.label) || !variable_Q && (!isTRUE(all.equal(unname(tr$Q),unname(Q),tolerance=1e-10)) || abs(as.numeric(tr$logL)-r$logLik)>1e-6))stop('A sampled history does not match the fitted model or taxa.')
  start<-end<-character(nrow(edge));count<-matrix(0,k,k)
  for(e in seq_len(nrow(edge))) {
   seg<-tr$maps[[e]];s<-names(seg)
   if(!length(seg) || any(!is.finite(seg)) || any(seg<0) || abs(sum(seg)-tr$edge.length[e])>1e-7*max(1,tr$edge.length[e]) || any(!s%in%r$states))stop('A sampled history has invalid branch segments.')
   start[e]<-s[1];end[e]<-tail(s,1)
   for(j in seq_along(seg))times[h,s[j]]<-times[h,s[j]]+seg[j]
   if(length(s)>1)for(j in seq_len(length(s)-1)) {
    a<-match(s[j],r$states);b<-match(s[j+1],r$states)
    if(a==b || Q[a,b]<=0)stop('A sampled history contains a forbidden transition.')
    count[a,b]<-count[a,b]+1
   }
  }
  state<-setNames(end,as.character(edge[,2]));root<-as.character(length(tr$tip.label)+1L)
  state[root]<-start[which(as.character(edge[,1])==root)[1]]
  if(any(start!=state[as.character(edge[,1])]) || any(state[as.character(seq_along(tr$tip.label))]!=unname(r$x[tr$tip.label])))stop('A sampled history is inconsistent at nodes or observed tips.')
  node_states[h,]<-state[nodes];changes[h,]<-count[pairs];totals[h]<-sum(count)
 }
 summarize<-function(m) {
  data.frame(Mean=colMeans(m),SD=apply(m,2,stats::sd),MCSE=apply(m,2,stats::sd)/sqrt(nsim),Lower=apply(m,2,stats::quantile,probs=.025),Upper=apply(m,2,stats::quantile,probs=.975),row.names=NULL)
 }
 transition_summary<-cbind(data.frame(From=r$states[pairs[,1]],To=r$states[pairs[,2]]),summarize(changes))
 time_summary<-cbind(data.frame(State=r$states),summarize(times))
 freq<-sapply(r$states,function(s)colMeans(node_states==s));dimnames(freq)<-list(nodes,r$states)
 node_summary<-data.frame(Node=rep(nodes,each=k),State=rep(r$states,length(nodes)),Frequency=as.vector(t(freq)),Analytic=as.vector(t(r$probabilities)),check.names=FALSE)
 node_summary$MCSE<-sqrt(node_summary$Frequency*(1-node_summary$Frequency)/nsim)
 node_summary$Difference<-node_summary$Frequency-node_summary$Analytic
 r$mapping<-list(maps=maps,nsim=nsim,seed=seed,node_states=node_states,frequencies=freq,node_summary=node_summary,times=times,changes=changes,total_changes=totals,transition_summary=transition_summary,time_summary=time_summary,warnings=unique(warnings),rng=c('Mersenne-Twister','Inversion','Rejection'))
 r
}

guane_asr_map_plot <- function(result,type='history',palette='Guane',labels=TRUE,node_labels=FALSE,label_size=.7,pie_size=.6,lang='en',history=1,appearance=list()) {
 g<-guane_asr_graphics(appearance)
 if(type%in%c('history','density') && g$layout!='phylogram')stop('Colored histories and continuous maps currently require a phylogram layout.')
 r<-result;m<-r$mapping;if(is.null(m))stop('Run stochastic mapping before viewing history summaries.')
 if(length(history)!=1 || !is.finite(history) || history!=floor(history) || history<1 || history>m$nsim)stop('Choose a saved history number within the simulated range.')
 txt<-function(x)guane_text(x,lang);k<-length(r$states)
 cols<-guane_asr_colors(r$states,palette,g$colors)
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old))
 if(type=='frequencies') {
  r$probabilities<-m$frequencies;r$trait<-paste(r$trait,'-',txt('Sampled node frequencies'))
  guane_asr_state_plot(r,'tree',palette,labels,node_labels,label_size,pie_size,lang,appearance)
 } else if(type=='history') {
  if(g$legend)graphics::layout(matrix(c(1,2),2,1),heights=c(5,1));on.exit(graphics::layout(1),add=TRUE)
  indices<-m$map_indices;if(is.null(indices))indices<-seq_along(m$maps)
  i<-match(history,indices);if(is.na(i))stop('Choose a saved history number within the simulated range.')
  phytools::plotSimmap(m$maps[[i]],colors=cols,ftype=if(labels)c('reg','b','i','bi')[g$font] else 'off',fsize=label_size,lwd=g$edge_width,type=g$layout,direction=g$direction,underscore=g$underscore,outline=g$outline,mar=c(1,1,3,1),offset=g$label_offset*max(ape::node.depth.edgelength(r$tree)),pts=FALSE)
  if(node_labels)ape::nodelabels(frame='none',cex=label_size*.8)
  guane_asr_highlight(r,g)
  graphics::title(main=paste(txt(if(is.null(r$bayes))'Conditional stochastic history' else 'Posterior stochastic history'),history,'/',m$nsim),cex.main=.9)
  guane_asr_legend(r$states,cols,g,label_size)
 } else if(type=='density') {
  z<-r$display_density;if(is.null(z)||!identical(z$focus,g$focus_state)||z$resolution!=g$resolution)z<-guane_asr_density(r,g$focus_state,g$resolution);z$map$cols[]<-grDevices::colorRampPalette(c('#DDDDDD',cols[g$focus_state]))(length(z$map$cols))
  plot(z$map,type=g$layout,direction=g$direction,lwd=g$edge_width,fsize=c(if(labels)label_size else 0,g$legend_size),ftype=c(c('reg','b','i','bi')[g$font],'reg'),underscore=g$underscore,outline=g$outline,offset=g$label_offset*max(phytools::nodeHeights(r$tree)),legend=if(g$legend)g$legend_fraction*max(phytools::nodeHeights(r$tree)) else 0,leg.txt=c('0',paste(txt('Sampled occupancy'),g$focus_state),'1'),mar=c(1,1,3,1))
  graphics::title(main=paste(txt('Selected state versus all others'),g$focus_state,sep=': '),cex.main=.85)
  if(node_labels)ape::nodelabels(frame='none',cex=label_size*.8)
  guane_asr_highlight(r,g)
 } else if(type=='transition') {
  pair<-which(m$transition_summary$From==g$focus_state & m$transition_summary$To==g$transition_to)
  if(length(pair)!=1)stop('Select two different states for a saved transition distribution.')
  v<-m$changes[,pair];graphics::par(mar=c(5,5,3,1));graphics::hist(v,breaks=if(diff(range(v))<=100)seq(min(v)-.5,max(v)+.5,by=1) else pretty(range(v),n=50),col=cols[g$focus_state],main=paste(g$focus_state,'->',g$transition_to),xlab=txt('Transitions per history'),ylab=txt('Frequency'))
 } else if(type%in%c('changes','times')) {
  t<-if(type=='changes')m$transition_summary else m$time_summary
  names<-if(type=='changes')paste(t$From,t$To,sep=' -> ') else t$State
  # Horizontal intervals allow long state names and up to 90 directed pairs.
  graphics::par(mar=c(5,min(16,max(5,max(nchar(names))*.3)),3,1))
  y<-seq_len(nrow(t));range<-range(c(0,t$Upper));if(diff(range)==0)range<-c(0,1)
  graphics::plot(t$Mean,y,xlim=range,yaxt='n',ylab='',xlab=txt(if(type=='changes')'Transitions per history' else 'Total branch length in state'),pch=19,col=if(type=='times')cols[t$State] else if(palette=='Grayscale')'#333333' else '#0d5368',main=txt(if(is.null(r$bayes))'Mean and central 95% simulation range' else 'Posterior mean and equal-tailed 95% interval'),cex.main=.85)
  graphics::segments(t$Lower,y,t$Upper,y,col='#555555')
  graphics::axis(2,at=y,labels=names,las=1,cex.axis=min(label_size,15/nrow(t)))
 } else if(type=='mc') {
  f<-as.vector(m$frequencies);p<-as.vector(r$probabilities)
  graphics::par(mar=c(5,5,3,1));graphics::plot(p,f,xlim=c(0,1),ylim=c(0,1),pch=19,col=rep(cols,each=nrow(r$probabilities)),xlab=txt('Analytic marginal probability'),ylab=txt('Sampled node-state frequency'),main=txt('Monte Carlo agreement'),cex.main=.9)
  graphics::abline(0,1,lty=2,col='grey50')
 } else stop('Unknown stochastic mapping graph.')
 invisible(m)
}
# Display-only options; never alter fitted trees, states, matrices or estimates.
guane_asr_graphics <- function(appearance=list()) {
 d<-list(width=10,height=8,dpi=150,layout='phylogram',direction='rightwards',font=3,
  edge_width=2,edge_type=1,label_offset=.02,underscore=TRUE,legend=TRUE,legend_size=.7,
  legend_columns=0,legend_fraction=.4,colors=NULL,gradient=NULL,focus_node='',focus_state='',
  node_style='pies',support=.9,resolution=100,outline=FALSE,q_digits=3,q_threshold=1e-12,
  q_zeros=FALSE,q_width=FALSE,q_max_width=5,q_rotate=0,q_spacer=.1,q_text=TRUE,transition_to='')
 if(!is.list(appearance)||any(!names(appearance)%in%names(d)))stop('Unknown graphical setting.')
 g<-utils::modifyList(d,appearance,keep.null=TRUE)
 limits<-list(width=c(4,20),height=c(4,20),dpi=c(72,300),font=c(1,4),edge_width=c(.1,10),edge_type=c(1,6),label_offset=c(0,.5),legend_size=c(.2,2),legend_columns=c(0,10),legend_fraction=c(.05,1),support=c(0,1),resolution=c(20,500),q_digits=c(1,8),q_max_width=c(1,10),q_threshold=c(0,1e8),q_rotate=c(-360,360),q_spacer=c(0,.4))
 for(n in names(limits))if(!is.numeric(g[[n]])||length(g[[n]])!=1||!is.finite(g[[n]])||g[[n]]<limits[[n]][1]||g[[n]]>limits[[n]][2])stop('Graphical numeric setting is outside its allowed range.')
 for(n in c('dpi','font','edge_type','legend_columns','resolution','q_digits'))if(g[[n]]!=floor(g[[n]]))stop('Graphical count settings must be integers.')
 for(n in c('underscore','legend','outline','q_zeros','q_width','q_text'))if(!is.logical(g[[n]])||length(g[[n]])!=1||is.na(g[[n]]))stop('Invalid graphical switch.')
 if(!g$layout%in%c('phylogram','fan')||!g$direction%in%c('rightwards','leftwards')||!g$node_style%in%c('pies','best'))stop('Invalid graphical choice.')
 g
}

guane_asr_colors <- function(states,palette='Guane',custom=NULL) {
 k<-length(states)
 cols<-setNames(if(palette=='Grayscale')gray.colors(k,start=.15,end=.85) else grDevices::hcl.colors(k,if(palette=='Legacy')'Dynamic' else 'Dark 3'),states)
 if(!is.null(custom)&&length(custom)&&!(is.character(custom)&&length(custom)==1&&!nzchar(trimws(custom)))) {
  if(is.character(custom)&&length(custom)==1) {
   z<-tryCatch(utils::read.csv(text=custom,header=FALSE,colClasses='character',strip.white=TRUE,comment.char=''),error=function(e)NULL)
   if(is.null(z)||ncol(z)!=2)stop('Colors require one state,color row per allowed state, without a header.')
   custom<-setNames(z[[2]],z[[1]])
  }
  if(!is.character(custom)||anyNA(custom)||anyDuplicated(names(custom))||!setequal(names(custom),states)||any(!grepl('^#[0-9A-Fa-f]{6}$',custom)))stop('Provide every state once with a six-digit hexadecimal color, such as #2277AA.')
  cols<-custom[states]
 }
 cols
}

guane_asr_gradient <- function(palette='Guane',custom=NULL) {
 cols<-switch(palette,Grayscale=c('#eeeeee','#222222'),Legacy=c('#02b2ce','#ffd004','#e52920'),c('#e4f1cf','#54a37a','#0d5368'))
 if(!is.null(custom)&&length(custom)&&any(nzchar(custom))) {
  if(length(custom)==1)custom<-strsplit(trimws(custom),'[,[:space:]]+')[[1]]
  if(length(custom)<2||length(custom)>8||anyNA(custom)||any(!grepl('^#[0-9A-Fa-f]{6}$',custom)))stop('Use two to eight six-digit hexadecimal gradient colors.')
  cols<-custom
 }
 cols
}

guane_asr_node_table <- function(result,node) {
 ids<-if(is.null(result$probabilities))as.character(result$nodes$Node) else rownames(result$probabilities)
 if(length(node)!=1||!as.character(node)%in%ids)stop('Select an internal node from the saved result.')
 node<-as.character(node)
 if(is.null(result$probabilities))return(result$nodes[match(node,ids),,drop=FALSE])
 t<-data.frame(Node=node,State=result$states,Probability=as.numeric(result$probabilities[node,]),check.names=FALSE)
 if(!is.null(result$mapping))t$Frequency<-as.numeric(result$mapping$frequencies[node,])
 if(!is.null(result$joint))t$Joint<-result$states==result$joint$states[node]
 t
}

guane_asr_highlight <- function(result,g) {
 if(nzchar(g$focus_node)) {
  guane_asr_node_table(result,g$focus_node)
  ape::nodelabels(node=as.integer(g$focus_node),pch=1,col='#111111',cex=2,lwd=2)
 }
}

guane_asr_legend <- function(states,cols,g,label_size=.7) {
 if(!g$legend)return(invisible(NULL))
 lab<-vapply(paste0('S',seq_along(states),': ',states),function(s)paste(strwrap(s,width=36),collapse='\n'),character(1))
 graphics::par(mar=c(0,0,0,0));graphics::plot.new()
 graphics::legend('center',legend=lab,fill=cols,bty='n',ncol=if(g$legend_columns>0)g$legend_columns else if(length(states)>5)2 else 1,cex=g$legend_size)
}

# Binary display projection of complete saved histories; no inference or RNG calls.
# densityMap averages occupancy within each grid segment and across histories.
guane_asr_density <- function(result,focus,resolution=100) {
 if(is.null(result$mapping)||!focus%in%result$states)stop('Select a state from saved stochastic histories.')
 if(!is.numeric(resolution)||length(resolution)!=1||!is.finite(resolution)||resolution<20||resolution>500||resolution!=floor(resolution))stop('Density resolution must be an integer from 20 to 500.')
 if(length(result$mapping$maps)!=result$mapping$nsim)stop('Density maps require all saved histories.')
 maps<-result$mapping$maps
 for(i in seq_along(maps)) {
  maps[[i]]$maps<-lapply(maps[[i]]$maps,function(seg){names(seg)<-ifelse(names(seg)==focus,'1','0');seg})
  maps[[i]]$mapped.edge<-t(vapply(maps[[i]]$maps,function(seg)c('0'=sum(seg[names(seg)=='0']),'1'=sum(seg[names(seg)=='1'])),numeric(2)))
 }
 z<-suppressMessages(phytools::densityMap(maps,res=resolution,states=c('0','1'),plot=FALSE))
 H<-phytools::nodeHeights(z$tree)
 table<-do.call(rbind,lapply(seq_along(z$tree$maps),function(i){seg<-z$tree$maps[[i]];end<-cumsum(seg);data.frame(Edge=i,Parent=z$tree$edge[i,1],Child=z$tree$edge[i,2],Start=H[i,1]+c(0,head(end,-1)),End=H[i,1]+end,Occupancy=as.numeric(names(seg))/1000)}))
 table$State<-focus;table$Histories<-result$mapping$nsim
 list(map=z,table=table,focus=focus,resolution=resolution,nsim=result$mapping$nsim)
}

# Respect the requested device dimensions in standalone scripts, while allowing an
# RStudio user to supply an already-open graphics device.
guane_asr_script_device <- function(appearance=list(),close=FALSE) {
 g<-guane_asr_graphics(appearance)
 if(close)return('if (guane_opened_device) grDevices::dev.off()')
 c('guane_opened_device <- grDevices::dev.cur() == 1L',sprintf('if (guane_opened_device) grDevices::pdf("guane-asr-graph.pdf", width=%s, height=%s)',g$width,g$height),sprintf('# Raster alternative: png("guane-asr-graph.png", width=%s, height=%s, units="in", res=%s)',g$width,g$height,g$dpi))
}

# Shared posterior rate engine for discrete and polymorphic Mk cards.
# Rate IDs refer to the displayed constraint matrix, not an implicit backend ordering.
guane_mk_bayes_parameters <- function(index,parameters=NULL) {
 ids<-paste0('q',seq_len(max(index)))
 p<-data.frame(Parameter=ids,Shape=1,Rate=1,ProposalVariance=.1)
 if(is.null(parameters))return(p)
 if(is.character(parameters))parameters<-tryCatch(utils::read.csv(text=parameters,check.names=FALSE),error=function(e)NULL)
 if(!is.data.frame(parameters) || !identical(names(parameters),names(p)) || anyDuplicated(parameters$Parameter) || !setequal(as.character(parameters$Parameter),ids) || nrow(parameters)!=length(ids))stop('Rate-prior CSV requires Parameter, Shape, Rate, ProposalVariance and one row for each displayed q index.')
 p<-parameters[match(ids,parameters$Parameter),,drop=FALSE];rownames(p)<-NULL
 if(!all(vapply(p[-1],is.numeric,logical(1))) || any(!is.finite(as.matrix(p[-1]))) || any(as.matrix(p[-1])<=0))stop('Gamma shape, gamma rate and proposal variances must be finite and positive.')
 p
}

guane_asr_bayes_rates <- function(d,index,model,nsim=200,burnin=1000,samplefreq=50,chains=2,seed=999,parameters=NULL,root='equal',root_weights=NULL,empirical=FALSE) {
 hadseed<-exists('.Random.seed',envir=.GlobalEnv,inherits=FALSE);oldkind<-RNGkind()
 if(hadseed)oldseed<-get('.Random.seed',envir=.GlobalEnv)
 on.exit({do.call(RNGkind,as.list(oldkind));if(hadseed)assign('.Random.seed',oldseed,envir=.GlobalEnv) else if(exists('.Random.seed',envir=.GlobalEnv,inherits=FALSE))rm('.Random.seed',envir=.GlobalEnv)},add=TRUE)
 tree<-d$tree
 # Supply explicit state columns so locale sorting cannot permute custom constraints.
 xx<-matrix(0,length(d$x),length(d$states),dimnames=list(names(d$x),d$states));xx[cbind(seq_along(d$x),match(d$x,d$states))]<-1
 d$tip_likelihood<-xx
 p<-guane_mk_bayes_parameters(index,parameters)
 valid<-function(x,lo,hi)length(x)==1 && is.numeric(x) && is.finite(x) && x==floor(x) && x>=lo && x<=hi
 if(!valid(nsim,20,2000)||!valid(burnin,1,1000000)||!valid(samplefreq,1,10000)||!valid(chains,1,4)||!valid(seed,0,2147483646-chains))stop('Choose 20\u20132000 saved draws per chain, positive burn-in and spacing, 1\u20134 chains and a valid seed.')
 if(chains*(burnin+nsim*samplefreq)*length(d$x)*length(d$states)^3>2e8 || chains*nsim*length(d$x)*length(d$states)>2e6)stop('Requested Bayesian workload is too large; reduce generations, chains or saved draws.')
 if(!is.logical(empirical)||length(empirical)!=1||is.na(empirical))stop('Invalid empirical-prior setting.')
 pi<-guane_mk_options(d,index,advanced=list(root=root,root_weights=root_weights))$args$pi
 if(is.character(pi))pi<-setNames(rep(1/length(d$states),length(d$states)),d$states)
 warnings<-character()
 reach<-index>0;diag(reach)<-TRUE
 for(i in seq_len(nrow(index)))reach<-reach | outer(reach[,i],reach[i,],'&')
 if(sum(pi[rowSums(reach)==nrow(index)])<=0)stop('Root weights give no support to a state that can reach all observed states.')
 if(empirical) {
  fit<-withCallingHandlers(phytools::fitMk(tree,xx,model=index,pi=pi),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
  if(!is.finite(fit$logLik)||!identical(as.integer(fit$opt_results$convergence),0L)||length(fit$rates)!=nrow(p)||any(!is.finite(fit$rates))||any(fit$rates<=0))stop('Empirical prior requires finite positive fitted rates; use explicit gamma priors.')
  p$Shape<-fit$rates*p$Rate
  warnings<-c(warnings,'Empirical Bayes: gamma prior means were estimated from these same data. This is not a fully prespecified prior analysis.')
 }
 # Prior-based workload screen, never an unreported truncation of the posterior.
 if(sum(tree$edge.length)*sum(stats::qgamma(.999,p$Shape,rate=p$Rate))*nsim*chains>2e6)stop('Requested mapping workload is too large. Reduce the number of histories.')
 settings<-list(prior=list(alpha=p$Shape,beta=p$Rate,use.empirical=FALSE),vQ=p$ProposalVariance,pi=pi,tol=0,Q='mcmc',burnin=burnin,samplefreq=samplefreq,nsim=nsim,message=FALSE)
 maps<-list();draws<-vector('list',chains);prob_draws<-vector('list',chains);nodes<-as.character(length(d$x)+seq_len(tree$Nnode));pairs<-which(index>0,arr.ind=TRUE)
 for(ch in seq_len(chains)) {
  set.seed(seed+ch-1,kind='Mersenne-Twister',normal.kind='Inversion',sample.kind='Rejection')
  sampled<-withCallingHandlers(do.call(phytools::make.simmap,c(list(tree=tree,x=xx,model=index),settings)),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
  if(!inherits(sampled,'multiSimmap')||length(sampled)!=nsim)stop('Mapping did not return the requested number of histories.')
  z<-data.frame(gen=burnin+seq_len(nsim)*samplefreq);probs<-array(NA_real_,c(nsim,length(nodes),length(d$states)))
  for(j in seq_len(nrow(p)))z[[p$Parameter[j]]]<-vapply(sampled,function(m)m$Q[which(index==j)[1]],numeric(1))
  z$logLik<-vapply(sampled,function(m)as.numeric(m$logL),numeric(1))
  if(any(!is.finite(as.matrix(z)))||any(as.matrix(z[p$Parameter])<=0))stop('The sampler returned invalid or incomplete posterior draws.')
  for(i in seq_len(nsim)) {
   q<-sampled[[i]]$Q
   if(any(vapply(seq_len(nrow(p)),function(j)any(abs(q[index==j]-z[i,p$Parameter[j]])>1e-10),logical(1))))stop('Sampled rates violate the selected Mk constraints.')
   f<-phytools::fitMk(tree,xx,model=index,fixedQ=q,pi=pi)
   if(!is.finite(f$logLik)||abs(f$logLik-z$logLik[i])>1e-7)stop('Invalid marginal probabilities or inconsistent reconstruction likelihood.')
   probs[i,,]<-phytools::ancr(f,type='marginal')$ace[nodes,d$states,drop=FALSE]
  }
  draws[[ch]]<-z;prob_draws[[ch]]<-probs;maps<-c(maps,unclass(sampled))
 }
 class(maps)<-c('multiSimmap','multiPhylo')
 diag<-guane_bayes_diagnostics(draws)
 if(chains<2)warnings<-c(warnings,'One chain cannot assess between-chain convergence; split-Rhat is unavailable.')
 if(chains>1 && any(!is.finite(diag$SplitRhat)|diag$SplitRhat>1.01))warnings<-c(warnings,'Split-Rhat exceeds 1.01 or is unavailable. Do not treat this run as converged.')
 if(any(!is.finite(diag$ESS)|diag$ESS<400))warnings<-c(warnings,'Effective sample size is below 400 or unavailable. Longer or better-tuned chains are needed.')
 meanQ<-Reduce('+',lapply(maps,`[[`,'Q'))/length(maps)
 prob<-Reduce('+',lapply(prob_draws,function(x)apply(x,c(2,3),mean)))/chains;dimnames(prob)<-list(nodes,d$states)
 if(any(!is.finite(prob))||any(prob<0)||any(abs(rowSums(prob)-1)>1e-6))stop('Invalid marginal probabilities or inconsistent reconstruction likelihood.')
 r<-c(d,list(index=index,model=model,Q=meanQ,probabilities=prob,logLik=NA_real_,root_prior=pi,warnings=unique(warnings),package_version=as.character(utils::packageVersion('phytools'))))
 r<-guane_asr_map_summary(r,maps,seed,variable_Q=TRUE)
 # Summary MCSE accounts for serial dependence; samples are not independent histories.
 summarize<-function(m){zs<-lapply(seq_len(chains),function(i){t<-as.data.frame(m[(i-1)*nsim+seq_len(nsim),,drop=FALSE]);names(t)<-paste0('v',seq_len(ncol(t)));cbind(gen=draws[[i]]$gen,t)});guane_bayes_diagnostics(zs)}
 for(n in c('changes','times')) {
  dd<-summarize(r$mapping[[n]]);field<-if(n=='changes')'transition_summary' else 'time_summary'
  r$mapping[[field]]$MCSE<-dd$MCSE;r$mapping[[field]]$ESS<-dd$ESS
 }
 nd<-do.call(cbind,lapply(d$states,function(s)1*(r$mapping$node_states==s)));ndd<-summarize(nd)
 node_diag<-data.frame(Node=rep(nodes,length(d$states)),State=rep(d$states,each=length(nodes)),Probability=as.vector(prob),SampledFrequency=ndd$Mean,ESS=ndd$ESS,SplitRhat=ndd$SplitRhat,MCSE=ndd$MCSE)
 # MC agreement of iid fixed-Q histories is not an MCMC convergence test.
 r$mapping$node_summary<-node_diag
 r$bayes<-list(retained=draws,draws=do.call(rbind,lapply(seq_len(chains),function(i)cbind(Chain=i,draws[[i]]))),diagnostics=diag,node_diagnostics=node_diag,parameters=p,settings=settings,seeds=seed+seq_len(chains)-1,burnin=burnin,samplefreq=samplefreq,chains=chains,nsim=nsim,probability_draws=prob_draws)
 r
}

guane_mk_bayes_plot <- function(result,type='trace',parameter='q1',palette='Guane',lang='en',appearance=list()) {
 b<-result$bayes;if(is.null(b))stop('Run Bayesian Mk reconstruction first.')
 txt<-function(s)guane_text(s,lang);g<-guane_asr_graphics(appearance)
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old));graphics::par(mar=c(5,5,3,1))
 if(type=='rate_intervals') {
  t<-b$diagnostics[b$diagnostics$Parameter!='logLik',];graphics::plot(t$Mean,seq_len(nrow(t)),xlim=range(c(0,t$Upper)),yaxt='n',ylab='',xlab=txt('Transition rates per branch-length unit'),pch=19,main=txt('Posterior mean and equal-tailed 95% interval'));graphics::segments(t$Lower,seq_len(nrow(t)),t$Upper,seq_len(nrow(t)));graphics::axis(2,at=seq_len(nrow(t)),labels=t$Parameter,las=1,cex.axis=min(.8,15/nrow(t)));return(invisible(t))
 }
 if(!parameter%in%names(b$retained[[1]])||parameter=='gen')stop('Select a saved posterior parameter.')
 colors<-if(palette=='Grayscale')grDevices::gray.colors(b$chains,start=.2,end=.65) else grDevices::hcl.colors(b$chains,'Dark 3');vals<-lapply(b$retained,`[[`,parameter)
 if(type=='trace') {
  graphics::plot(range(b$retained[[1]]$gen),range(unlist(vals)),type='n',xlab=txt('Generation'),ylab=parameter,main=txt('Retained MCMC trace (burn-in not saved)'))
  for(i in seq_along(vals))graphics::lines(b$retained[[i]]$gen,vals[[i]],col=colors[i],lty=i,lwd=g$edge_width)
 } else {
  ds<-lapply(vals,function(v)if(parameter=='logLik')stats::density(v) else stats::density(v,from=0));graphics::plot(range(unlist(lapply(ds,`[[`,'x'))),c(0,max(vapply(ds,function(d)max(d$y),numeric(1)))),type='n',xlab=parameter,ylab=txt('Density'),main=txt('Posterior density'))
  for(i in seq_along(ds))graphics::lines(ds[[i]],col=colors[i],lty=i,lwd=g$edge_width)
 }
 if(g$legend)graphics::legend('topright',legend=paste(txt('Chain'),seq_along(vals)),col=colors,lty=seq_along(vals),bty='n')
 invisible(b$diagnostics)
}

guane_mk_bayes_script <- function(result,type='tree',palette='Guane',labels=TRUE,node_labels=FALSE,label_size=.7,pie_size=.6,lang='en',history=1,appearance=list(),parameter='q1') {
 poly<-isTRUE(result$polymorphic)
 helpers<-c('guane_mk_bayes_parameters','guane_asr_bayes_rates','guane_mk_bayes_plot','guane_bayes_diagnostics','guane_mk_options','guane_asr_graphics','guane_asr_colors','guane_asr_gradient','guane_asr_node_table','guane_asr_highlight','guane_asr_legend','guane_asr_density','guane_asr_state_plot','guane_asr_map_summary','guane_asr_map_plot','guane_text',if(poly)c('guane_poly_data','guane_poly_matrix','guane_asr_poly_bayes','guane_asr_poly_plot') else c('guane_mk_matrix','guane_mk_data','guane_asr_mk_bayes','guane_asr_mk_plot'))
 c('# Guane Bayesian Mk: gamma priors, fixed tree, sampled rates and histories.',
 if(poly)'# Polymorphic coexistence states and ordering are saved in inputs and result$coding.',
 '# install.packages(c("ape","phytools","coda","jsonlite"))',
 '# Node pies average conditional marginals over posterior Q draws; Q is the posterior mean matrix.',
 '# Burn-in and acceptance counts are not returned by make.simmap; traces show retained draws only.',
 paste0('# R ',getRversion(),'; phytools ',utils::packageVersion('phytools')),
 guane_script_helpers(helpers),
 guane_r_assignment('inputs',result$inputs),paste0('# Optional refit: refitted <- do.call(',if(poly)'guane_asr_poly_bayes' else 'guane_asr_mk_bayes',',inputs)'),
 guane_bayes_saved_assignment(result),
 guane_r_assignment('plot_settings',list(type=type,palette=palette,labels=labels,node_labels=node_labels,label_size=label_size,pie_size=pie_size,lang=lang,history=history,appearance=appearance,parameter=parameter)),
 'print(result$bayes$diagnostics)','print(result$warnings)',guane_asr_script_device(appearance),
 paste0('do.call(',if(poly)'guane_asr_poly_plot' else 'guane_asr_mk_plot',',c(list(result=result),plot_settings))'),guane_asr_script_device(appearance,close=TRUE),'sessionInfo()')
}

# Classic split-Rhat, explicitly distinguished from rank-normalized Rhat.
# coda spectral ESS is calculated per chain, then summed; stuck chains flag failure.
guane_bayes_diagnostics <- function(draws) {
 pars<-setdiff(names(draws[[1]]),c('gen','Chain'))
 rows<-lapply(pars,function(p){
  xs<-lapply(draws,function(d)d[[p]]);n<-length(xs[[1]]);half<-floor(n/2)
  ess<-sum(vapply(xs,function(x)if(stats::var(x)==0)0 else tryCatch(as.numeric(coda::effectiveSize(coda::mcmc(x))),error=function(e)NA_real_),numeric(1)))
  split<-do.call(cbind,lapply(xs,function(x)cbind(head(x,half),tail(x,half))))
  W<-mean(apply(split,2,stats::var));B<-half*stats::var(colMeans(split))
  if(any(vapply(xs,stats::var,numeric(1))==0))ess<-0
  rhat<-if(length(xs)<2)NA_real_ else if(!is.finite(W) || W<=0 || ess==0)Inf else sqrt(((half-1)/half*W+B/half)/W)
  all<-unlist(xs,use.names=FALSE)
  data.frame(Parameter=p,Mean=mean(all),SD=stats::sd(all),Lower=unname(stats::quantile(all,.025)),Upper=unname(stats::quantile(all,.975)),ESS=ess,SplitRhat=rhat,MCSE=if(is.finite(ess) && ess>0)stats::sd(all)/sqrt(ess) else NA_real_)
 })
 do.call(rbind,rows)
}


guane_bayes_saved_assignment <- function(result) {
 encoded<-jsonlite::base64_enc(memCompress(serialize(result,NULL,version=2),type='gzip'))
 chunks<-substring(encoded,seq(1,nchar(encoded),by=4096),pmin(seq(1,nchar(encoded),by=4096)+4095,nchar(encoded)))
 paste0('result <- unserialize(memDecompress(jsonlite::base64_dec(paste0(',paste(vapply(chunks,function(x)encodeString(x,quote='"'),character(1)),collapse=',\n'),')),type="gzip"))')
}
