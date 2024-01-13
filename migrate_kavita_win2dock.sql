/*
Script for migrating a Windows Kavita database to a Docker Kavita database
Author: WanderingAstarael

Considering the limitations of MySQL compared to T-SQL, 
this was the cleanest implementation I could come up with.

There are three tables where filepaths need to be changed:
	FolderPath
	Series
	MangaFile

!!! BEFORE RUNNING SCRIPT !!!
0) Make a copy of this file before modifying it. You will need the original.

1) CTRL+H, replace OldLocation with the filepath where
your comics are stored in your Windows system, changing the 
backslashes (\) into forward slashes (/).
 
If you followed the Kavita instructions for installing Docker,
this is the path you mapped to '/comics'.

Ex: If your root comic folder is 'D:\Comic Books', use D:/Comic Books.

!! Don't include single or double quotes 
!! when using CTRL+H; they are already
!! provided in the script below.

2) CTRL+H, replace NewLocation with the filepath in Docker you are
using for your root comic folder. If you followed the Kavita instructions
for installing Docker, this will be /comics. If you used an alternate path,
use that instead.
Ex: If your docker-compose.yml has
	- D:/Comic Books:/funny-pages
	then use /funny-pages

!! Don't include single or double quotes 
!! when using CTRL+H; they are already
!! provided in the script below.
	
3) Execute this script using a SQLite database manager.

4) Using the original file as saved in Step 0
REPEAT steps 1-3 for each of your mapped folders.
E.g. If you had manga files stored in 'E:\Manga My Mom Cannot Read'
and mapped that to '/manga' when you created your Docker container,
use those as your OldLocation and NewLocation.
Do the same for '/books', etc, etc.
*/

-- Setup			
-- drop all temp tables created by script,
-- in case this is not first run of script
drop table if exists xF_temp;
drop table if exists yF_temp;
drop table if exists xS_temp;
drop table if exists yS_temp;
drop table if exists xM_temp;
drop table if exists yM_temp;

-- Folder Path
-- change the Windows backslash to the Linux slash
create temp table xF_temp as
select LibraryId, Path,
replace(Path,'\\' , '/') as X
from FolderPath;

-- change the old path to the new path
create temp table yF_temp as
select LibraryId, X,
replace(X,'OldLocation','NewLocation') as Y
from xF_temp;

-- update the table with the new path
update FolderPath
set Path = (select Y
			from yF_temp
			where LibraryId = FolderPath.LibraryId);
			
-- Series
-- change the Windows backslash to the Linux slash			
create temp table xS_temp as
select Id, FolderPath,
replace(FolderPath,'\\','/') as X
from Series;

-- change the old path to the new path
create temp table yS_temp as
select Id, X,
replace(X,'OldLocation','NewLocation') as Y
from xS_temp;

-- update the table with the new path
update Series
set FolderPath = (select Y
			from yS_temp
			where Id = Series.Id);

-- MangaFile
-- change the Windows backslash to the Linux slash			
create temp table xM_temp as
select ChapterId, FilePath,
replace(FilePath,'\\','/') as X
from MangaFile;

-- change the old path to the new path
create temp table yM_temp as
select ChapterId, X,
replace(X,'OldLocation','NewLocation') as Y
from xM_temp;

-- update the table with the new path
update MangaFile
set FilePath = (select Y
			from yM_temp
			where ChapterId = MangaFile.ChapterId);

-- Clean Up			
-- drop all temp tables created by script
drop table if exists xF_temp;
drop table if exists yF_temp;
drop table if exists xS_temp;
drop table if exists yS_temp;
drop table if exists xM_temp;
drop table if exists yM_temp;