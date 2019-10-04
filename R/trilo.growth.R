#growth model based on various parameters
#written by Melanie J Hopkins

#par.estSP may be created using par.est.R

trilo.growth<-function(N,par.estSP,med=TRUE,plot.bol=TRUE,plot.pic=TRUE,R=NULL)
{
  
  ##input prep
  force(par.estSP)
  par.estSP<-as.list(par.estSP)
  Ter = par.estSP$Ter
  ce  = par.estSP$ce
  p = par.estSP$p
  g.c = par.estSP$g.c
  t.p = par.estSP$t.p
  lowM = par.estSP$lowM
  highM = par.estSP$highM
  lambdaM = par.estSP$lambdaM
  lowH = par.estSP$lowH
  highH = par.estSP$highH
  lambdaH = par.estSP$lambdaH
  
  ####functions for plots
  upper.half.circle <- function(x,y,r,nsteps=100,...){  
    rs <- seq(0,pi,len=nsteps) 
    xc <- x+r*cos(rs) 
    yc <- y+r*sin(rs) 
    polygon(xc,yc,...) 
  } 
  
  lower.half.circle <- function(x,y,r,nsteps=100,...){ 
    rs <- seq(0,pi,len=nsteps) 
    xc <- x-r*cos(rs) 
    yc <- y-r*sin(rs) 
    polygon(xc,yc,...) 
  } 
  
  ####################
  
  
  
  if (missing(R)==TRUE){
    R=Ter
  }
  
  S<-c(1:Ter,rep(Ter,N-Ter))
  
  bol<-matrix(0,nrow=N,ncol=Ter+4)
  for (M in 1:N){
    bol[M,1] <- cr <- ce*g.c^M
    #insertion of initial thoracic tergite
    if (M==1){
      t.rate<-(highM-lowM)/2 + highM
      bol[M,(S[M]+1)] <- p*t.rate*t.p
      bol[M,Ter+2] <- py <- p*t.rate - p*highM*t.p
    }
    
    
    if (R==Ter){#rates switch and new segment generation ends at same molt
      #growth during meraspid stage
      if (M>1 & S[M]==M){
        g.previous<-c(bol[M-1,2:S[M]],bol[M-1,Ter+2])
        bound<-c(0,cumsum(g.previous))
        bound.scale<-(bound-min(bound))/(max(bound)-min(bound))
        #apply growth gradient to median part of sclerite (med=TRUE) or posterior part (med=FALSE)
        if (med==TRUE){
          tx<-bound.scale[2:length(bound.scale)]-(bound.scale[2:length(bound.scale)]-bound.scale[1:(length(bound.scale)-1)])/2
        } else {tx<-bound.scale[-1]}
        g.t<-lowM+exp(lambdaM*(1-tx))*(highM-lowM)
        new.tr<-g.previous*g.t
        bol[M,2:(1+S[M-1])] <- new.tr[1:(M-1)]
        bol[M,(S[M]+1)] <- new.tr[M]*t.p
        bol[M,Ter+2] <- py <- new.tr[M]-new.tr[M]*t.p
      }
      
      #growth of tergites during holaspid stage
      if (S[M]!=M){
        g.previous<-bol[M-1,2:(S[M]+2)]
        bound<-c(0,cumsum(g.previous))
        bound.scale<-(bound-min(bound))/(max(bound)-min(bound))
        #apply growth gradient to median part of sclerite (med=TRUE) or posterior part (med=FALSE)
        if (med==TRUE){
          tx<-bound.scale[2:length(bound.scale)]-(bound.scale[2:length(bound.scale)]-bound.scale[1:(length(bound.scale)-1)])/2
        } else {tx<-bound.scale[-1]}
        g.t<-lowH+exp(lambdaH*(1-tx))*(highH-lowH)
        new.tr<-g.previous*g.t
        bol[M,2:(S[M]+2)] <- new.tr
        py <- new.tr[S[M]+2]
        
      }
    }
    
    if (R<Ter){ #rates switch before new segment generation ends
      if (M>1 & S[M]==M & S[M]<R){
        g.previous<-c(bol[M-1,2:S[M]],bol[M-1,Ter+2])
        bound<-c(0,cumsum(g.previous))
        bound.scale<-(bound-min(bound))/(max(bound)-min(bound))
        #apply growth gradient to median part of sclerite (med=TRUE) or posterior part (med=FALSE)
        if (med==TRUE){
          tx<-bound.scale[2:length(bound.scale)]-(bound.scale[2:length(bound.scale)]-bound.scale[1:(length(bound.scale)-1)])/2
        } else {tx<-bound.scale[-1]}
        g.t<-lowM+exp(lambdaM*(1-tx))*(highM-lowM)
        new.tr<-g.previous*g.t
        bol[M,2:(1+S[M-1])] <- new.tr[1:(M-1)]
        bol[M,(S[M]+1)] <- new.tr[M]*t.p
        bol[M,Ter+2] <- py <- new.tr[M]-new.tr[M]*t.p
      }
      
      if (M>1 & S[M]==M & S[M]>=R){
        g.previous<-c(bol[M-1,2:S[M]],bol[M-1,Ter+2])
        bound<-c(0,cumsum(g.previous))
        bound.scale<-(bound-min(bound))/(max(bound)-min(bound))
        #apply growth gradient to median part of sclerite (med=TRUE) or posterior part (med=FALSE)
        if (med==TRUE){
          tx<-bound.scale[2:length(bound.scale)]-(bound.scale[2:length(bound.scale)]-bound.scale[1:(length(bound.scale)-1)])/2
        } else {tx<-bound.scale[-1]}
        g.t<-lowH+exp(lambdaM*(1-tx))*(highH-lowH)
        new.tr<-g.previous*g.t
        bol[M,2:(1+S[M-1])] <- new.tr[1:(M-1)]
        bol[M,(S[M]+1)] <- new.tr[M]*t.p
        bol[M,Ter+2] <- py <- new.tr[M]-new.tr[M]*t.p 
      }
      
      if (S[M]!=M){
        g.previous<-bol[M-1,2:(S[M]+2)]
        bound<-c(0,cumsum(g.previous))
        bound.scale<-(bound-min(bound))/(max(bound)-min(bound))
        #apply growth gradient to median part of sclerite (med=TRUE) or posterior part (med=FALSE)
        if (med==TRUE){
          tx<-bound.scale[2:length(bound.scale)]-(bound.scale[2:length(bound.scale)]-bound.scale[1:(length(bound.scale)-1)])/2
        } else {tx<-bound.scale[-1]}
        g.t<-lowH+exp(lambdaH*(1-tx))*(highH-lowH)
        new.tr<-g.previous*g.t
        bol[M,2:(S[M]+2)] <- new.tr
        py <- new.tr[S[M]+2]
      }
    }
    
    if (R>Ter){ #rates switch after new segment generation ends
      if (M>1 & S[M]==M){
        g.previous<-c(bol[M-1,2:S[M]],bol[M-1,Ter+2])
        bound<-c(0,cumsum(g.previous))
        bound.scale<-(bound-min(bound))/(max(bound)-min(bound))
        #apply growth gradient to median part of sclerite (med=TRUE) or posterior part (med=FALSE)
        if (med==TRUE){
          tx<-bound.scale[2:length(bound.scale)]-(bound.scale[2:length(bound.scale)]-bound.scale[1:(length(bound.scale)-1)])/2
        } else {tx<-bound.scale[-1]}
        g.t<-lowM+exp(lambdaM*(1-tx))*(highM-lowM)
        new.tr<-g.previous*g.t
        bol[M,2:(1+S[M-1])] <- new.tr[1:(M-1)]
        bol[M,(S[M]+1)] <- new.tr[M]*t.p
        bol[M,Ter+2] <- py <- new.tr[M]-new.tr[M]*t.p
      }
      
      if (M>1 & S[M]!=M & R>=M){
        g.previous<-bol[M-1,2:(S[M]+2)]
        bound<-c(0,cumsum(g.previous))
        bound.scale<-(bound-min(bound))/(max(bound)-min(bound))
        #apply growth gradient to median part of sclerite (med=TRUE) or posterior part (med=FALSE)
        if (med==TRUE){
          tx<-bound.scale[2:length(bound.scale)]-(bound.scale[2:length(bound.scale)]-bound.scale[1:(length(bound.scale)-1)])/2
        } else {tx<-bound.scale[-1]}
        g.t<-lowM+exp(lambdaH*(1-tx))*(highM-lowM)
        new.tr<-g.previous*g.t
        bol[M,2:(S[M]+2)] <- new.tr
        py <- new.tr[S[M]+2] 
      }
      
      if (S[M]!=M & R<M){
        g.previous<-bol[M-1,2:(S[M]+2)]
        bound<-c(0,cumsum(g.previous))
        bound.scale<-(bound-min(bound))/(max(bound)-min(bound))
        #apply growth gradient to median part of sclerite (med=TRUE) or posterior part (med=FALSE)
        if (med==TRUE){
          tx<-bound.scale[2:length(bound.scale)]-(bound.scale[2:length(bound.scale)]-bound.scale[1:(length(bound.scale)-1)])/2
        } else {tx<-bound.scale[-1]}
        g.t<-lowH+exp(lambdaH*(1-tx))*(highH-lowH)
        new.tr<-g.previous*g.t
        bol[M,2:(S[M]+2)] <- new.tr
        py <- new.tr[S[M]+2]
      }
    }
    
    
    
    bol[M,Ter+3] <- th <- sum(bol[M,2:(S[M]+1)])
    bol[M,Ter+4] <- sum(bol[M,1:(S[M]+2)])
  }
  
  #colnames(bol)<-c('CEL',paste(''))
  
  #layout(matrix(1:3,1,3))
  #par(mar=c(4,4,1,1))
  
  if (plot.bol==TRUE){
    barplot(t(bol[,1:(Ter+2)]),col=c('deepskyblue1',
                                     gray(1:Ter/Ter),
                                     #rep('white',Ter),
                                     'hotpink1'),
            ylim=c(max(bol[,(Ter+4)]),0),
            #ylim=c(50,0),
            ylab='Length (mm)') 
    barplot(t(bol[,1:(Ter+2)]/rowSums(bol[,1:(Ter+2)])),col=c('deepskyblue1',
                                                              gray(1:Ter/Ter),
                                                              #rep('white',Ter),
                                                              'hotpink1'),ylim=c(1,0),ylab='Relative length')
  }
  
  if (plot.pic==TRUE){
    plot(1, type="n",axes=F,xlab="", ylab="",xlim=c(0,30),ylim=c(-(bol[N,Ter+4]+5),(bol[N,1]+5)),asp=1)
    rect(xleft=seq(15-bol[N,1],15-bol[N,Ter+2],(bol[N,1]-bol[N,Ter+2])/(Ter-1)),
         xright=seq(15+bol[N,1],15+bol[N,Ter+2],-(bol[N,1]-bol[N,Ter+2])/(Ter-1)),
         ybottom=(-cumsum(bol[N,2:(Ter+1)])),
         ytop=c(0,-cumsum(bol[N,2:Ter])),
         col=gray(1:Ter/Ter))
    upper.half.circle(15,0,bol[N,1],nstep=1000,col='deepskyblue1')
    lower.half.circle(15,-sum(bol[N,2:(Ter+1)]),bol[N,Ter+2],nstep=1000,col='hotpink1')
  }
  
  colnames(bol)<-c('CEL',paste0(rep('TSL',Ter),1:Ter,sep=''),'PYL','THOR','TOT')
  return(bol)
  
}

