 [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")


function findDupes{
    $cop=$inBox.Text;
    $cop = $cop -replace '(^\s+|\s+$)','' -replace '\s+',' '
    $cop = $cop.split(" ");
    $array = New-Object System.Collections.ArrayList($null);
    $ja = New-Object System.Collections.ArrayList($null);
    foreach($obj in $cop){
        if(!$ja.Contains($obj)){
            if($array.Contains($obj)){
                [void]$ja.Add($obj);
            }
            else{
                [void]$array.Add($obj);
            }
        }
    }
    $ja = $ja -join "`r`n" | Out-String
    $outBox.Text = $ja.TrimEnd()
}
function findUniques {
    $cop=$inBox.Text;
    $cop = $cop -replace '(^\s+|\s+$)','' -replace '\s+',' '
    $cop = $cop.split(" ");
    $array = New-Object System.Collections.ArrayList($null);
    $nej = New-Object System.Collections.ArrayList($null);
    foreach($obj in $cop){
        if(!$nej.Contains($obj)){
            if($array.Contains($obj)){
                $array.Remove($obj);
                [void]$nej.Add($obj);
            }
            else{
                [void]$array.Add($obj);
            }
        }
    }
    $array = $array -join "`r`n" | Out-String
    $outBox.Text = $array.TrimEnd()
}
function toSQL{
    $cop=$inBox.Text;
    if($cop -is [array]){
        [System.Collections.ArrayList]$ArrayList = $cop;
        $ArrayList = $ArrayList | Where-Object { $_ -match '\S' };
        $NewString = "('" + $ArrayList + "')";
        $NewString = $NewString -replace ('\s+', ' ');
        $NewString = $NewString -replace (" ", "', '");
        $NewString = $NewString -join "`r`n" | Out-String
        $outBox.Text = $NewString.TrimEnd()
    }
    else{
        $cop = $cop -replace ('\s+', ' ');
        $cop = $cop.Trim(","," ");
        if($cop[0] -ne "("){ $cop = "('" + $cop + "')"; }
        if(!$cop.Contains(',')){ $cop = $cop -replace (" ", "', '"); }
        else{ $cop = $cop -replace (", ", "', '"); }
        $cop = $cop -join "`r`n" | Out-String
        $outBox.Text = $cop.TrimEnd()
    }
}

function sortList{
    $cop = $inBox.Text;
    $cop = $cop -replace '(^\s+|\s+$)','' -replace '\s+',' '
    $cop = $cop.split(" ");
    $cop = $cop | Sort-Object
    if ($asc -eq $true){
        if($cop -join "`r`n" -match '^[\d\s]*$'){
            $cop = $cop | Sort-Object {[int]$_}
        } else{
            $cop = $cop | Sort-Object
        }
    }
    else{
        if($cop -join "`r`n" -match '^[\d\s]*$'){
            $cop = $cop | Sort-Object {[int]$_} -Descending
        } else{
            $cop = $cop | Sort-Object -Descending
        }
    }
    $cop = $cop -join "`r`n" | Out-String
    $outBox.Text = $cop.TrimEnd()
}

function countInput{
    $cop=$inBox.Text;
    $cop = $cop -replace '(^\s+|\s+$)','' -replace '\s+',' '
    $cop = $cop.split(" ");
    $count = 0
    foreach($obj in $cop){
        $count = $count + 1
    }

    $outBox.Text = $count

}


function copyResult{
    if($outbox.Text) {Set-Clipboard -Value $outBox.Text}
}

function pasteClip{
    $inBox.Text = Get-Clipboard
}

function search{
    $cop = $inBox.Text;
    $cop = $cop -replace '(^\s+|\s+$)','' -replace '\s+',' '
    $cop = $cop.split(" ");
    $s   = $searchBox.Text; 
    $res = New-Object System.Collections.ArrayList($null);

    foreach($obj in $cop){
        if($obj.Contains($s)){
            [void]$res.Add($obj);
        }
    }
    $res = $res -join "`r`n" | Out-String
    $outBox.Text = $res.TrimEnd()
}


# Creating form
$mainForm = New-Object System.Windows.Forms.Form 
    $mainForm.Text = "List tool"
    $mainForm.Size = New-Object System.Drawing.Size(1000,600)
    $mainForm.AutoSize = $true
    $mainForm.FormBorderStyle = "FixedDialog"
    $mainForm.TopMost = $false
    $mainForm.MaximizeBox = $false
    $mainForm.MinimizeBox = $true
    $mainForm.Font = New-Object System.Drawing.Font("Arial",10)


# Creating textboxes
$inBox = New-Object System.Windows.Forms.RichTextBox
    $inBox.Size = New-Object System.Drawing.Size(400,540)
    $inBox.Location = New-Object System.Drawing.Point(10,10)
    $inBox.Multiline = $true
    $inBox.ScrollBars = "Vertical"
    $inBox.Text = ""
    $mainForm.controls.Add($inBox)

$outBox = New-Object System.Windows.Forms.RichTextBox
    $outBox.Size = New-Object System.Drawing.Size(400,540)
    $outBox.Location = New-Object System.Drawing.Point(584,10)
    $outBox.Multiline = $true
    $outBox.ScrollBars = "Vertical"
    $mainForm.controls.Add($outBox)

$searchBox = New-Object System.Windows.Forms.TextBox
    $searchBox.Size = New-Object System.Drawing.Size(154,0)
    $searchBox.Location = New-Object System.Drawing.Point(420,420)
    $mainForm.controls.Add($searchBox)


# Creating buttons
$sortButton = New-Object System.Windows.Forms.Button
    $sortButton.Location = New-Object System.Drawing.Size(464,50)
    $sortButton.Size = New-Object System.Drawing.Size(66,25)
    $sortButton.Text = "Sort"
    $mainForm.controls.Add($sortButton)
    $sortButton.Add_Click({
        sortList
        $global:asc = !$asc;
    })


$SQLButton = New-Object System.Windows.Forms.Button
    $SQLButton.Location = New-Object System.Drawing.Size(464,100)
    $SQLButton.Size = New-Object System.Drawing.Size(66,25)
    $SQLButton.Text = "SQL"
    $SQLButton.Add_Click({
        toSQL
    })
    $mainForm.controls.Add($SQLButton)

$duplicatesButton = New-Object System.Windows.Forms.Button
    $duplicatesButton.Location = New-Object System.Drawing.Size(464,150)
    $duplicatesButton.Size = New-Object System.Drawing.Size(66,25)
    $duplicatesButton.Text = "Dupes"
    $duplicatesButton.Add_Click({
        findDupes
    })
    $mainForm.controls.Add($duplicatesButton)

$uniqueButton = New-Object System.Windows.Forms.Button
    $uniqueButton.Location = New-Object System.Drawing.Size(464,200)
    $uniqueButton.Size = New-Object System.Drawing.Size(66,25)
    $uniqueButton.Text = "Uniques"
    $uniqueButton.Add_Click({
        findUniques
    })
    $mainForm.controls.Add($uniqueButton)

$countButton = New-Object System.Windows.Forms.Button
    $countButton.Location = New-Object System.Drawing.Size(464,250)
    $countButton.Size = New-Object System.Drawing.Size(66,25)
    $countButton.Text = "Count"
    $countButton.Add_Click({
        countInput
    })
    $mainForm.controls.Add($countButton)

$copyButton = New-Object System.Windows.Forms.Button
    $copyButton.Location = New-Object System.Drawing.Size(514,525)
    $copyButton.Size = New-Object System.Drawing.Size(66,25)
    $copyButton.Text = "Copy"
    $copyButton.Add_Click({
        copyResult
    })
    $mainForm.controls.Add($copyButton)

$pasteButton = New-Object System.Windows.Forms.Button
    $pasteButton.Location = New-Object System.Drawing.Size(414,525)
    $pasteButton.Size = New-Object System.Drawing.Size(66,25)
    $pasteButton.Text = "Paste"
    $pasteButton.Add_Click({
        pasteClip
    })
    $mainForm.controls.Add($pasteButton)

$searchButton = New-Object System.Windows.Forms.Button
    $searchButton.Location = New-Object System.Drawing.Size(464,450)
    $searchButton.Size = New-Object System.Drawing.Size(66,25)
    $searchButton.Text = "Search"
    $searchButton.Add_Click({
        search
    })
    $mainForm.controls.Add($searchButton)



$global:asc = $true;

#$mainForm.ShowDialog()
$mainForm.Add_Shown({$mainForm.Activate()})
[void] $mainForm.ShowDialog()
