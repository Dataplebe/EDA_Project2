#=-----------------------------------------------------=#
#                                                       #
#   plot3.R                                             #
#       by Matt                                         #
#   Use the ggplot2 plotting system to make a plot      #
#   which of the four types of sources indicated by     #
#   type in summarySCC_PM25.rds (point, nonpoint,       #
#   onroad, offroad) have seen decreases or increases   #
#   in emissions from 1999-2008 for Baltimore City, MD. #
#                                                       #
#=-----------------------------------------------------=#

# require dplyr and ggplot2 libraries
require(dplyr)
require(ggplot2)

if(!file.exists("summarySCC_PM25.rds")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip", method = "curl")
    unzip("FNEI_data.zip")
    file.remove("FNEI_data.zip")
}

# PM2.5 Emissions Data (summarySCC_PM25.rds)
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

# sum Emission in NEI by year and type for fips == 24510 (Baltimore, MD)
x <- filter(NEI, fips == 24510) %>%
  group_by(type, year) %>%
  summarise(Emissions = sum(Emissions))

# open png graphic device
png(file = "plot3.png")

# create plot
xplot <- ggplot(x, aes(x = year, y = Emissions))

# Display plot in a 4x4 grid, one for each type of pollution with a line showing
# increase or decrease over years.
print(
  xplot + geom_point() + geom_smooth(method = "lm", se = FALSE) + facet_wrap(~type, ncol = 2)
)
dev.off()
