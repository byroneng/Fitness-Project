### This script runs analyses based on fitness data.
library(ggplot2)
library(plotly)
library(xts)
library(plyr)

##Options:
startdate <- as.Date('2015-04-01')
enddate   <- as.Date('2016-02-28')

exercise <- read.csv('Exercise-Summary-2015-05-28-to-2016-07-01.csv')
exercise <- read.csv('Exercise-Summary-full.csv')
names(exercise)[1] <- 'Date'
exercise$Date <- strptime(exercise$Date,format='%Y-%m-%d')+(60*60*24*416)
exercise <- exercise[18:133,]

weight <- read.csv('Measurement-Summary-2015-05-28-to-2016-07-01.csv')
weight <- read.csv('Measurement-Summary-full.csv')
names(weight)[1] <- 'Date'
weight$Date <- strptime(weight$Date,format='%Y-%m-%d')+(60*60*24*416)
weight <- weight[18:93,]

nutrition <- read.csv('Nutrition-Summary-2015-05-28-to-2016-07-01.csv')
nutrition <- read.csv('Nutrition-Summary-full.csv')
names(nutrition)[1] <- 'Date'
nutrition$Date <- strptime(nutrition$Date,format='%Y-%m-%d')+(60*60*24*416)
nutrition <- nutrition[4:246,]
calories <- tapply(nutrition$Calories,as.character(nutrition$Date),sum)

## Set up xts objects
exer.tapp <- tapply(exercise$Exercise.Minutes,as.POSIXct(exercise$Date,origin='1970-01-01'),sum)
exer.xts <- xts(as.vector(exer.tapp),order.by=as.POSIXct(names(exer.tapp),origin='1970-01-01'))
weig.xts <- xts(weight$Weight,order.by=as.POSIXct(weight$Date,origin='1970-01-01'))
calo.xts <- xts(as.vector(calories),order.by=as.POSIXct(names(calories),origin='1970-01-01'))

## Data frames
exer.df <- data.frame(as.Date(names(exer.tapp)),as.vector(exer.tapp))
           names(exer.df)  <- c('Date','Exercise')
weig.df <- data.frame(as.Date(weight$Date),weight$Weight)
           names(weig.df) <- c('Date','Weight')
calo.df <- data.frame(as.Date(names(calories)),as.vector(calories))
           names(calo.df)  <- c('Date','Calories')

daterange <- seq.Date(from=as.Date('2016-06-22'),to=as.Date('2016-08-16'),by='day')

fit.xts <- cbind.xts(exer.xts,weig.xts,calo.xts)
           names(fit.xts) <- c('Exercise_Minutes','Weight','Calories')


# plot(exercise$Date,exercise$Exercise.Minutes,type='l',xlab='Date',ylab='Minutes')
# title('Daily Exercise Minutes')
# 
# plot(weight$Date,weight$Weight,type='l',xlab='Date',ylab='Weight [lbs]')
# title('Weight')
# 
# plot(calories,type='l',xaxt='n',xlab='Date',ylab='Calories [kCal]')
# title('Calories')
# 
# p <- ggplot(exercise,aes(x=exercise$Date,y=exercise$Exercise.Minutes)) +
#             geom_point(shape=1)
# ggplotly(p)