## Libraries needed:
library(plyr)
library(ggplot2)

## Step 1: read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Step 2: subset our data for only coal-combustion
coalcomb.scc <- subset(SCC, EI.Sector %in% c("Fuel Comb - Comm/Instutional - Coal",
                                             "Fuel Comb - Electric Generation - Coal", "Fuel Comb - Industrial Boilers, ICEs -
  Coal"))

## Step 3: comparisons to prevent ommissions
coalcomb.scc1 <- subset(SCC, grepl("Comb", Short.Name) & grepl("Coal", Short.Name))

nrow(coalcomb.scc) #evaluate: rows 0 -- 35

nrow(coalcomb.scc1) #evaluate: rows --  91

## Step 4: set the differences
dif1 <- setdiff(coalcomb.scc$SCC, coalcomb.scc1$SCC)
dif2 <- setdiff(coalcomb.scc1$SCC, coalcomb.scc$SCC)

length(dif1)  # 0 --- 6

length(dif2) # 91 --- 62

### We should look at the union of these sets
coalcomb.codes <- union(coalcomb.scc$SCC, coalcomb.scc1$SCC)
length(coalcomb.codes) # 91 --- 97

## Step 5: Repeat the subset again
coal.comb <- subset(NEI, SCC %in% coalcomb.codes)

##Step 6: Find PM25 values
coalcomb.pm25year <- ddply(coal.comb, .(year, type), function(x) sum(x$Emissions))

### Rename the columns
colnames(coalcomb.pm25year)[3] <- "Emissions"

##Step 7: Prepare plot4.png
png("plot4.png")
qplot(year, Emissions, data=coalcomb.pm25year, color=type, geom="line") + stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", color = "purple", aes(shape="total"), geom="line") + geom_line(aes(size="total", shape = NA)) + ggtitle(expression("Coal Combustion" ~ PM[2.5] ~ "Emissions by Source Type and Year")) + xlab("Year") + ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()

## Step 8: prepare to plot to markdown
qplot(year, Emissions, data=coalcomb.pm25year, color=type, geom="line") + stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", color = "purple", aes(shape="total"), geom="line") + geom_line(aes(size="total", shape = NA)) + ggtitle(expression("Coal Combustion" ~ PM[2.5] ~ "Emissions by Source Type and Year")) + xlab("Year") + ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
