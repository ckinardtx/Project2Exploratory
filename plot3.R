library(plyr)
library(ggplot2)
# Read the data file
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

BaltimoreCity <- subset(NEI, fips == "24510")

typePM25ByYear <- ddply(BaltimoreCity, .(year, type), function(x) sum(x$Emissions))
colnames(typePM25ByYear)[3] <- "Emissions"

png("plot3.png")
qplot(year, Emissions, data=typePM25ByYear, color=type, geom="line") +
        ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Emissions by Source Type and Year")) +
        xlab("Year") +
        ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()