# Genshin Wish History Export - Powershell Script
Given that Genshin Impact has decided to remove wish history older than 6 months, exporting your history is more important than ever. 
However, since they've made it as hard as possible to do so (only in game via custom browser), most will likely not be willing to take up the task and time commitment.
This speaks nothing of the burden it is to maintain such a list.

To ease the task, I've written a very simple power shell script; one that works in what I feel is a clever method.
Since the Genshin Impact 'Wish History' runs in a browser as mentioned above, on PC you can use the keyboard shortcuts to copy and paste the text from it.
Of course, to make things harder, its formatting is bad and requires extensive parsing, which is why I started with a script.

This script is designed to work with two different wish trackers, [this wish tracker](https://docs.google.com/spreadsheets/d/1B9AXURjB4Y0HvOCBhIt8TzaqP1phoI17JlM_RvNtd9g/), which I found in this [reddit post](https://www.reddit.com/r/Genshin_Impact/comments/l2vi4w/my_friend_and_i_made_a_spreadsheet_to_see_all_of/) and [the community wish tally tracker](https://docs.google.com/spreadsheets/d/1_Or0KRVZ5nwCrHdO5c_8rqu2CWJ_aLETnZBLSYBDS_c/edit#gid=1027022977) which its latest post is [here on reddit with more detail](https://www.reddit.com/r/Genshin_Impact/comments/ltt4vp/wish_tally_v26_wish_history_pity_tracker_for/).
The first spreadsheet was designed and posted to reddit by [/u/damoncles](https://www.reddit.com/user/damoncles) and has saved me a lot of time since I didn't have to make one myself to go with this script. The second was deigned by [u/Yippym](https://www.reddit.com/user/Yippym) and helps track not just for individuals but supports community tracking. As such, the output of this script is formated to be directly copy/pasted into only these two spreadsheet and may not work with others.

Finally it should work is all supported languages for Genshin as of the 28th of Feburary 2021. However, the spreadsheets linked above only support their own languages so do check.

## How it works (Simple)
1) Run the script, and choose your game language and spreadsheet format.
2) Go onto your Genshin wish history page (It starts monitoring the clipboard automatically)
3) Select all the text on the page (Ctrl+A after clicking anywhere in the page) - *It is smart enough to filter text don't worry*
4) Then copy (Ctrl+C) this text, there is no need to paste the text anywhere, data is gathered automatically
5) Switch to the next page and repeat until the end

The script will timeout automatically after 10 seconds of inactivity, results are copied to the clipboard (the order is reversed from how you copy it so older entries are first). Follow the link above to the spreadsheet and paste the results into the relevant pages.

