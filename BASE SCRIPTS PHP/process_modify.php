<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = escapeshellarg($_POST['username']);
    $password = !empty($_POST['password']) ? escapeshellarg($_POST['password']) : "NULL";
    $group = !empty($_POST['group']) ? escapeshellarg($_POST['group']) : "NULL";
    $ou = !empty($_POST['ou']) ? escapeshellarg($_POST['ou']) : "NULL";
    $enabled = $_POST['enabled'] == "true" ? "true" : "false";
    $expiration = !empty($_POST['expiration']) ? escapeshellarg($_POST['expiration']) : "NULL";
    $pwd_expire = $_POST['pwd_expire'] == "true" ? "true" : "false";
    $country = !empty($_POST['country']) ? escapeshellarg($_POST['country']) : "NULL";
    $phone = !empty($_POST['phone']) ? escapeshellarg($_POST['phone']) : "NULL";
    $email = !empty($_POST['email']) ? escapeshellarg($_POST['email']) : "NULL";

    $command = "powershell.exe -ExecutionPolicy Bypass -File manage_user.ps1 -Username $username -Password $password -Group $group -OU $ou -Enabled $enabled -Expiration $expiration -PwdExpire $pwd_expire -Country $country -Phone $phone -Email $email";
    $output = shell_exec($command);

    echo "<pre>$output</pre>";
    echo "<a href='index.php'>Volver</a>";
}
?>
