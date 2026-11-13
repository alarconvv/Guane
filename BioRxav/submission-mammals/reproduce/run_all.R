# Run from submission-mammals: Rscript --vanilla reproduce/run_all.R
stopifnot(dir.exists('data'),dir.exists('gui'),dir.exists('terminal'))
jobs<-list(c('reproduce/00_prepare.R'),c('reproduce/01_terminal.R'),c('reproduce/02_replay_gui.R','signal'),c('reproduce/02_replay_gui.R','pgls'),c('reproduce/02_replay_gui.R','signal','gui/signal-graph.R'),c('reproduce/02_replay_gui.R','pgls','gui/pgls-graph.R'),c('reproduce/03_robustness.R'),c('reproduce/04_figures.R'),c('reproduce/05_verify.R'))
logs<-c('prepare','execution','signal-gui-replay','pgls-gui-replay','signal-downloaded-replay','pgls-downloaded-replay','robustness','figures','verification')
for(i in seq_along(jobs)){
 cat('Running',paste(jobs[[i]],collapse=' '),'\n')
 status<-system2(file.path(R.home('bin'),'Rscript'),c('--vanilla',vapply(jobs[[i]],shQuote,character(1))),stdout=file.path('terminal',paste0(logs[i],'.log')),stderr=file.path('terminal',paste0(logs[i],'.log')))
 if(status!=0)stop('Replay failed; inspect terminal/',logs[i],'.log')
}
cat('PASS: complete terminal replication and all comparisons. GUI evidence was preserved.\n')
