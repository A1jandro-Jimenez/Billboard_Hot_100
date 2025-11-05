/* 
1. To answer the question: What are the most common genres represented in the Year-End Hot 100? 
The genre count was obtain for each unqiue song once excluding multiple entries of same song. 
 */

Select 
	count(distinct Title) Genre_Apperances, 
	genres_table.Genre_Type
from complete_song_table
	join genres_table
		on complete_song_table.Genre_ID = genres_table.Genre_ID
group by genres_table.Genre_Type
order by Genre_Apperances desc;



/* 2. To obtain Which artists appear most frequently on the list? */
SELECT 
  a.Artist_Name,
  COUNT(*) AS appearance_count
FROM complete_song_table s
JOIN artists_reference_table a 
  ON s.Main_ArtistOne_ID = a.Artist_Id
  OR s.Main_ArtistTwo_ID = a.Artist_Id
  OR s.Main_ArtistThree_ID = a.Artist_Id
  OR s.Main_ArtistFour_ID = a.Artist_Id
  or s.Featured_ArtistOne_ID = a.Artist_Id
  or s.Featured_ArtistTwo_ID = a.Artist_Id
  or s.Main_ArtistThree_ID = a.Artist_Id
GROUP BY a.Artist_Id, a.Artist_Name
ORDER BY appearance_count DESC;


/* 3. What is the distribution of song ranks for solo artists vs. collaborations?*/

Select Num_of_Artists, count(Num_of_Artists) Art_Count
From complete_song_table
Where Chart_Position between 1 and 25
Group by Num_of_Artists
order by Art_Count desc;

Select Num_of_Artists, count(Num_of_Artists) Art_Count
From complete_song_table
Where Chart_Position between 26 and 50
Group by Num_of_Artists
order by Art_Count desc;

Select Num_of_Artists, count(Num_of_Artists) Art_Count
From complete_song_table
Where Chart_Position between 51 and 75
Group by Num_of_Artists
order by Art_Count desc;

Select Num_of_Artists, count(Num_of_Artists) Art_Count
From complete_song_table
Where Chart_Position between 76 and 100
Group by Num_of_Artists
order by Art_Count desc;



/* 4. Are certain genres becoming more or less popular over time?  */

Select 
	GT.Genre_Type,
	Count(*) AS song_count
From complete_song_table CST
Join genres_table GT
on CST.Genre_ID = GT.Genre_ID
where Chart_Year = 2024
Group by GT.Genre_Type
Order By song_count desc;

Select 
	GT.Genre_Type,
	Count(*) AS song_count
From complete_song_table CST
Join genres_table GT
on CST.Genre_ID = GT.Genre_ID
where Chart_Year = 2023
Group by GT.Genre_Type
Order By song_count desc;


Select 
	GT.Genre_Type,
	Count(*) AS song_count
From complete_song_table CST
Join genres_table GT
on CST.Genre_ID = GT.Genre_ID
where Chart_Year = 2022
Group by GT.Genre_Type
Order By song_count desc;


Select 
	GT.Genre_Type,
	Count(*) AS song_count
From complete_song_table CST
Join genres_table GT
on CST.Genre_ID = GT.Genre_ID
where Chart_Year = 2021
Group by GT.Genre_Type
Order By song_count desc;

Select 
	GT.Genre_Type,
	Count(*) AS song_count
From complete_song_table CST
Join genres_table GT
on CST.Genre_ID = GT.Genre_ID
where Chart_Year = 2020
Group by GT.Genre_Type
Order By song_count desc;


/* 5. Are collaborations becoming more frequent on the chart over time? */

Select 
	CST.Num_of_Artists,
	Count(Num_of_Artists) AS Song_Count
From complete_song_table CST
where Chart_Year = 2020
Group by CST.Num_of_Artists
Order By Song_Count desc;




/* 6. Which album contains the most entries across all five years?  */
Select count(Album) CA, Album
From complete_song_table
group by Album
Order by CA desc;


