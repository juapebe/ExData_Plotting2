# Loads Data. Might take a few seconds
#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

#First, it generates the total values for every year in Baltimore. Using tapply's magic.
NEIBaltimore<-NEI[NEI$fips=="24510",]
tEmBalt<-tapply(NEIBaltimore$Emissions, NEIBaltimore$year, sum)

#Plots data.
png(file="./plot2.png", width=480, height=480)
par(las=1)
plot(names(tEmBalt), tEmBalt, type="p", pch=19, ylim=c(0, 4000),
     col="blue",  xlab="Year", axes=F, ylab=expression("Total PM"[2.5] * " (tons/year)"),
     main=expression("Total PM"[2.5] * " Emissions (1999-2008)" * " in Baltimore City"))
lines(names(tEmBalt), tEmBalt)
#Labels dots. To simplify, annotation is on millions of tons
box()
text(names(tEmBalt), tEmBalt, labels=round(tEmBalt, 0), pos=3)
axis(side=2,at=seq(0, 4000, 1000), labels=seq(0, 4000, 1000))
axis(side=1,at=names(tEmBalt))

#Closes
dev.off()