# #Loads data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Narrows the SCC NEI table to those coal-related
#I picked every SCC that had the word "coal" on the short name field
SCC_Coal<-SCC[grepl("[Cc]oal", SCC$Short.Name),]
NEI_Coal<-NEI[NEI$SCC %in% SCC_Coal$SCC,]

#Calculate total emissions
tEm_Coal<-tapply(NEI_Coal$Emissions, NEI_Coal$year, sum)

#Plots. This is quite similar to plot 1.
png(file="./plot4.png", width=480, height=480)
par(las=1, ylbias=1.2, mar=c(5, 6, 4, 4))

plot(names(tEm_Coal), tEm_Coal, type="p", pch=19, ylim=c(350000, 650000), col="blue", 
     xlab="Year", xlim=c(1998, 2009),
     axes=F, las=1, ylab=expression("Total PM"[2.5] * " (Millions of tons/year)"),
     main=expression("Total "* PM[2.5] *" Emissions per Year in the US from Coal-derived sources"))
lines(names(tEm_Coal), tEm_Coal)
box()
#Labels dots. To simplify, annotation is on millions of tons
text(names(tEm_Coal), tEm_Coal, labels=round(tEm_Coal, 0), pos=3)
axis(side=2)
axis(side=1,at=names(tEm_Coal))
#Closes
dev.off()