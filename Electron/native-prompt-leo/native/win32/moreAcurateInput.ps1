Add-Type -AssemblyName System.Windows.Forms;
Add-Type -AssemblyName System.Drawing;

$form = New-Object System.Windows.Forms.Form;
$form.Size = New-Object System.Drawing.Size(300, 134);
$form.Text = $args[0];
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog;
$form.MaximizeBox = $false;
$form.MinimizeBox = $false;
$form.StartPosition = "CenterScreen";
$form.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240);

[System.Windows.Forms.Application]::EnableVisualStyles()

$ok = New-Object System.Windows.Forms.Button;
$ok.Size = New-Object System.Drawing.Size(60, 24);
$ok.Location = New-Object System.Drawing.Point(145, 60);
$ok.DialogResult = [System.Windows.Forms.DialogResult]::OK;
$ok.Text = $args[3];
$ok.FlatStyle = [System.Windows.Forms.FlatStyle]::System;
$form.AcceptButton = $ok;
$form.Controls.Add($ok);

$cancel = New-Object System.Windows.Forms.Button;
$cancel.Size = New-Object System.Drawing.Size(60, 24);
$cancel.Location = New-Object System.Drawing.Point(210, 60);
$cancel.Text = $args[4];
$cancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel;
$cancel.FlatStyle = [System.Windows.Forms.FlatStyle]::System;
$form.CancelButton = $cancel;
$form.Controls.Add($cancel);

$text = New-Object System.Windows.Forms.Label;
$text.Location = New-Object System.Drawing.Point(15, 10);
$text.Size = New-Object System.Drawing.Size(255, 20);
$text.Text = $args[1];
$form.Controls.Add($text);

$textbox = New-Object System.Windows.Forms.TextBox;
$textbox.Text = $args[2];
$textbox.Location = New-Object System.Drawing.Point(15, 30);
$textbox.Size = New-Object System.Drawing.Size(255, 20);
$textbox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle;
$form.Controls.Add($textbox);

$form.Topmost = $true;

$form.Add_Shown({ $textbox.Select() });
$result = $form.ShowDialog();

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $inputText = $textbox.Text
    $charArray = $inputText.ToCharArray()
    $proccessedText = @()
    foreach ($char in $charArray) {
        if ([int]$char -lt 32 -or [int]$char -gt 126) {
            $proccessedText += "\" + ([int]$char).ToString() + "\"
        }
        elseif ($char -eq "\") {
            $proccessedText += "/\"
        }
        else {
            $proccessedText += $char
        }
    }
    $proccessedText = $proccessedText -join ""
    echo "RETURN$proccessedText";
}

echo "CLOSE";