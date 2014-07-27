#Loads data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subsets the NEI to obtain the sources that come from Baltimore city AND from motor vehicles
#NOTE: I just assumed that any source of PM2.5 tagged as "on-road" is from a motor vehicle
#I know there are other sources that use motors (such as planes)
#but in plain English 'motor vehicle' refers to cars, buses, motorcycles, trucks...
#(see http://en.wikipedia.org/wiki/Motor_vehicle for more info)
NEIBaltimore<-NEI[NEI$fips=="24510",]
NEIBaltimore_Road<-NEIBaltimore[NEIBaltimore$type=="ON-ROAD", ]

tEmBalt_Road<-tapply(NEIBaltimore_Road$Emissions, NEIBaltimore_Road$year, sum)

#Plots data. This is very similar to plot 2.
png(file="./plot5.png", width=480, height=480)
par(las=1, mar = c(5, 5, 4, 4))
plot(names(tEmBalt_Road), tEmBalt_Road, type="p", pch=19, ylim=c(0, 360),
     col="blue",  xlab="Year", axes=F, ylab=expression("Total PM"[2.5] * " (tons/year)"),
     main=expression("Total PM"[2.5] * " Emissions per year from Motor Vehicles" * " in Baltimore City"))
lines(names(tEmBalt_Road), tEmBalt_Road)
#Labels dots. To simplify, annotation is on millions of tons
box()
text(names(tEmBalt_Road), tEmBalt_Road, labels=round(tEmBalt_Road, 0), pos=3)
axis(side=2)
axis(side=1,at=names(tEmBalt_Road))

#Closes
dev.off()