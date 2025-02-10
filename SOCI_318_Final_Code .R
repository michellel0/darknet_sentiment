rm(list = ls())
#SOCI 318 Final Project 

#Goal of the project: analyze whether drug classification -- stimulant, depressant, psychedelic -- impacts positivity of reviews of darknet purchases and then use T-tests to compare sentiment
#Data: a dataset of purchases from the dark net
#Methods: AFINN lexicon, sentiment analysis, natural language processing

#set up
setwd("/Users/michelleliu/Documents/UNC/Fall 2024/SOCI 318/Final Project")
load("/Users/michelleliu/Documents/UNC/Fall 2024/SOCI 318/Final Project/Darknet sales reviews.RData")

#install.packages("dplyr")
library(dplyr)
#install.packages("tidytext")
library(tidytext)
#install.packages("textdata")
library(textdata)


#analyze categories of products in the data set
table(darknet_text$meta_category)

#We only need the psychedelics, depressants, and stimulants
#get rid of all the categories not needed 
darknet_text <- darknet_text[!darknet_text$meta_category %in% c("Accounts", "Banks", "Bulk", "CC/CVV", "Counterfeits", "Concentrates", "Dumps", "eBooks", "Others", "PayPal", "Scans", "Services", "Pills", "Unknown", "RC", "Seeds", "Edibles", "Hash", "Weed", "MDMA", "Steroid", "Viagra"), ]

#making new column for drug type
darknet_text$drug_type <- NA
darknet_text$drug_type[darknet_text$meta_category %in% c("2C", "4-ACO-DMT","DMT", "Ketamine", "LSD", "Mushrooms")] <- "Psychedelic"
darknet_text$drug_type[darknet_text$meta_category %in% c("Adderall","Cocaine", "Dexedrine", "Ecstasy", "Mephedrone", "Meth","Methadone", "Modafinil", "Ritalin", "Speed", "Vyvanse")] <- "Stimulant"
darknet_text$drug_type[is.na(darknet_text$drug_type)] <- "Depressant"

#creating subsets
#stimulant subset
stimulant_subset <- darknet_text %>% 
  filter(drug_type == "Stimulant")

#break it down into words, group by sales review
stimulant_words <- stimulant_subset %>%
  mutate(sales_review = row_number()) %>% ##group by sales
  ungroup() %>%
  unnest_tokens(word, review_text) 

head(stimulant_words)

#depressant subset
depressant_subset <- darknet_text %>% 
  filter(drug_type == "Depressant")

#break it down into words, group by sales review
depressant_words <- depressant_subset %>%
  mutate(sales_review = row_number()) %>% ##group by sales
  ungroup() %>%
  unnest_tokens(word, review_text) 

#psychedelic subset
psychedelic_subset <- darknet_text %>% 
  filter(drug_type == "Psychedelic")

#break it down into words, group by sales review
psychedelic_words <- psychedelic_subset %>%
  mutate(sales_review = row_number()) %>% ##group by sales
  ungroup() %>%
  unnest_tokens(word, review_text) 
  
#stimulant afinn
afinn <- get_sentiments("afinn")
stimulant_afinn<-merge(stimulant_words, afinn,all.x=TRUE)


###create numeric metrics
stimulant_afinn$value[is.na(stimulant_afinn$value)]<-0

##create negative sentiment measure
stimulant_afinn$negative_sentiment<-0
stimulant_afinn$negative_sentiment[stimulant_afinn$value<0]<-stimulant_afinn$value[stimulant_afinn$value<0]

##create positive sentiment measure
stimulant_afinn$positive_sentiment<-0
stimulant_afinn$positive_sentiment[stimulant_afinn$value>0]<-stimulant_afinn$value[stimulant_afinn$value>0]

#return to sales review level
negative_stimulant<-aggregate(negative_sentiment~sales_review+Buyer+Seller+Date,FUN=sum,data=stimulant_afinn)
positive_stimulant<-aggregate(positive_sentiment~sales_review+Buyer+Seller+Date,FUN=sum,data=stimulant_afinn)
stimulant_transactions<-aggregate(value~sales_review+Buyer+Seller+Date,FUN=sum,data=stimulant_afinn)
stimulant_transactions$negative_sentiment<-negative_stimulant$negative_sentiment
stimulant_transactions$positive_sentiment<-positive_stimulant$positive_sentiment
colnames(stimulant_transactions)[5]<-"net_tone"

#histograms
hist(stimulant_transactions$net_tone, main = "Histogram of Stimulant Net Tone", xlab = "Sentiment Values",ylab = "Frequency")
hist(stimulant_transactions$positive_sentiment, main = "Histogram of Stimulant Positive Tone", xlab = "Sentiment Values",ylab = "Frequency")
hist(stimulant_transactions$negative_sentiment, main = "Histogram of Stimulant Negative Tone", xlab = "Sentiment Values" ,ylab = "Frequency")

#summary statistics
mean(stimulant_transactions$net_tone)
mean(stimulant_transactions$positive_sentiment)
mean(stimulant_transactions$negative_sentiment)

range(stimulant_transactions$net_tone)
range(stimulant_transactions$positive_sentiment) 
range(stimulant_transactions$negative_sentiment)

sd(stimulant_transactions$net_tone)
sd(stimulant_transactions$positive_sentiment)
sd(stimulant_transactions$negative_sentiment)

#outliers? 
stimulant_transactions$review_text <- stimulant_subset[stimulant_transactions$sales_review, ]
stimulant_transactions[stimulant_transactions$positive_sentiment==18,]
stimulant_transactions[stimulant_transactions$negative_sentiment==-17,]


#Depressant analysis
depressant_afinn<-merge(depressant_words, afinn,all.x=TRUE)

