#Add-Type -assembly System.Windows.Forms
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
    $outBox.Text = $ja
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
    $outBox.Text = $array
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
        $outBox.Text = $NewString
    }
    else{
        $cop = $cop -replace ('\s+', ' ');
        $cop = $cop.Trim(","," ");
        if($cop[0] -ne "("){ $cop = "('" + $cop + "')"; }
        if(!$cop.Contains(',')){ $cop = $cop -replace (" ", "', '"); }
        else{ $cop = $cop -replace (", ", "', '"); }
        $cop = $cop -join "`r`n" | Out-String
        $outBox.Text = $cop
    }
}

function sortList{
    $cop=$inBox.Text;
    $cop = $cop -replace '(^\s+|\s+$)','' -replace '\s+',' '
    $cop = $cop.split(" ");
    $cop = $cop | Sort-Object
    if ($asc = 0){
        $cop = Reverse($cop)
    }
    $cop = $cop -join "`r`n" | Out-String
    $outBox.Text = $cop
}

# Creating form
$mainForm = New-Object System.Windows.Forms.Form 
    $mainForm.Text = "Utils"
    $mainForm.Size = New-Object System.Drawing.Size(600,600)
    $mainForm.AutoSize = $true
    $mainForm.FormBorderStyle = "FixedDialog"
    $mainForm.TopMost = $false
    $mainForm.MaximizeBox = $false
    $mainForm.MinimizeBox = $true
    $mainForm.Font = New-Object System.Drawing.Font("Arial",10)

# Creating a label (to be removed?)
#$Label = New-Object System.Windows.Forms.Label
 #   $Label.Text = "Input:"
  #  $Label.Location = New-Object System.Drawing.Point(10,10)
   # $Label.AutoSize = $true
    #$mainForm.controls.Add($Label)

# Creating textboxes
$inBox = New-Object System.Windows.Forms.TextBox
    $inBox.Size = New-Object System.Drawing.Size(200,540)
    $inBox.Location = New-Object System.Drawing.Point(10,10)
    $inBox.Multiline = $true
    $inBox.ScrollBars = "Vertical"
    $inBox.Text = ""
    $mainForm.controls.Add($inBox)

$outBox = New-Object System.Windows.Forms.TextBox
    $outBox.Size = New-Object System.Drawing.Size(200,540)
    $outBox.Location = New-Object System.Drawing.Point(390,10)
    $outBox.Multiline = $true
    $outBox.ScrollBars = "Vertical"
    $mainForm.controls.Add($outBox)

# Creating a button
$sortButton = New-Object System.Windows.Forms.Button
    $sortButton.Location = New-Object System.Drawing.Size(275,150)
    $sortButton.Size = New-Object System.Drawing.Size(60,25)
    $sortButton.Text = "Sort"
    $sortButton.Add_Click({
        sortList
        if($asc=1){
            $asc =0
        }
        else {
            $asc = 1
        }
    })
    $mainForm.controls.Add($sortButton)

$SQLButton = New-Object System.Windows.Forms.Button
    $SQLButton.Location = New-Object System.Drawing.Size(275,200)
    $SQLButton.Size = New-Object System.Drawing.Size(60,25)
    $SQLButton.Text = "SQL"
    $SQLButton.Add_Click({
        toSQL
    })
    $mainForm.controls.Add($SQLButton)

$duplicatesButton = New-Object System.Windows.Forms.Button
    $duplicatesButton.Location = New-Object System.Drawing.Size(275,250)
    $duplicatesButton.Size = New-Object System.Drawing.Size(60,25)
    $duplicatesButton.Text = "Dupes"
    $duplicatesButton.Add_Click({
        findDupes
    })
    $mainForm.controls.Add($duplicatesButton)

$uniqueButton = New-Object System.Windows.Forms.Button
    $uniqueButton.Location = New-Object System.Drawing.Size(275,300)
    $uniqueButton.Size = New-Object System.Drawing.Size(60,25)
    $uniqueButton.Text = "Uniques"
    $uniqueButton.Add_Click({
        findUniques
    })
    $mainForm.controls.Add($uniqueButton)

[bool]$asc = 1;

#$mainForm.ShowDialog()
$mainForm.Add_Shown({$mainForm.Activate()})
[void] $mainForm.ShowDialog()