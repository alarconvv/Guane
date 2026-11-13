d<-readRDS("data/prepared.rds");r<-readRDS("results/guane-fits.rds")
# Figure 1 is a workflow schematic, not an empirical result.
workflow <- function(){
 par(mar=c(0,0,2,0));plot.new();plot.window(xlim=c(0,1),ylim=c(0,1));title("GUANE empirical workflow")
 labels<-c("Public geiger dataset\n14 tree tips; 13 trait rows","Explicit matching\nexclude olivacea; retain 13 taxa","GUANE core functions\nbeakD signal; beakD ~ wingL (BM)","Inspect and reproduce\ncoefficients, diagnostics, R scripts")
 for(i in 1:4){y<-1-i*.21;rect(.13,y-.065,.87,y+.065,col="#edf3e9",border="#34765b");text(.5,y,labels[i],cex=1);if(i<4)arrows(.5,y-.07,.5,y-.135,length=.08,col="#34765b")}
}
empirical <- function(){
 par(mfrow=c(2,2),mar=c(5,5,3,2),cex=1.1)
 ape::plot.phylo(d$tree,cex=1.05,label.offset=.025);title("A  Matched finch phylogeny")
 plot(d$traits$wingL,d$traits$beakD,pch=19,col="#34765b",xlab="wingL (distributed scale)",ylab="beakD (distributed scale)",main="B  Trait association")
 b<-r$pgls$coefficients$Estimate;abline(b[1],b[2],col="#0d5368",lwd=2)
 z<-r$pgls$points;plot(z$Fitted,z$Residual,pch=19,col="#34765b",xlab="Fitted beakD",ylab="Normalized residual",main="C  BM PGLS diagnostics");abline(h=0,lty=2)
 loo<-read.csv("results/robustness-2026-11-11/leave-one-out.csv")
 par(mar=c(5,8,3,2));y<-seq_len(nrow(loo))
 plot(loo$Slope,y,xlim=range(loo$Lower,loo$Upper),yaxt='n',ylab='',xlab='Slope (distributed scale)',main='D  Leave-one-taxon-out sensitivity',pch=19,col='#34765b')
 axis(2,at=y,labels=loo$Omitted,las=2,cex.axis=1);segments(loo$Lower,y,loo$Upper,y,col='#34765b');abline(v=r$pgls$coefficients$Estimate[2],lty=2,col='#0d5368')
}
for(n in c("01","02")){
 fun<-if(n=="01")workflow else empirical
 pdf(paste0("figures/figure",n,".pdf"),width=if(n=="01")7 else 12,height=if(n=="01")6 else 10);fun();dev.off()
 png(paste0("figures/figure",n,".png"),width=if(n=="01")1400 else 2400,height=if(n=="01")1200 else 2000,res=200);fun();dev.off()
}
