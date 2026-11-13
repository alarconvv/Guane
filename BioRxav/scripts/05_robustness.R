# Run from BioRxav. All omissions are reported; the primary 13-taxon fit is unchanged.
out <- 'results/robustness-2026-11-11';dir.create(out,recursive=TRUE,showWarnings=FALSE)
source('source/app_tasks.R');source('source/core_mod_data_base.R')
source('source/core_mod_signal_signal.R');source('source/core_mod_signal_PGLS.R')
d<-readRDS('data/prepared.rds');tree<-d$tree;traits<-d$traits
full<-guane_pgls(tree,traits,'taxon','beakD','wingL',model='BM',method='REML')
loo<-do.call(rbind,lapply(tree$tip.label,function(id){
 tryCatch({
 t<-ape::drop.tip(tree,id);z<-traits[traits$taxon!=id,]
 fit<-guane_pgls(t,z,'taxon','beakD','wingL',model='BM',method='REML')
 sig<-guane_signal(t,z,'taxon','beakD',seed=20261201,nsim=999)
 b<-fit$coefficients[2,]
 data.frame(Omitted=id,N=nrow(z),Slope=b$Estimate,SE=b$SE,Lower=b$Lower,Upper=b$Upper,P=b$P,K=sig$Estimate[1],K_P=sig$P_value[1],Lambda=sig$Estimate[2],Lambda_P=sig$P_value[2],Slope_change=b$Estimate-full$coefficients$Estimate[2],Warnings=paste(fit$warnings,collapse='; '),Error='')
 },error=function(e)data.frame(Omitted=id,N=12,Slope=NA,SE=NA,Lower=NA,Upper=NA,P=NA,K=NA,K_P=NA,Lambda=NA,Lambda_P=NA,Slope_change=NA,Warnings='',Error=conditionMessage(e)))
}))
write.csv(loo,file.path(out,'leave-one-out.csv'),row.names=FALSE)
stopifnot(nrow(loo)==13,setequal(loo$Omitted,tree$tip.label),all(is.finite(loo$Slope)))
# An independence reference checks dependence on the fixed BM covariance choice.
ind<-guane_pgls(tree,traits,'taxon','beakD','wingL',model='Pagel',value=0,fixed=TRUE,method='REML')
write.csv(ind$coefficients,file.path(out,'independence-reference.csv'),row.names=FALSE)
# Conditional GLS leverage uses the same unit-diagonal phylogenetic correlation as nlme.
C<-ape::vcv.phylo(tree,corr=TRUE);C<-C[tree$tip.label,tree$tip.label]
X<-model.matrix(~wingL,traits);W<-solve(t(chol(C)));Xw<-W%*%X
H<-Xw%*%solve(crossprod(Xw),t(Xw));res<-full$points$Residual
sh<-shapiro.test(res)
leverage<-data.frame(Taxon=tree$tip.label,Leverage=diag(H),Normalized_residual=res)
write.csv(leverage,file.path(out,'conditional-gls-diagnostics.csv'),row.names=FALSE)
summary<-data.frame(N=13,Full_slope=full$coefficients$Estimate[2],LOO_min=min(loo$Slope),LOO_max=max(loo$Slope),All_slopes_positive=all(loo$Slope>0),All_lower_intervals_positive=all(loo$Lower>0),Largest_change_taxon=loo$Omitted[which.max(abs(loo$Slope_change))],Largest_absolute_change=max(abs(loo$Slope_change)),K_P_min=min(loo$K_P),K_P_max=max(loo$K_P),Lambda_P_min=min(loo$Lambda_P),Lambda_P_max=max(loo$Lambda_P),Residual_Shapiro_W=unname(sh$statistic),Residual_Shapiro_P=sh$p.value,Independence_slope=ind$coefficients$Estimate[2])
write.csv(summary,file.path(out,'summary.csv'),row.names=FALSE)
pdf(file.path(out,'robustness-diagnostics.pdf'),width=10,height=8)
par(mfrow=c(2,2),mar=c(4,4,3,1));plot(full$points$Fitted,res,pch=19,xlab='Fitted beakD',ylab='Normalized residual');abline(h=0,lty=2)
qqnorm(res,pch=19,main='Conditional GLS residuals');qqline(res)
plot(loo$Slope,seq_len(13),xlim=range(loo$Lower,loo$Upper),yaxt='n',ylab='',xlab='Slope after omitting named taxon',pch=19);axis(2,at=1:13,labels=loo$Omitted,las=2,cex.axis=.55);segments(loo$Lower,1:13,loo$Upper,1:13);abline(v=full$coefficients$Estimate[2],lty=2)
plot(loo$K_P,seq_len(13),yaxt='n',ylab='',xlab='K randomization P after omission',pch=19);axis(2,at=1:13,labels=loo$Omitted,las=2,cex.axis=.55);abline(v=.05,lty=2)
dev.off()
saveRDS(list(full=full,loo=loo,independence=ind),file.path(out,'fits.rds'))
capture.output(sessionInfo(),file=file.path(out,'sessionInfo.txt'))
print(summary)
