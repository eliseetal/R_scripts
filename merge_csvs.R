# merge csvs --- 15th FEB 2021 --- EK 

# Script for combinining csvs in folder into one master csv file

# First, make sure the csvs you want to combine are all in the same folder, and that nothing else is in this folder.

# Load packages:

library(dplyr)
library(ggplot2)
library(yarrr)

# Create list of files in folder that you want to merge

my_files<- list.files("") #Update with whatever folder the csvs are in (need to put whole file 
# path if folder isn't within same folder as this script)

my_data<-data.frame() # Create empty data frame for combined data
nsub <- 30 # Change to your sample size (should match number of files you want to merge)

# Clean and combine csv files

for (i in 1:nsub)
  
{myfile<-my_files[i]
this.file<-read.csv(paste0("file/path/where/csvs/are",myfile))

# Change names of columns you want to select below
this.file<-select(this.file, Participant.Public.ID, Participant.Status, branch.k895, Spreadsheet, Trial.Number, Screen.Name, Zone.Type, Reaction.Time, 
                  Response, Correct, Timed.Out, display, spaceFix, cue, reward.magnitude, stim_type, threshold)
# this.file<- filter(this.file, Zone.Type == "response_button_text" | Zone.Type == "response_keyboard")

my_data<-rbind(my_data, this.file)
}

write.csv(my_data,"raw_merged_15APR21.csv")