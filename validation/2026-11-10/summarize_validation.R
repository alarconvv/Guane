# Summarize completed fits only. No new fits and no inferred model weights.
out<-'validation/2026-11-10'
search<-read.csv(file.path(out,'butterfly_independent_search.csv'))
bound<-read.csv(file.path(out,'butterfly_bound_sensitivity.csv'))
paths<-read.csv(file.path(out,'butterfly_path_starts.csv'))
lbfgs<-read.csv(file.path(out,'butterfly_LBFGSB.csv'))
reference<-read.csv(file.path(out,'butterfly_archive_start_refits.csv'))
all<-rbind(
  data.frame(Series='Multi-start',Ordering=search$Ordering,LogLik=search$LogLik,Convergence=search$Convergence,Difference=search$Difference),
  data.frame(Series=paste0('Upper ',bound$Upper),Ordering='unordered',LogLik=bound$LogLik,Convergence=bound$Convergence,Difference=bound$Difference),
  data.frame(Series='Path starts',Ordering='unordered',LogLik=paths$LogLik,Convergence=paths$Convergence,Difference=paths$Difference),
  data.frame(Series='Published optimizer',Ordering='unordered',LogLik=lbfgs$LogLik,Convergence=lbfgs$Convergence,Difference=lbfgs$Difference))
stopifnot(all(is.finite(all$LogLik)),all(abs(all$Difference)<1e-5))
write.csv(all,file.path(out,'butterfly_all_checked_searches.csv'),row.names=FALSE)
r<-readRDS(file.path(out,'butterfly_ordered_guane_refit.rds'))
b<-readRDS('../Guane-manuscript/results/butterfly_ordered_ARD.rds')
cat('Completed independent searches:',nrow(all),'\n')
cat('Converged independent searches:',sum(all$Convergence==0),'\n')
cat('Largest independent/Guane likelihood discrepancy:',max(abs(all$Difference)),'\n')
cat('Ordered Guane logLik:',format(r$logLik,digits=14),'\n')
cat('Largest node probability change:',max(abs(r$probabilities-b$probabilities)),'\n')
cat('Best converged unordered independent logLik:',max(all$LogLik[all$Ordering=='unordered' & all$Convergence==0]),'\n')
print(reference)
frogs<-readRDS(file.path(out,'frog_combined.rds'))
print(frogs$comparison)
png(file.path(out,'validation_diagnostics.png'),width=1800,height=1500,res=180)
par(mfrow=c(2,1),mar=c(4.2,5,2.6,1))
groups<-factor(all$Ordering,levels=c('ordered','unordered'))
set.seed(20261110)
x<-as.numeric(groups)+runif(nrow(all),-.16,.16)
plot(x,all$LogLik,xaxt='n',xlab='',ylab='Log likelihood',xlim=c(.6,2.4),
  ylim=range(c(all$LogLik,reference$LogLik,-295.0807)),pch=ifelse(all$Convergence==0,16,4),
  col=ifelse(all$Convergence==0,'#246C87','#A54C29'),main='Butterflies: independent searches checked in Guane')
axis(1,at=1:2,labels=c('Ordered ARD','Unordered ARD'))
segments(c(.78,1.78),c(-297.7376,-295.0807),c(1.22,2.22),c(-297.7376,-295.0807),lwd=2,col='#7B3368')
points(rep(2,nrow(reference)),reference$LogLik,pch=8,col='#155E3B',cex=1.4)
legend('bottomleft',c('Converged','Other termination','Published benchmark','Guane reference-start refits'),pch=c(16,4,NA,8),
  lty=c(NA,NA,1,NA),col=c('#246C87','#A54C29','#7B3368','#155E3B'),bty='n',cex=.8)
a<-frogs$attempts
pos<-match(a$Model,c('HiSSE','CID-2','CID-4'))+ifelse(a$Start==1,-.1,.1)
plot(pos,a$LogLik,xlim=c(.6,3.4),ylim=range(c(a$LogLik,a$VerificationLogLik)),
  xaxt='n',xlab='',ylab='Log likelihood',pch=16,col='#246C87',main='Frogs: native fits versus independent checks')
segments(pos,a$LogLik,pos,a$VerificationLogLik,col='grey50')
points(pos,a$VerificationLogLik,pch=1,col='#A54C29',cex=1.25,lwd=1.5)
axis(1,at=1:3,labels=c('HiSSE','CID-2','CID-4'))
legend('bottomright',c('Native','Independent check'),pch=c(16,1),col=c('#246C87','#A54C29'),bty='n',cex=.8)
dev.off()
