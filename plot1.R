# Loads Data. Might take a few seconds
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#First, it generates the total values for every year. Using tapply's magic.
tEm<-tapply(NEI$Emissions, NEI$year, sum)

#Plots data.
png(file="./plot1.png", width=480, height=480)
par(las=1)
plot(names(tEm), tEm, type="p", pch=19, ylim=c(3e6, 8e6), col="blue",  xlab="Year",
     axes=F, las=1, ylab=expression("Total PM"[2.5] * " (Millions of tons/year)"),
     main=expression("Total PM"[2.5]*" Emissions Per Year (2000-2008) in the US"))
lines(names(tEm), tEm)
box()
#Labels dots. To simplify, annotation is on millions of tons
text(names(tEm), tEm, labels=round(tEm/1e6, 1), pos=3)
axis(side=2,at=seq(3e6, 8e6, 1e6), labels=seq(3, 8, 1))
axis(side=1,at=names(tEm))
#Closes
dev.off()