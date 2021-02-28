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
        $matchList = $clipboard | Select-String -Pattern '(Weapon|Character)$' -Context 0,2

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

# Then pipe/pass (|) the array to the clipboard (clip.exe or clip for short)
$array | clip
Read-Host "`n`nThe clipboard gather loop has been completed.`nAll results have been copied to your clipboard. Please paste (Ctrl+V) the results into the spreadsheet.`n`nPress the enter key to exit and re-copy the data to the clipboard again."
$array | clip # Add to clipboard again just in case its been overriden by a user copy command while the script was waiting
