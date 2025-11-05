#  Billboard Hot 100 Year End Charts Analysis (2020-2024)
## Background
The *Billboard* Hot 100 Year End Chart is an annual list of the 100 most successful songs throughout the year in the Unitied States published by *Billboard* magazine and compiled by Nielsen SoundScan. Each week information about a single's physical and digital sales, as well as airplay and streaming is collected and used to determined its ranking on the weekly chart. At the end of each year, a list is published based on that year's best performing songs.
## Project Goals
When creating the project, I had the following goals in mind that I wanted to achive:
* Gather interesting/insightful information about the different songs and artists appearing on each year's chart. (i.e., Which artists appear the most?)
* Find trends within certain categories or throughout the years.
* Combine the two above to determine the characteristics that a song may need to have in order to rank well on the year end chart. <br>

With these findings, not only artists, but also record labels and others in the music industry, can use the the information to increases their chances
of having having a hit single or sign the next big artist all from analyzing the most sucessful songs of the past few years. 
## Process
### Data Collecting / Cleaning
The dataset used for this project was obtained form verious diffrent sources including wikipedia, Spotify, Genius, and ChatGPT. Using python, I web scraped all five of the Bilboard Hot 100 Year End Charts from their indivual wikipedia page (https://en.wikipedia.org/wiki/Billboard_Year-End_Hot_100_singles_of_2020). The following code was used to obtain the chart table found on each page changing only the URL to the corresponding chart year (i.e., 2020, 2021, ...) and saving the data as a csv file: 

``` Python
#import the necessary libraries

from bs4 import BeautifulSoup
import requests 
#get url for website

url = 'https://en.wikipedia.org/wiki/Billboard_Year-End_Hot_100_singles_of_2020'

page = requests.get(url)

soup = BeautifulSoup(page.text, "html")
soup.find_all("table")[0]

table = soup.find_all("table")[0]

world_titles = table.find_all("th")

world_table_titles = [title.text.strip() for title in world_titles]

print(world_table_titles)

import pandas as pd 

df = pd.DataFrame(columns = world_table_titles)

df

column_data = table.find_all('tr')

for row in column_data[1:]:
    row_data = row.find_all("td")
    indv_row_data = [data.text.strip() for data in row_data]
    
    length = len(df)
    df.loc[length]=indv_row_data

df

df.to_csv(r"C:\Users\alejh\OneDrive\Desktop\Data_Analyst_Practice_and_Projects\Data_Analysis_Project_Billboard\Billboard Year End 2020",index = False)
```
The table found on wikipedia only conatined information about rank, song title, and artists. In order to obtained the length of each song, the album it appeared on, and the number of streams a song had, Spotify was used. Information regarding released date for each song was found using Genius (https://genius.com/). Finally ChatGPT was used to find the genre of each song. The saved csv file was uploaded to MySQL to insert the missing information manually with a script similar to the following: 

```SQL
Update song_info_table
Set Song_Length = 200 ,
	Album = "After Hours", 
    Spotify_Streams = 4703486206
Where Title = 'Blinding Lights'; 

```
In order to make the analyzing process easier, I applied my basic knowldgde of data normazlation and created a refrance table for both the artists and genres to avoid redudancy. Primary and foregin keys were given to all the tables created for easier analzysis. This gave us a complete song dataset with all the songs information, an artists refrance table, and a genres refreance table. 
### Analysis/Visulization
To have a more focus driven analyisis of the dataset, I asked ChatGPT to provide some questions about my dataset in order to help achive my goals. The following questions were chosen: 
#### Descriptive Analysis
1. What are the most common genres represented in the Year-End Hot 100?
2. Which artists appear most frequently on the list?
3. What is the distribution of song ranks for solo artists vs. collaborations?
4. Which album contains the most entries across all five years?
#### Trend Analysis
1. Are certain genres becoming more or less popular over time?
2. Are collaborations becoming more frequent on the chart over time?
#### Artist and Song-Level Analysis
1. What is the relationship between song duration and its rank on the Year-End chart?
2. How does the number of featured artists correlate with chart success?
#### Comparative Analysis
1. How does the average rank differ between rap, pop, and country songs?
#### Predictive/Advanced Analysis
1. What features best predict a song having a better chart postion?


 MySQL was used to find the answers to most of the questions with the exception of what features best predict a song having a better chart postion? A Multiple Linear Regression model was condcuted to see the factors that statistically contrubited to a song having a higher chart postion. The script as well as more detail explanation about the thought process for each question can be found in the file Script_for_Billboard_Questions. 

The results of each question were stored a as csv files and exported to Power BI for visulization. As mentioned before a Power BI dashboard was created to demonstarae the results obtained. Furthermore, Python was also used to visulize statistically significancy or the predictive/advanced analysis. The last few visuals were simple bar charts and scatter plots from Excel to showcase a few of the remaining questions. 

## Results 
![](https://github.com/A1jandro-Jimenez/Billboard_Hot_100/blob/main/regression%20coefficient%20plot.png?raw=true)
In order to determine the best features that predict a song having better chart postion, a Multiple Linear Regression model was use. In Python, code for the model was written up using various libraires and the results can be found in the file OLS_Regression_Results_Billboard. The main variables used were number of artists, song length, log spotify streams, and genre type. 

The image above is a regression coefficinet plot that shows the coefficients from the model for each varible and highlights in green the ones that are statsticalaly siginficant (have a p value < 0.05). The three varabiles that were highlighted were log spotify streams, latin, and Christmas. Although latin and christmas are statsticaly siginifcant, their coefficients are postivie. In the context of our model a postive coefficient indecates a lower chart postion or a higher number, when the goal is to get closer to one. It is best to foucus on log spotify streams as it had a negative coffeicient meaning a higher chart postion or a lower number closer to one. 

A 1-unit increase in log(Spotify_Streams) (i.e., multiplying streams by ~2.718 or ~a 171% increase) is associated with a ~29 position improvement in chart rank (because the coefficient is -28.98).The negative sign tells us that higher Spotify stream counts strongly predict better chart positions (lower chart number = better).The very small p-value (< 0.001) means this relationship is statistically significant meaning very unlikley that it ocurred by chance. 
Songs with more Spotify streams tend to have better chart positions. Specifically, multiplying a song’s streams by a constant factor (e.g. 2x, 10x) is linked to a significantly higher chart rank, even after controlling for genre, song length, and number of artists.


Since billboard takes into account the number of streams a song accumulates to determine chart postion, the model should and does provide statistical evidence that having a hiher streaming count should improve your postion on the charts as our plot and results show. 

![](https://github.com/A1jandro-Jimenez/Billboard_Hot_100/blob/main/Billboard%20Dashboard.png?raw=true)

MySQL was used to answer the remamimg questions and the full script can be found with the name .... In order to communicate the answers in a more facile manner, a simple dashboard was made in Power BI which is shown above. 

Some key takeaways:
1. Drake, Morgan Wallen, Doja Cat, Justin Biber, and Luke Combs are the top five artists that have appear the most as both a main and a feature artsist across the past four years on the charts.
2. Problably the most useful trend is that of the song count based on genre over the years. In 2020, Hip-Hop/rap had 40 songs on the Billboard Hot 100 Year End Chart. Fast fowrd to 2024 and only about 10 songs out of 100 are Hip-Hop/rap, a significant drop. On the other hand, country music as well as indie pop have had significant rises as the chart displays. This is also sppourted by both Morgan Wallen and Luke Combs being some of the artists that appear on the charts the most.
3. About 70% of the songs that were ranked 1-25 where actually solo prefomaces and as the number of artists increased the percatnge of songs dcreased. This is ture across all chart postion groups. Graph fully displies that 1 artist songs make up most of the songs across all four years.
4. Collabortions over time tend to not be as popular as the amount of solo artsits songs just seems to be increasing as the time increased.
5. The genres with the most appearnces across all four years were pop, Hip-Hop, and Country. Those genres have defiend the beining of the decade so far.
6. The albumn with the most disticnt song entries has ben Un Verano Sin Ti by Bad Bunny with a total of seven different songs from the album all making it on the charts.

 ![](https://github.com/A1jandro-Jimenez/Billboard_Hot_100/blob/main/Genre_Vs_ACP.png?raw=true)
 
![](https://github.com/A1jandro-Jimenez/Billboard_Hot_100/blob/main/Screenshot%202025-09-26%20171507.png?raw=true)

The graph titled Gerne and Avergae Chart Position, shows the average chart position across all the top genres. The average chart positions range from about 40 - 60 providing a 20 range gap across the genres. The results from the multiple linear regression model along with the graph support the claim that there is no statistical evidence that a speficic genre offers a better chart postion. 

The graph titled Affect of Song Length on Chart Position, shows a couple of things. The first is that R^2 is apporxemenly 0. It illstues the proportion of the variation in the dependent variable (chart position) that is predictable from the independent variable (song length) is zero. Since it is almsot zero, it means that there is almost zero corleation between song lenth and chart position. The second finding is that most of the data points lay around the 200 seconds mark. It was found that average song length was around 197 seconds which is around 3 minutes and 17 seconds, so the graph demonstrates just that. Finally, about 99% of all song entries fall between the range of 100 to 300 seconds or 1 min 40 s to 5 mins. Only six songs are outside the given range. The evidance illustares the ideal song length range of the most popular and successful songs of the decade so far. 

## Conclusions
The information and insights found in this analysis can be useful to many people inlcuding artists, record labels, and the genral public. Artists and record labels can use the information to try to make a chart topping song that will last the whole year. Record labels and artists can gain more profits by following trends that could increase their sells and increase in poularity. Currently pop, country, and indie pop are some of the most rapidily growing and steady genres. Making a song that falls into these genres will help get more streams which can translate to more sells. Some of the most popular artists include Drake, Morgan Wallen, Luke Combs, Bad Bunny among others. A collaberation with any of these will help boost up sales and streams once again leading to more profits for both the artists and labels. As for the general public, the information can help people reach a larger audiance if a song or artist is popular, it can be use in a soical media post to increase views. Analyzing music charts and trends can help many people as music is a big part of our everyday lives. I hope to continue exploring more data to help others understand the bigger picture and make meaningful decisions. 
