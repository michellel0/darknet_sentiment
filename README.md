**Project Overview**
The project investigates the impact of different types of controlled substances (stimulants, depressants, and psychedelics) on the sentiment of darknet product reviews. The study aims to understand how the classification of a drug influences the positivity or negativity of user reviews, providing insights that could inform public health and substance abuse treatment policies.

This research project was conducted for SOCI 318, taught by Professor Scott Duxbury at UNC's Department of Sociology.

**Research Question**
Does buying stimulants or psychedelics from the dark net increase the likelihood of positive reviews when compared to depressants?

**Data Source**
The project utilizes the "darknet_text" dataset from the SOCI 318 class (not included in this repository). The dataset includes 4,033 entries with information on buyer, seller, date, rating, price in USD, review text, and meta category (product type). 

**Methodology**
- The dataset was divided into three categories based on drug type: stimulants, depressants, and psychedelics.
- Sentiment analysis was conducted using the AFINN lexicon to quantify the sentiment of the reviews.
- T-tests were performed to compare the mean net tones of the reviews across the three drug categories to determine if there were statistically significant differences in sentiment.

**Results**
- Depressants had the highest mean net tone (3.178) and positive sentiment (3.619), suggesting more positive reviews compared to stimulants and psychedelics.
- Stimulants had a mean net tone of 2.868, with a wide range of sentiment (-17 to 18).
- Psychedelics had the lowest mean net tone (2.503) and the narrowest range of positive sentiment (0 to 16).

**Key Findings:**
- No statistically significant difference was found between stimulant and depressant reviews (p-value = 0.05628).
- No statistically significant difference was found between stimulant and psychedelic reviews (p-value = 0.05467).
- A statistically significant difference was found between depressant and psychedelic reviews (p-value = 0.004381), with depressants having more positive reviews.

**Files Included****
- README.md: This file, providing an overview of the project.
- SOCI_318_Final_Code: the R code
