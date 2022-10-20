library(phytools)
library(phangorn)
data("Laurasiatherian")

mp.tree<-pratchet(Laurasiatherian)
mp.tree$edge.length<-runif(n=nrow(mp.tree$edge))

lik.model<-pml(mp.tree,Laurasiatherian,k=4)

ml.fit<-optim.pml(lik.model,optGamma=TRUE,optBf=TRUE,optQ=TRUE,
                  rearrangement="ratchet")

ml.tree<-root(ml.fit$tree,outgroup="Platypus")
ml.tree<-drop.tip(ml.tree,"Platypus")
plotTree(ml.tree)

nodes<-c(findMRCA(ml.tree,c("Possum","Cat")),
         findMRCA(ml.tree,c("Squirrel","Mouse")),
         findMRCA(ml.tree,c("Pig","BlueWhale")),
         findMRCA(ml.tree,c("Human","Baboon")),
         findMRCA(ml.tree,c("Horse","Donkey")))
age.min=c(159,66,59,27.95,6.2)
age.max=c(166,75,66,31.35,10)
plotTree(ladderize(ml.tree))
obj<-get("last_plot.phylo",envir=.PlotPhyloEnv)
points(obj$xx[nodes],obj$yy[nodes],pch=21,bg=palette()[1:5],cex=2)
legend("bottomleft",paste("(",age.max,", ",age.min,") mya",sep=""),
       pch=21,pt.bg=palette()[1:5],pt.cex=2,bty="n")


calibration<-makeChronosCalib(ml.tree,node=nodes,
                              age.min=age.min,age.max=age.max)
calibration


pl.tree<-chronos(ml.tree,calibration=calibration)


pl.tree

plotTree(pl.tree,direction="leftwards",xlim=c(174,-40),
         ftype="i",mar=c(4.1,1.1,0.1,1.1),fsize=0.8)
axis(1)
title(xlab="millions of years before present")
abline(v=seq(0,150,by=50),lty="dotted",col="grey")


ult <-is.ultrametric(ml.tree)

N <- Ntip(ml.tree)
root_nodes <- N+1
root_to_tips <- dist.nodes(ml.tree)[1:N,root_nodes]

min_tip <- min(root_to_tips)
max_tip <- max(root_to_tips)

max_tip/min_tip

scaled_root_to_tip <- root_to_tips * 1000


var(scaled_root_to_tip)
## [1] 6.519647e-07
min_tip <- min(scaled_root_to_tip)
max_tip <- max(scaled_root_to_tip)
(max_tip - min_tip) / max_tip

is.ultrametric(pl.tree)

is.binary(pl.tree)





