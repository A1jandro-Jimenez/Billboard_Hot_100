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
In order to make the analyzing process easier, I applied my basic knowldgde of data normazlation and created a refrance table for both the artists and genres to avoid redudancy. Primary and foregin keys were given to all the tables created for easier analzysis. This gave us a complete song dataset with all the song information, an artists refrance table, and a genres refreance table. 
