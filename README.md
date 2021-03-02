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
1) Run the script, and choose your format.
2) Go onto your Genshin wish history page (It starts monitoring the clipboard automatically)
3) Select all the text on the page (Ctrl+A after clicking anywhere in the page) - *It is smart enough to filter text don't worry*
4) Then copy (Ctrl+C) this text, there is no need to paste the text anywhere, data is gathered automatically
5) Switch to the next page and repeat until the end

The script will timeout automatically after 10 seconds of inactivity, results are copied to the clipboard (the order is reversed from how you copy it so older entries are first). Follow the link above to the spreadsheet and paste the results into the relevant pages.

## Visual Guide
1) Download the .ps1 file from the release section  
(Alternatively you can copy and paste the script under 'The Code' heading at the bottom of this page into the ISE)   
![Releases](https://user-images.githubusercontent.com/15831708/109448388-b4616a00-79fa-11eb-9406-e3ef2f676deb.png) ![Download](https://user-images.githubusercontent.com/15831708/109448686-613be700-79fb-11eb-8eef-7cdb96f65342.png) 

2) Run the code, either by right clicking on the file and chosing 'Run With Powershell'  
(Alternatively you can load/copy it into the ISE up and choose (Run Script) at the top)
![Run the Script Explorer](https://user-images.githubusercontent.com/15831708/109447882-9f380b80-79f9-11eb-89c3-155105409eb4.png)  
![Run the Script ISE](https://user-images.githubusercontent.com/15831708/109448066-ffc74880-79f9-11eb-9900-7c57ffaa3339.png)

3) Choose your export format, the script will the begin monitoring the clipboard
![Running](https://user-images.githubusercontent.com/15831708/109450091-ee346f80-79fe-11eb-9fb8-247c3877c6e7.png)

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

## Video of the process avaialble here
[![Watch the video](https://user-images.githubusercontent.com/15831708/109725017-6026c900-7b65-11eb-8917-79b0b89997f9.png)](https://streamable.com/tlz3fu)





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
```
# Initilizing Variables
$clipboard = $null
$oldClipboard = $null
$array = $null
$compared = $true
$null | clip
Clear-Host

# Setting loop starting condition
$active = $true                        # We use this for the loop below  
$format = 1                            # Default format option (Genshin Wish Traker)
$milisecondSleepTime = 250             # How long we sleep before checking the clipboard
$secondsBeforeExit = 10                # How many seconds with nothing new copied, we exit after this
$msWeWaited = 0                        # How many milisecond we've waited, added from the sleep timer in loop
$msExit = $secondsBeforeExit*1000      # This makes it code cleaner later

# Here we create the regex match for all languages, it's long but efficent enough with regex, uses twin anchors at the start and end to handle only matching in the wishes
$regexMatch = "^(Weapon|Character|무기|캐릭터|武器|角色|武器|キャラクター|Arma|Personaje|Arme|Personnage|Оружие|Персонажи|อาวุธ|ตัวละคร|Vũ Khí|Nhân Vật|Waffe|Figur|Senjata|Karakter)$"

# Write to host that we've started and let them know what to do
$choice = Read-Host "1) Genshin Wish Tracker (Default, clean format)`n2) Genshin Wish Tally (Raw data + overide counter)`nPlease choose your export format."
Write-Host "`n`nBe sure to READ ALL instructions before starting`nIf able, you can move this window to a second screen to watch as the script runs, otherwise it runs in the background"
Write-Host "`n1) Please go onto your Genshin wish history page `n2) Select all the text on the page (Ctrl+A after clicking anywhere in the page) `n3) Then copy (Ctrl+C) this text, there is no need to paste the text anywhere, data is gathered automtically `n4) Switch to the next page and repeat until the end `n`nThe script will timeout automatically after $secondsBeforeExit seconds of inactivity, results are copied to the clipboard in reverse order (to arrange oldest to newest)"
switch ($choice) {
    1{$format = 1}
    2{$format = 2}
}

# Start loop
while($active) {
    # Each loop we want to cache are old clipboard and grab a new one to see when we've copied new data
    if ($clipboard) 
        {$oldClipboard = $clipboard}
    $clipboard = Get-Clipboard

    # Checking for new data, compare object is null when no differences
    if ($clipboard -and $oldClipboard) 
        {$compared = Compare-Object -ReferenceObject $clipboard -DifferenceObject $oldClipboard}

    # If the comparision isn't null and clipboard isn't empty
    if ($compared -ne $null -and $clipboard -ne "") {
        # Main logic here is to parse through the windows clipboard to find a line containing Weapon or Character and thats it. 
        # Clipboard stores each newline as an item in a string array so we need to grab 2 post context as genshin web table copies in each entry as a newline rather than a tabbed table
        $matchList = $clipboard | Select-String $regexMatch -Context 0,2

        # Setup data format based off choice
        switch ($format) {
            1{
                # Now we pipe (pass along) the match list to a foreach loop (%{}) and extract the values from each objects ($_) properties. Joined with tabs (`t). Ordered to work with the spreadsheet. Looks ugly but runs great
                $strArrayList = $matchList | %{"$($_.Context.DisplayPostContext[1])`t$($_.Context.DisplayPostContext[0] -replace ' \(.*\)','' )`t$($_.Matches.Value)"}
            }
            2{
                $strArrayList = $matchList | %{($_.Matches.Value,($_.Context.DisplayPostContext -join "")) -join "" }
            }

        }
        # Check if we already have an array, if so add, if not make one
        if ($array) {$array+=$strArrayList} 
        else {$array = $strArrayList}

        #Friendly console writing so you know its doing things right, return the array and count plus countdown. Apolgoise if how I use write-host is horrible below...
        Clear-Host                    # Cleans the console screen up so its easier to read
        Write-Host "`n`n`n`n`n`n"     # The writes a bunch of empty newlines to get below our fancy progress bar
        $array                        # This just dumps the array into the console, its honestly the best way, write-host wants strings

        # Reset our waiting timer
        $msWeWaited = 0
    }

    # Check if we've waited past our exit timer
    if ($msWeWaited -ge $msExit) {$active = $false} 
    else {sleep -Milliseconds $milisecondSleepTime}

    # If we've already copied something to oldClipboard then we should start adding to our countdown timer and activate the status bar
    if ($oldClipboard) {
        # Fancy Status Bar! Using [Int] which casts the double down to an interger, works to round without making the code hard to read with [Math]::Round($var,0)
        Write-Progress -Id 0 -Activity "Current List Count: $($array.Count)" -Status "$([Int]($msWeWaited/1000)) of $secondsBeforeExit seconds for timer have passed since the last update. Will automatiacally exit if nothing new is copied." -PercentComplete ($msWeWaited/$msExit*100)
        $msWeWaited += $milisecondSleepTime
    }    
}

# Once we've exited I reverse the array so the oldest stuff is first, makes it easier to put into the spreadsheet since its in the correct order
[Array]::Reverse($array)

# Here we check if we're in Wish Tally format, if so we need to add override values to prevent sorting errors for multipulls
if ($format -eq 2) {
    # Grab array of just times then pull out the unique values
    $timeArray = foreach ($item in $array) { ($item | sls -Pattern "[\d- :]{19}").Matches.Value }
    $uniqueTimes = $timeArray | Get-Unique

    # Here we set an array equal to the results of a foreach loop, we're going through each unique time and finding all the results that match, if there is more than 1 we add override numbers with `t characters
    $formatedArray = foreach ($time in $uniqueTimes) {
        $i = 1
        $timeMatches = $array | sls -SimpleMatch $time
        if ($timeMatches.Count -gt 1) {
            $timeMatches | %{"$_`t$i" -replace "[\r\n]+","" ;$i++} # Here was do a foreach in short hand with %{}, we're also replacing any extra return (\r) or newlines (\n) with nothing to clean up the results
        } else {
            $timeMatches -replace "[\r\n]+"
        }
    }
    # Set the array equal to our formated array
    $array = $formatedArray
}

# We use Set-Clipboard to store the array into the clipboard in UTF8 Compliant charactes for other languages
Set-Clipboard $array
Read-Host "`n`nThe clipboard gather loop has been completed.`nAll results have been copied to your clipboard. Please paste (Ctrl+V) the results into the spreadsheet.`n`nPress the enter key to exit and re-copy the data to the clipboard again."
Set-Clipboard $array # Add to clipboard again just in case its been overriden by a user copy command while the script was waiting
```

## Conclusion
This was done all to make easy exporting of the wish list possible, and the closest attempt I saw to this was a spreadsheet that did the parsing of the raw values copied out. But that is crazy tedious and too complicated for most to deal with I imagine.  
This solution is hopefully simple and easy enough that everyone will actually bother to do it. I also hope it helps people to pool together their wish histories for data analytics which I would love to see.  
Oh and just in case anyone is generous I made a [paypal whale fund](https://paypal.me/pools/c/8wWLvN3rpD). Though please note, I don't need money and these funds will be spent on gatcha, which most would consider irresponsible spending.
