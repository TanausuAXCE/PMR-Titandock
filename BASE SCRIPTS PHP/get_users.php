<?php
$command = "powershell.exe -ExecutionPolicy Bypass -File get_users.ps1";
$output = shell_exec($command);
echo $output;
?>
