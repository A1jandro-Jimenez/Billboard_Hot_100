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
The dataset used for this project was obtained form verious diffrent sources including wikipedia, Spotify, Genius, and ChatGPT. Using python, I web scraped all five of the Bilboard Hot 100 Year End Charts from their indivual wikipedia page (https://en.wikipedia.org/wiki/Billboard_Year-End_Hot_100_singles_of_2020). The following code with used to obtain the chart table found on each page changeing only the URL to the corresponding chart year (i.e., 2020, 2021, ...) and saving the data as a csv file: 

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
To have a more focus driven analyisis of the dataset, I asked ChatGPT to provide somw questions about my dataset in order to help achive my goals. The following questions were chosen: 
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


 MySQL was used to find the answer to most of the questions with the exception of What features best predict a song having a better chart postion? A Multiple Linear Regression model was condcuted to see the factors that statsicaly contrubited to a song having a higher chart postion. The script as with a more detail explanasion about the thought process for each question can be found in the file....

The results of each question were stored a as csv files and exported to Power BI for visulization. As mentioned before a Power BI dashboard was created to demonstarae the results obtained. Furthermore, Python was also used to visulize ststical significany for the predictive/advanced analysis. The last few visuals were simple bar charts and scatter plots from Excel to showcase a few of the remainding questions. 

### Results and Conlusions 
![](https://github.com/A1jandro-Jimenez/Billboard_Hot_100/blob/main/regression%20coefficient%20plot.png?raw=true)
In order to determine the best features that predict a song having better chart postion, a Multiple Linear Regression model was use. In Python, code for the model was written up using variuous libraires and the results can be found in the file...The main variables used were number of artists, song length, log spotify streams, and genre type. 

The image above is a regression coefficinet plot that shows the coefficients from the model for each varible and hilights in gree the once that are statsticalaly siginficant (have a p value < 0.05). The three varabiles that were highlighted were log spotify streams, latin, and Christmas. Although latin and christmas are statsticaly siginifcant, their coefficients are postivie. In the context of our model a postive coefficient indecates a lower chart postion or a higher number, when the goal is to get closer to one. It is best to foucus on log spotify streams as it had a negative coffeicient meaning a higher chart postion or a lower number closer to one. 

A 1-unit increase in log(Spotify_Streams) (i.e., multiplying streams by ~2.718 or ~a 171% increase) is associated with a ~29 position improvement in chart rank (because the coefficient is -28.98).The negative sign tells us that higher Spotify stream counts strongly predict better chart positions (lower chart number = better).The very small p-value (< 0.001) means this relationship is statistically significant meaning very unlikley that it ocurred by chance. 
Songs with more Spotify streams tend to have better chart positions. Specifically, multiplying a song’s streams by a constant factor (e.g. 2x, 10x) is linked to a significantly higher chart rank, even after controlling for genre, song length, and number of artists.


Since billboard takes into account the number of streams a song accumulates to determine chart postion, the model should and does porovide statical evicnve that having a hiher streaming chart should imporvoe your postion on the charts as our plot and results shows. 

