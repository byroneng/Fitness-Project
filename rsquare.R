### This script tests the R^2 values of the 3 scatter plots under varying values of 'shift'
require(ggplot2)
require(plotly)
require(xts)
require(plyr)

scatplot <- 'Overeating'
rsq <- data.frame(NA,NA,NA)

  for(i in 0:21){
    shift <- i
    source('fitnessregression.R')
    rsq[i+1,] <- c(i,signif(summary(overlm)$r.squared,3),1)
  }
    
scatplot <- 'Appetite'

  for(i in 0:21){
    shift <- i
    source('fitnessregression.R')
    rsq[i+23,] <- cbind(i,signif(summary(appelm)$r.squared,3),2)
  }

scatplot <- 'Exercise'

  for(i in 0:21){
    shift <- i
    source('fitnessregression.R')
    rsq[i+45,] <- cbind(i,signif(summary(weiglm)$r.squared,3),3)
  }

colnames(rsq) <- c('Days','Rsquare','Scatter')
  


