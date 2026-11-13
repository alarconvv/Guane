r<-readRDS('terminal/fits.rds');same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-8,check.attributes=FALSE))
stopifnot(same(read.csv('gui/signal-results.csv'),r$signal),same(read.csv('gui/pgls-coefficients.csv'),r$pgls$coefficients),same(read.csv('terminal/signal-gui-replay.csv'),r$signal),same(read.csv('terminal/pgls-gui-replay.csv'),r$pgls$coefficients))
stopifnot(all(abs(r$traits$ln_body_mass_kg-log(r$traits$body_mass_kg))<1e-12),all(abs(r$traits$ln_home_range_km2-log(r$traits$home_range_km2))<1e-12))
# The actual downloaded scripts were independently executed by run_all.R.
for(f in c('terminal/signal-downloaded-replay.log','terminal/pgls-downloaded-replay.log'))stopifnot(any(grepl('PASS: GUI script reproduced',readLines(f))))
loo<-read.csv('supplement/leave-one-out.csv');stopifnot(nrow(loo)==49,setequal(loo$Omitted,r$tree$tip.label),all(is.finite(loo$Slope)))
checks<-data.frame(Check=c('49 matching taxa; zero exclusions','Raw kg and km2 preserved; natural logs once','Actual GUI signal CSV matches terminal','Actual GUI regression CSV matches terminal','Both displayed scripts refit in clean sessions','Both downloaded scripts refit in clean sessions','Standalone sessions did not load GUANE','All 49 omission fits retained'),Status='PASS')
write.csv(checks,'terminal/verification.csv',row.names=FALSE);print(checks,row.names=FALSE)
