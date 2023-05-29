# EK - Vocal Familiarity Prescreen Summary ----- May 2023 
# This script merges and cleans the data from the Vocal Familiarity Prescreen task that collects
# demographic information from participants 

# Clear environment and load packages
rm(list = ls(all = TRUE))
library(dplyr)
library(tidyr)
library(stringr)
library(tuneR)
# library(soundgen)
library(lubridate)
options(scipen = 999)


# Set directory to data location
BehavDir <- "~/Filestore/Research3/SHaPS/VoCoLab(Carolyn_McGettigan)/FAMILIARITY_RSA/Behavioural/0_prescreen"
#BehavDir <- "~/Desktop/rtMRI/5_Behavioural/3_LifestyleQuestionnaire/" # Uncomment if working on laptop
if (file.exists(BehavDir)){
  setwd(BehavDir)
} else {
  BehavDir <- paste0("/Volumes/Research3/SHaPS/VoCoLab(Carolyn_McGettigan)/FAMILIARITY_RSA/Behavioural/0_prescreen")
}

setwd(BehavDir)

# FindFolders <- list.dirs(recursive=FALSE). # List the folders in the directory 
# FindFolders <- gsub("./", "", FindFolders) # Remove the string './' from the beginning of the filenames 

# for (a in 1:length(FindFolders)){
# ListFiles <- list.files(paste0(BehavDir, '/', FindFolders[a]),recursive=TRUE)
# }

list <- list.files(BehavDir, pattern="oj3g", recursive = TRUE) # list all the files in the folders in the directory and only keep the ones where the file name contains this pattern
listfiles <- as_tibble(list) # Turn this list into a tibble for easy readability 


data<-data.frame() # Create empty data frame for combined data
nsub <- nrow(listfiles) # how many files you want to merge

# Clean and combine csv files

for (i in 1:nsub) {
  
# {myfile<-listfiles[i]
this.file<-read.csv(paste0(BehavDir, '/', list[i]))

# Change names of columns you want to select below
this.file<-select(this.file, Participant.Public.ID, Task.Version, Question.Key, Response)
# this.file<- filter(this.file, Zone.Type == "response_button_text" | Zone.Type == "response_keyboard")

data<-rbind(data, this.file)

data <- na.omit(data)
}


# Transform the data from long to wide format (new column for each response rather than )

data_wide <- data %>% spread(Question.Key, Response)


# Read in a spreadsheet that includes the email address of the participant and their associated DIAPIX/Scanner ID. 

IDs <- read.csv(paste0(BehavDir, "/pp_ids.csv"))


# Use inner_join() to create two new columns with the participant ID. This should also drop participants that did not actually take part in the full experiment. 

joined <- inner_join(data_wide, IDs, by="email") 


# Remove columns we don't want (e.g. email addresses, extra info)

data <- joined %>% select(c(-`BEGIN QUESTIONNAIRE`, -`END QUESTIONNAIRE`, -email, -`DOB-day`, -`DOB-month`, -`frequency-speaking-quantised`, -`partner-email`, -partner.email, 
                            -`relationship-length-quantised`, -`relationship-quantised`, -`response-2-1`, -`response-2-2`, -`time-speaking-quantised`))

# rename some columns
colnames(data)[colnames(data) == "DOB-year"] <- "age"
colnames(data)[colnames(data) == "response-1"] <- "SSBE"
colnames(data)[colnames(data) == "response-1-quantised"] <- "SSBE-quantised"
colnames(data)[colnames(data) == "response-1-text"] <- "SSBE-text"
colnames(data)[colnames(data) == "Participant.Public.ID"] <- "gorilla-id"


# Save as a summary spreadsheet
write.csv(data, "0_prescreen_summary.csv")


warning("If there is any missing data, make sure the most recent version of the task on Gorilla has been downloaded (Prescreen task can be found here: https://app.gorilla.sc/admin/experiment/105760/)")

