#=-----------------------------------------------------=#
#                                                       #
#   plot2.R                                             #
#       by Matt                                         #
#   Use the base plotting system to make a plot showing #
#   the total PM2.5 emissions from Baltimore, MD, for   #
#   each of the years 1999, 2002, 2005, and 2008.       #
#                                                       #
#=-----------------------------------------------------=#

if(!file.exists("summarySCC_PM25.rds")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip", method = "curl")
    unzip("FNEI_data.zip")
    file.remove("FNEI_data.zip")
}

# PM2.5 Emissions Data (ummarySCC_PM25.rds)
# This file contains a data frame with all of the PM2.5 emissions data for 1999,
# 2002, 2005, and 2008. For each year, the table contains number of tons of 
# PM2.5 emitted from a specific type of source for the entire year.
NEI <- readRDS("summarySCC_PM25.rds")               # 6497651 x 6

# Source Classification Code Table (Source_Classification_Code.rds)
# This table provides a mapping from the SCC digit strings in the Emissions 
# table to the actual name of the PM2.5 source. The sources are categorized in a
# few different ways from more general to more specific and you may choose to
# explore whatever categories you think are most useful. For example, source 
# “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”.
SCC <- readRDS("Source_Classification_Code.rds")    # 11717 x 15

# sum Emission in NEI by year
x <- tapply(NEI$Emissions, NEI$year, sum)

png(file = "plot1.png")

plot(names(x), 
     x/1000, 
     type = "l",
     lwd = 2,
     col = "red", 
     main = "Emissions by Year", 
     xlab = "Year", 
     ylab = "Tons of PM2.5 (1000s)")

points(names(x), x/1000, pch=19)

dev.off()
