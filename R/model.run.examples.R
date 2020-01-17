###example script for using trilobite model functions 
##accompanies Hopkins 2019; written on 10/5/19
#changes from previous version 1/13/20: "N" variable replaced with "Molt"; change all plotting arguments to default on line 16 for creating Figure 2


##to estimate parameters for A. koninckii, requires par.est.R function:

x<-read.table('growth-koninckii-min.txt',header = T)
source('par.est.R')
source('trilo.growth.R')

par.estSP<-par.est(x,Ter=18,Ter.min = 9,Ter.hol = 20)

##for results shown in figure 2, requires trilo.growth.R function:

trilo.growth(Molt = 31, par.estSP = par.estSP) #all other arguments as default

par.estSP.fig4<-par.estSP.fig5<-par.estSP.fig6a<-par.estSP.fig6d<-par.estSP.fig6g<-par.estSP

##for results shown in figure 4:
par.estSP.fig4[1]<-10
trilo.growth(Molt = 31, par.estSP = par.estSP.fig4)

##for results shown in figure 5:
par.estSP.fig5[9]<-par.estSP[6]
par.estSP.fig5[10]<-par.estSP[7]
par.estSP.fig5[11]<-par.estSP[8]
trilo.growth(Molt = 31, par.estSP = par.estSP.fig5)

##for results shown in figure 6A-C:
par.estSP.fig6a[9]<-1.168
par.estSP.fig6a[10]<-1.168
trilo.growth(Molt = 31, par.estSP = par.estSP.fig6a)

##for results shown in figure 6D-F:
par.estSP.fig6d[9]<-1.125
par.estSP.fig6d[10]<-1.125
trilo.growth(Molt = 31, par.estSP = par.estSP.fig6d)

##for results shown in figure 6G-I:
par.estSP.fig6g[9]<-1.084
par.estSP.fig6g[10]<-1.084
trilo.growth(Molt = 31, par.estSP = par.estSP.fig6g)

##for results shown in figure 7:
trilo.growth(Molt = 31, par.estSP = par.estSP, R = 15)
trilo.growth(Molt = 31, par.estSP = par.estSP, R = 18)
trilo.growth(Molt = 31, par.estSP = par.estSP, R = 20)
trilo.growth(Molt = 31, par.estSP = par.estSP, R = 22)
trilo.growth(Molt = 31, par.estSP = par.estSP, R = 25)
