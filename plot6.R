#loads required libraries
library(reshape2)
library(ggplot2)

#Loads data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#narrows to baltimore and LA cities-only
NEI_Balt_LA<-NEI[NEI$fips %in% c("24510", "06037"),]

#Uses the magic of tapply to obtain total emissions per city and per year
tEm_Balt_LA_Year<-tapply(NEI_Balt_LA$Emissions, NEI_Balt_LA[,c("year", "fips")], sum)

#Melt will convert this data matrix (year x city) into a data frame (vars=year, fips(city), value)
tEm_Balt_LA_Year_Net<-melt(tEm_Balt_LA_Year)

#Plots data.
#Plotting them together finds to help the one with bigger changes (as requested)
#First plot contains the absolute values of emissions (net emissions). 
png(file="./plot6_net.png")
g<-ggplot(data=tEm_Balt_LA_Year_Net, aes(year, value))
g<-g+geom_point(aes(color=as.factor(fips)))
g<-g+geom_line(aes(color=as.factor(fips)))
g<-g+labs(x="Year", y=expression("Total "*PM[2.5]*" emissions (tons/year)"))
g<-g+labs(title=expression(PM[2.5]*" Net Emissions per year: Baltimore vs Los Angeles"))
g<-g + scale_x_continuous(breaks=unique(tEm_Balt_LA_Year_Net$year), labels=unique(tEm_Balt_LA_Year_Net$year))
dev.off()

#Second plot contains the values as normalized from their value in 1999.
#This gives an estimation of the % of change that has happened in these cities
#I believe it represents a more reliable measure of the 'change'.
tEm_Balt_LA_Year_Norm<-melt(tEm_Balt_LA_Year)
tEm_Balt_LA_Year_Norm$value[1:4]<-tEm_Balt_LA_Year_Norm$value[1:4]/tEm_Balt_LA_Year_Norm$value[1]
tEm_Balt_LA_Year_Norm$value[5:8]<-tEm_Balt_LA_Year_Norm$value[5:8]/tEm_Balt_LA_Year_Norm$value[5]

png(file="./plot6_relative.png")
g2<-ggplot(data=tEm_Balt_LA_Year_Norm, aes(year, value))
g2<-g2+geom_point(aes(color=as.factor(fips)))
g2<-g2+geom_line(aes(color=as.factor(fips)))
g2<-g2+labs(x="Year", y=expression("% "*PM[2.5]*" emissions per year (relative to 1999 levels"))
g2<-g2+labs(title=expression(PM[2.5]*" Relative Emissions per year: Baltimore vs Los Angeles"))
g2<-g2 + scale_x_continuous(breaks=unique(tEm_Balt_LA_Year_Norm$year),
                            labels=unique(tEm_Balt_LA_Year_Norm$year))
g2<-g2 + scale_fill_discrete(name="City", breaks=c("24510", "06037"), 
                            labels=c("Baltimore City", "Los Angeles"))
dev.off()