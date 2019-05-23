## This script runs a regression analysis on the fitness data

if(!exists('fit.xts')) source('fitnessstatic.R')
library(plotly)
if(!exists('shift')) shift <- 0

##Date Frame
fit.df <- data.frame(time(fit.xts),
            as.vector(fit.xts$Exercise_Minutes),
            as.vector(fit.xts$Weight),
            as.vector(fit.xts$Calories))
          names(fit.df) <- c('Date','Exercise_Minutes','Weight','Calories')

          ##Set Exercise minutes to NA if value = 1
          sel <- fit.df$Exercise_Minutes==1
          sel[is.na(sel)] <- T
          fit.df[sel,'Exercise_Minutes'] <- NA
          

          ##Linear interpolation between each data point to fill gaps
          fit.df$Weight <- approx(fit.df$Date,fit.df$Weight,xout=fit.df$Date)$y
          
##Scatter plots
    
          if(scatplot=='Overeating'){
          ##Calories vs Weight
          weigstore <- fit.df$Weight
          fit.df$Weight <- c(rep(NA,shift),fit.df[1:(nrow(fit.df)-shift),'Weight'])
          overlm <- lm(fit.df$Weight~fit.df$Calories)
          }
          
          if(scatplot=='Appetite'){
          ##Exercise vs Calories
          calostore <- fit.df$Calories
          fit.df$Calories <- c(rep(NA,shift),fit.df[1:(nrow(fit.df)-shift),'Calories'])
          appelm <- lm(fit.df$Calories~fit.df$Exercise_Minutes)
          }
          
          if(scatplot=='Exercise'){
          ##Exercise vs weight
          fit.df$Weight <- weigstore
          fit.df$Weight <- c(rep(NA,shift),fit.df[1:(nrow(fit.df)-shift),'Weight'])
          weiglm <- lm(fit.df$Weight~fit.df$Exercise_Minutes)
          }
          
          rm(shift)