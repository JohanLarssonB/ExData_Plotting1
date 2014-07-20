## Load required libraries
library(data.table)

## Set variables
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

## Download and unzip file to working directory
## http://stackoverflow.com/questions/15226150/r-exdir-does-not-exist-error

## Create a temporary file
temp <- tempfile()
## Download ZIP archive into temporary file
download.file(fileUrl,temp)
unzip(temp)
## Delete the temp file
close(temp)
unlink(temp)

## Read text file to data table
## Read list of all "*.txt" files in directory 
file <- list.files(path=".", pattern="*.txt")
## Read into data using fread()
## data <- fread(file)
## Read into data using data.table
data <- read.table(file, sep=";", header=TRUE, na.strings = "?", colClasses = "character")

## Add new column Datetime 
data$Datetime <- strptime(paste(data$Date, data$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
## Convert data$Date from character to Date (from "16/12/2006")
data$Date<- as.Date(data$Date,"%d/%m/%Y")

## Convert Global_active_power, Global_reactive_power, Voltage and Global_intensity
## to numeric values
data$Global_active_power <- as.numeric(data$Global_active_power)
data$Global_reactive_power <- as.numeric(data$Global_reactive_power)
data$Voltage <- as.numeric(data$Voltage)
data$Global_intensity <- as.numeric(data$Global_intensity)

## Convert Sub_metering_1, Sub_metering_2 and Sub_metering_3
## to integer values
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

## Create index to subset 2007-02-01 and 2007-02-02
index <- data$Date == "2007-02-01" | data$Date == "2007-02-02"
## Check that index is reasonable, i.e number of TRUE is equal to 2*1440 
table(factor(index))

## Plot 2
## Plot timeline Thursday and Friday
png(filename="plot2.png")
plot(data$Datetime[index], data$Global_active_power[index],
     typ='l',
     main = "",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")
dev.off()
