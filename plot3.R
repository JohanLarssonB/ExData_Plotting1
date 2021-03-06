## Load required libraries
library(data.table)

## Download and unzip / read file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile='hpc.zip', method = 'curl')
data<-read.csv2(unz('hpc.zip', 'household_power_consumption.txt'), colClasses = "character", na.strings='?', quote="")

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
data$Sub_metering_1 <- as.integer(data$Sub_metering_1)
data$Sub_metering_2 <- as.integer(data$Sub_metering_2)
data$Sub_metering_3 <- as.integer(data$Sub_metering_3)

## Create index to subset 2007-02-01 and 2007-02-02
index <- data$Date == "2007-02-01" | data$Date == "2007-02-02"
## Check that index is reasonable, i.e number of TRUE is equal to 2*1440 
table(factor(index))

## Plot 3
## Plot timeline for Sub_metering_1/2/3
## Open png file as grapgics device
png(filename="plot3.png")
## Plot first line
plot(data$Datetime[index], data$Sub_metering_1[index],
     typ='l',
     main = "",
     xlab = "",
     ylab = "Energy sub metering"
)
## Add second and third lines
lines(data$Datetime[index], data$Sub_metering_2[index],col = "red")
lines(data$Datetime[index], data$Sub_metering_3[index],col = "blue")
## Add legende in topright corner
legend("topright", lty = 1, 
       col = c("black", "red", "blue"), 
       legend = names(data[7:9])
)
dev.off()
