# Execute each GUI script in a fresh process: this script never loads GUANE.
stopifnot(!'guane'%in%loadedNamespaces())
args<-commandArgs(trailingOnly=TRUE);stopifnot(length(args)>=1,args[1]%in%c('signal','pgls'))
name<-args[1];tag<-if(length(args)>1)'downloaded' else 'gui-script';plot_file<-tempfile(fileext='.pdf');pdf(plot_file,width=9,height=7)
source(if(length(args)>1)args[2] else file.path('gui',paste0(name,'-live-code.R')))
dev.off();stopifnot(file.copy(plot_file,file.path('terminal',paste0(name,'-',tag,'-replay.pdf')),overwrite=TRUE));unlink(plot_file);stopifnot(!'guane'%in%loadedNamespaces())
reference<-readRDS('terminal/fits.rds');same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-8,check.attributes=FALSE))
if(name=='signal'){
 stopifnot(same(result,reference$signal));write.csv(result,'terminal/signal-gui-replay.csv',row.names=FALSE)
}else{
 stopifnot(same(result$coefficients,reference$pgls$coefficients),same(result$points,reference$pgls$points));write.csv(result$coefficients,'terminal/pgls-gui-replay.csv',row.names=FALSE)
}
cat('PASS: GUI script reproduced terminal result without loading GUANE.\n')
