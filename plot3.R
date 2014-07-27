#loads required libraries
library(reshape2)
library(ggplot2)

#Loads data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#narrows to baltimore city-only
NEIBaltimore<-NEI[NEI$fips=="24510",]

#Uses the magic of tapply to obtain total emissions per source type and per year
tEmTypeYear<-tapply(NEIBaltimore$Emissions, NEIBaltimore[,c("year", "type")], sum)

#Melt will convert this data matrix (year x type) into a data frame (vars=year, type, value)
tEmTypeYear<-melt(tEmTypeYear)

#Plots data.
#I chose to align them horizontally as that way user can also compare emission values between sources.
png(file="./plot3.png", width=960, height=480)
g<-ggplot(data=tEmTypeYear, aes(year, value))+facet_grid(.~type)
g<-g+geom_line(aes(color=type))
g<-g+geom_point(aes(color=type)) + theme(legend.position = "none")
g<-g+labs(x="Year", y=expression("Total "*PM[2.5]*" emissions (tons/year)"))
g<-g+labs(title=expression(PM[2.5]*" Emissions in Baltimore city (per source type per year)"))
g<-g + scale_x_continuous(breaks=unique(tEmTypeYear$year), labels=unique(tEmTypeYear$year))
g
#closes
dev.off()