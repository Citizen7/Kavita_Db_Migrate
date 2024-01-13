# Kavita_Db_Migrate
### A MySQL script to migrate a [Kavita](https://github.com/Kareadita/Kavita) database from a Windows context to a Docker context.

*Author: WanderingAstarael*
First creation: 12 Jan 2024

If you initially installed Kavita to Windows and later decide you want/need to run it in Docker
(for example, if you migrate to a NAS solution), you will run into the problem of your Windows
and Linux filesystems clashing. This can be mitigated by updating all filepath entries in the
Kativa database to use the "new" (i.e. mapped) directory.

### Example
On your Windows system, you have comics stored like this:
<br /><br />
D:\Manga&bsol;<br />
&emsp;┖── Bleach&bsol;<br />
&emsp;┖── Goodnight Punpun&bsol;<br />
&emsp;┖── Clamp&bsol;<br />
&emsp;&emsp;┖── Chobits&bsol;<br />
&emsp;&emsp;┖── Magic Knight Rayearth&bsol;
<br />   
Your database entry for an issue of Chobits would be "D:\Manga\Clamp\Chobits\c01.cbz".
The Linux filesystem inside the Docker container won't be able to access this location
on your harddrive directly. Mapping "D:\Manga" to "/manga" won't solve the whole problem,
as your database entry will still reference Windows.

After (correctly!!!) creating and mapping your Docker container, you will need to run
this script to update the necessary tables. The script will switch the backslashes (&bsol;)
with forward slashes (&sol;) as well as updating the root directory from your Windows
system to the mapped location.

You will not need to make any changes to your actual Windows file system. You can
leave all of your files exactly where they currently are. All of your reading progress
will be maintained.

## !! Remember! Always back up your "\Kavita\config" folder before proceeding

Good luck, and happy reading!