## Visual Guide
1) Download the both the .ps1 and .bat files from the release page  
(The .bat is optional but allows you to run the powershell scripts if you've never setup your powershell execution policy.)  
(Alternatively you can copy and paste the script under 'The Code' heading at the bottom of this page into the Powershell ISE)   
![Releases](https://user-images.githubusercontent.com/15831708/109448388-b4616a00-79fa-11eb-9406-e3ef2f676deb.png) ![Download](https://user-images.githubusercontent.com/15831708/109906931-2681bb00-7c56-11eb-9c8e-80993952e7a9.png)


2) Run the code, for ease you can start with 'Genshin Wish Export.bat' and double click it or right-click then choose open.  
(If you've run powershell scripts before you can right click and choose run, or use the powershell ISE select Run Script) 
![Running Script](https://user-images.githubusercontent.com/15831708/109909505-13bdb500-7c5b-11eb-800c-b6c55c2981a9.png)
![Run the Script ISE](https://user-images.githubusercontent.com/15831708/109908875-eb818680-7c59-11eb-8cb2-22f234c52970.png)


3) Choose your Language and Export Format type, just type the choice number and hit enter. The script will the begin monitoring the clipboard
![Running Script](https://user-images.githubusercontent.com/15831708/109908320-ebcd5200-7c58-11eb-86cd-387cef3a2d8c.png)

4) Goto your Genshin wish history page for the desired banner
![History](https://user-images.githubusercontent.com/15831708/109449041-4fa70f00-79fc-11eb-842e-ee5f94ffc9d9.png)
![History Page](https://user-images.githubusercontent.com/15831708/109449078-63527580-79fc-11eb-875e-7cff7457eedc.png)

5) Select all the text on the page (Ctrl+A after clicking anywhere in the page)
![Select All](https://user-images.githubusercontent.com/15831708/109449298-ec69ac80-79fc-11eb-900b-f6e3869406d8.png)

6) Then copy (Ctrl+C) this text, there is no need to paste the text anywhere, data is gathered automtically 
![Copy ALl](https://user-images.githubusercontent.com/15831708/109449398-318dde80-79fd-11eb-98ba-664fb873d90c.png)
![Script Capture](https://user-images.githubusercontent.com/15831708/109451696-d7901780-7a02-11eb-9446-ceb5f3260009.png)

7) Switch to the next page and repeat until the end. The script will automatically end after 10 seconds without copying new data
![End](https://user-images.githubusercontent.com/15831708/109451839-3c4b7200-7a03-11eb-844a-e2a4a6ed50b7.png)

## Exapmle Video
[![Watch the video](https://user-images.githubusercontent.com/15831708/109725017-6026c900-7b65-11eb-8917-79b0b89997f9.png)](https://streamable.com/lhq87w)

## Details on how the script works
The script works by calling the contents of the clipboard and comparing against its last recorded version. This means it does not double count if you copy the text 10 times in a row.

Once it detects a change it does a regex search for '(Weapon|Character)$' with 2 post-context which grabs a match object we can then use to build our output string array. I do this with an ugly piped expression, but it works and reorders the match to fit being exported into the spreadsheets linked above.

There is a sleep timer and a counter in the main loop that gives 10 seconds without a new clipboard being detected before it exits. It then reverses the array since we want it oldest to newest for our spreadsheet and tosses it at the clipboard. It also read-hosts the ending message so the user has a moment to process it.

I also toss the array to the clipboard after exiting, that way if you’re like me and used a macro to fully automate it you don’t have to worry about the array having been dumped for the 100th refreshed copy command from the macro. 

### Wait macros?  
Yes, if you have a keyboard/mouse with the ability to make macros and assign them to a hotkey, this is very easy to automate. You can also do this via the AutoHotkey software if you don't have a device that supports doing so. 

Just make a macro that does [Ctrl+A -> Ctrl+C -> Left-Click] and repeat (with a 1+ second delay). Make sure your mouse is on the "next page" button and that you've clicked somewhere on the page before you start the macro, and step away until done.  

The timeout will happen once you reach the end of your history and then you can simply exit the program, and the array is tossed to the clipboard again.

## How can I trust your code?
Good stance to have; the code is easily readable and overly commented to guide anyone (hopefully) to understand what is going on so long as you’ve grasped a programing language before. If you haven’t, hopefully this gets popular enough that someone (probably much better at coding than me) on the reddit thread can go over it and vouch for it.

[Reddit Post](https://www.reddit.com/r/Genshin_Impact/comments/lkprrl/automated_wish_history_export_via_powershell_for/)

Below is the exact code, and since it's powershell, you can copy this into a powershell console or into the powershell ISE and run it directly yourself instead of using the .ps1 file located here.

## The Code
As the code has gotten a bit longer with all the extra features I'm not going to dump it in this readme. You can review the code by clicking the files located at the top of this page.  
![Files](https://user-images.githubusercontent.com/15831708/109910315-af9bf080-7c5c-11eb-85f8-1598a6c3d3e5.png)  
You can even copy and paste the code from the .ps1 file into the Powershell ISE yourself if you wish to avoid possibly downloading anything. The batch file is simply the following code to launch powershell via cmd with a bypass on the execution policy which is defaulted to stop you from running powershell. '%~dpn0' just pulls the location of .bat file and its name and uses it to target the .ps1 file.
```
@ECHO OFF
PowerShell.exe -ExecutionPolicy Bypass -Command "& '%~dpn0.ps1'"
```

## Conclusion
This was done all to make easy exporting of the wish list possible, and the closest attempt I saw to this was a spreadsheet that did the parsing of the raw values copied out. But that is crazy tedious and too complicated for most to deal with I imagine.  
This solution is hopefully simple and easy enough that everyone will actually bother to do it. I also hope it helps people to pool together their wish histories for data analytics which I would love to see.  
Oh and just in case anyone is generous I made a [paypal whale fund](https://paypal.me/pools/c/8wWLvN3rpD). Though please note, I don't need money and these funds will be spent on gatcha, which most would consider irresponsible spending.