###create numeric metrics
depressant_afinn$value[is.na(depressant_afinn$value)]<-0

##create negative sentiment measure
depressant_afinn$negative_sentiment<-0
depressant_afinn$negative_sentiment[depressant_afinn$value<0]<-depressant_afinn$value[depressant_afinn$value<0]

##create positive sentiment measure
depressant_afinn$positive_sentiment<-0
depressant_afinn$positive_sentiment[depressant_afinn$value>0]<-depressant_afinn$value[depressant_afinn$value>0]

#return to sales review level
negative_depressant<-aggregate(negative_sentiment~sales_review+Buyer+Seller+Date,FUN=sum,data=depressant_afinn)
positive_depressant<-aggregate(positive_sentiment~sales_review+Buyer+Seller+Date,FUN=sum,data=depressant_afinn)
depressant_transactions<-aggregate(value~sales_review+Buyer+Seller+Date,FUN=sum,data=depressant_afinn)
depressant_transactions$negative_sentiment<-negative_depressant$negative_sentiment
depressant_transactions$positive_sentiment<-positive_depressant$positive_sentiment
colnames(depressant_transactions)[5]<-"net_tone"

#histograms
hist(depressant_transactions$net_tone, main = "Histogram of Depressant Net Tone", xlab = "Sentiment Values",ylab = "Frequency")
hist(depressant_transactions$positive_sentiment, main = "Histogram of Depressant Positive Tone", xlab = "Sentiment Values",ylab = "Frequency")
hist(depressant_transactions$negative_sentiment, main = "Histogram of Depressant Negative Tone", xlab = "Sentiment Values" ,ylab = "Frequency")

#summary statistics
mean(depressant_transactions$net_tone)
mean(depressant_transactions$positive_sentiment)
mean(depressant_transactions$negative_sentiment)

range(depressant_transactions$net_tone)
range(depressant_transactions$positive_sentiment) 
range(depressant_transactions$negative_sentiment)

sd(depressant_transactions$net_tone)
sd(depressant_transactions$positive_sentiment)
sd(depressant_transactions$negative_sentiment)

#outliers? 
depressant_transactions$review_text <- depressant_subset[depressant_transactions$sales_review, ]
depressant_transactions[depressant_transactions$positive_sentiment==21,]
depressant_transactions[depressant_transactions$negative_sentiment==-9,]


#psychedelic analysis
psychedelic_afinn<-merge(psychedelic_words, afinn,all.x=TRUE)

###create numeric metrics
psychedelic_afinn$value[is.na(psychedelic_afinn$value)]<-0

##create negative sentiment measure
psychedelic_afinn$negative_sentiment<-0
psychedelic_afinn$negative_sentiment[psychedelic_afinn$value<0]<-psychedelic_afinn$value[psychedelic_afinn$value<0]

##create positive sentiment measure
psychedelic_afinn$positive_sentiment<-0
psychedelic_afinn$positive_sentiment[psychedelic_afinn$value>0]<-psychedelic_afinn$value[psychedelic_afinn$value>0]

#return to sales review level
negative_psychedelic<-aggregate(negative_sentiment~sales_review+Buyer+Seller+Date,FUN=sum,data=psychedelic_afinn)
positive_psychedelic<-aggregate(positive_sentiment~sales_review+Buyer+Seller+Date,FUN=sum,data=psychedelic_afinn)
psychedelic_transactions<-aggregate(value~sales_review+Buyer+Seller+Date,FUN=sum,data=psychedelic_afinn)

psychedelic_transactions$negative_sentiment<-negative_psychedelic$negative_sentiment
psychedelic_transactions$positive_sentiment<-positive_psychedelic$positive_sentiment
colnames(psychedelic_transactions)[5]<-"net_tone"

#histograms
hist(psychedelic_transactions$net_tone, main = "Histogram of Psychedelic Net Tone", xlab = "Sentiment Values", ylab = "Frequency")
hist(psychedelic_transactions$positive_sentiment, main = "Histogram of Psychedelic Positive Tone", xlab = "Sentiment Values",ylab = "Frequency")
hist(psychedelic_transactions$negative_sentiment, main = "Histogram of Psychedelic Negative Tone", xlab = "Sentiment Values" ,ylab = "Frequency")

#summary statistics
mean(psychedelic_transactions$net_tone)
mean(psychedelic_transactions$positive_sentiment)
mean(psychedelic_transactions$negative_sentiment)

range(psychedelic_transactions$net_tone)
range(psychedelic_transactions$positive_sentiment) 
range(psychedelic_transactions$negative_sentiment)

sd(psychedelic_transactions$net_tone)
sd(psychedelic_transactions$positive_sentiment)
sd(psychedelic_transactions$negative_sentiment)

#outliers? 
psychedelic_transactions$review_text <- psychedelic_subset[psychedelic_transactions$sales_review, ]
psychedelic_transactions[psychedelic_transactions$positive_sentiment==16,]
psychedelic_transactions[psychedelic_transactions$negative_sentiment==-11,]


#t-test 
stimulant_net_tone <- stimulant_transactions$net_tone
depressant_net_tone <- depressant_transactions$net_tone
psychedelic_net_tone <- psychedelic_transactions$net_tone

t_test_stimulant_stim_dep<- t.test(stimulant_net_tone, depressant_net_tone,alternative = "two.sided", var.equal = TRUE)

t_test_stimulant_psy_stim<- t.test(stimulant_net_tone, psychedelic_net_tone, alternative = "two.sided", var.equal = TRUE)

t_test_depressant_psy_dep <- t.test(depressant_net_tone, psychedelic_net_tone, alternative = "two.sided", var.equal = TRUE)



