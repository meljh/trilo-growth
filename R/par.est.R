#parameter estimation from growth series to accompany trilobite growth model
#written by Melanie J Hopkins 10/5/19

#need growth series with standard headers (specimen, morphotype, CEL, TS1...etc, PYL). For juveniles, non-existent thoracic tergites should be entered as "0" length. If specimen numbers exist, they should be treated as row names
# Ter = number of terminal tergites
# Ter.min = number of tergites at start of meraspid series used to estimate meraspid growth gradient
# Ter.hol = number of tergites for holaspids sampled for holaspid growth gradient (usually = Ter; assigned independently here to acommodate taxa with variatble numbers of terminal thoracic tergites like Aulacopleura koninckii)

par.est<-function(x, Ter = NULL, Ter.min = NULL, Ter.hol = NULL){
  
  if (missing(Ter)==TRUE){
    Ter = max(x$morphotype)}
  if (missing(Ter.min)==TRUE){
    Ter.min = min(x$morphotype)}
  if (missing(Ter.hol)==TRUE){
    Ter.hol = max(x$morphotype)}
  
  x.juv<-x[which(x$morphotype>=Ter.min&x$morphotype<Ter),]
  lmc<-lm(log(x.juv$CEL)~x.juv$morphotype)  #regression of cephalic length on molt for all juveniles
  ce = exp(lmc$coefficients[1]) #initial cephalic size is intercept of regression
  g.c = exp(lmc$coefficients[2]) #growth rate is slope
  
  p = mean(x$PYL[which(x$morphotype<Ter)])
  
  #mean and variance for all sclerites in each morphotype
  m<-matrix(NA,ncol=ncol(x),nrow=(length(unique(x$morphotype))))
  s<-matrix(NA,ncol=ncol(x),nrow=(length(unique(x$morphotype))))
  for (i in 1:length(unique(x$morphotype))){
    temp<-subset(x,x$morphotype==unique(x$morphotype)[i])
    m[i,]<-colMeans(temp)
    s[i,]<-apply(temp,2,var)
  }
  
  colnames(m)<-colnames(x)
  
  #new tergite length / new tergite + pygidium
  te<-matrix(NA,ncol=2,nrow=(nrow(m)-1))
  for (i in 1:nrow(te)){
    te[i,]<-c(m[i,m[i,1]+2],m[i,which(colnames(m)=='PYL')])
  }
  t.p <- mean(te[,1]/rowSums(te))
  
  ####growth gradients for meraspid
  stage.mean<-matrix(NA,ncol=ncol(x),nrow=length(c(Ter.min:(Ter-1))))
  for (i in (Ter.min:(Ter-1))){
    temp<-x[which(x$morphotype==i),]
    stage.mean[i-(Ter.min-1),]<-colMeans(temp)
  }
  
  gr.data<-vector()
  rel.data<-vector()
  pyg.col<-dim(stage.mean)[2]
  
  for (i in Ter.min:(Ter-2)){
    cum.length<-cumsum(na.omit(stage.mean[which(stage.mean[,1]==i),3:pyg.col]))
    rel.data.end<-cum.length/cum.length[i+1]
    rel.data.mid<-rel.data.end-(diff(c(0,rel.data.end))/2)
    rel.data<-c(rel.data,rel.data.mid)
    new.lengths<-na.omit(stage.mean[which(stage.mean[,1]==i+1),3:ncol(stage.mean)])
    new.lengths1<-c(new.lengths[1:i],new.lengths[i+1]+new.lengths[i+2])
    old.lengths<-na.omit(stage.mean[which(stage.mean[,1]==i),3:ncol(stage.mean)])
    gr.data.temp<-new.lengths1/old.lengths
    gr.data<-c(gr.data,gr.data.temp)
  }
  
  exp_formula<-formula(gr.data~a+b*exp(-w*(1-rel.data)))
  mer<-nls(exp_formula,start=list(a=1.05,b=0.3,w=4.77))
  
  lowM<-summary(mer)$coefficients[1,1]
  highM<-summary(mer)$coefficients[1,1]+summary(mer)$coefficients[2,1]
  lambdaM <- -summary(mer)$coefficients[3,1]
  
  ##growth gradient for holaspids 
  x.hol<-x[which(x$morphotype==Ter.hol),]
  new.stages<-round((log(x.hol$CEL)-lmc$coefficients[1])/lmc$coefficients[2])
  x.hol<-cbind(x.hol,new.stages)
  
  stage.mean.hol<-matrix(NA,ncol=ncol(x.hol),nrow=length(c(Ter.hol:max(x.hol$new.stages))))
  for (i in (Ter.hol:max(x.hol$new.stages))){
    temp<-x.hol[which(x.hol$new.stages==i),]
    stage.mean.hol[i-(Ter.hol-1),]<-colMeans(temp)
  }
  gr.data.hol<-vector()
  rel.data.hol<-vector()
  pyg.col.hol<-dim(stage.mean.hol)[2]-1
  new.stage.col<-dim(stage.mean.hol)[2]
  
  for (i in Ter.hol:(max(x.hol$new.stages)-1)){
    cum.length.hol<-cumsum(na.omit(stage.mean.hol[which(stage.mean.hol[,new.stage.col]==i),3:pyg.col]))
    rel.data.temp<-(cum.length.hol/cum.length.hol[Ter.hol+1])[1:Ter.hol]
    rel.data.hol<-c(rel.data.hol,rel.data.temp)
    gr.data.temp<-stage.mean.hol[which(stage.mean.hol[,new.stage.col]==i+1),3:(Ter.hol+2)]/
      stage.mean.hol[which(stage.mean.hol[,new.stage.col]==i),3:(Ter.hol+2)]
    gr.data.hol<-c(gr.data.hol,gr.data.temp)
  }
  
  exp_formula<-formula(gr.data.hol~a+b*exp(-w*(1-rel.data.hol)))
  h<-nls(exp_formula,start=list(a=1.05,b=0.3,w=4.77))
  
  lowH<-summary(h)$coefficients[1,1]
  highH<-summary(h)$coefficients[1,1]+summary(h)$coefficients[2,1]
  lambdaH <- -summary(h)$coefficients[3,1]
  
  
  tab <- c(Ter.hol, ce, p, g.c, t.p, lowM, highM, lambdaM, lowH, highH, lambdaH)
  names(tab) <- c('Ter', 'ce', 'p', 'g.c', 't.p', 'lowM', 'highM', 'lambdaM', 'lowH', 'highH', 'lambdaH')
  return(tab)
  
}
