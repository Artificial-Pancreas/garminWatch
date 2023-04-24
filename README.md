# Garmin Watch

The repository gathers all watch faces and data fields for Garmin usable with iAPS system. 

# How to use 

The easy solution is to download directly the watch faces and data fields for you garmin devices. The files are available here : https://github.com/Artificial-Pancreas/garminWatch/releases 

To install the prg in your devices :
- Install Garmin Express and configure with your account
- Attach your watch to computer by USB. You should see your watch as USB-drive then.
- It's usually named "GARMIN" as device (on Mac too, plus it have drive letter in windows, for example, let's say it's drive "E:").
Open your watch storage in Explorer or Finder, enter into folder GARMIN and then in its subfolder APP, so you now should be in path like E:\GARMIN\APPS (on Windows) or /GARMIN/GARMIN/APPS  (on Mac, where first "GARMIN" stands for device name).
- Download any watchface, app, widget with .PRG-file extension format from our file archive you want and put it in that GARMIN/APPS folder.
- You even can download that file directly to yours watch folder from browser, but be sure to finish download before detachment, or you can have broken unfinished file.
- Eject garmin's USB-storage, wait until it writes all caches and only then detach your watch from USB.
- Enter into watch settings and choose ConnectIQ watchface or enable/disable widget or work with that freshly installed app.


You don't find your device/watch in release... ask to Discord in the channel : https://discord.com/channels/1020905149037813862/1096533285603123240 


# How to compile and adapt the code 

You need to install Monkey C and compile with the use of Visual Studio Code. 
All information are available here : https://developer.garmin.com/connect-iq/overview/ 
