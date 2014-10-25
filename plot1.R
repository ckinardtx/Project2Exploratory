source('setup.R')
library(plyr)
## Step 1: read in the data
if (!exists('NEI')) {
        NEI <- readRDS("summarySCC_PM25.rds")
}

emissions <- ddply(NEI, 'year', summarize, tot=sum(Emissions))

##Step 2: prepare to plot to png
png(filename='plot1.png')
plot(emissions,
     xlab='Year',
     ylab=expression('Total PM'[2.5]*' Emissions (tons)'),
     main=expression('US Total PM'[2.5]*' Emissions'),
     type='l')
points(emissions, pch=16, cex=2)
dev.off()