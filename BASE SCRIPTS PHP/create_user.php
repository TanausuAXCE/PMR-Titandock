<?php
header('Content-Type: text/html; charset=UTF-8');
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST["username"];
    $password = $_POST["password"];
    $group = $_POST["group"] ?? "";
    $ou = $_POST["ou"] ?? "";

    // Escapar caracteres especiales para seguridad
    $username = escapeshellarg($username);
    $password = escapeshellarg($password);
    $group = escapeshellarg($group);
	    $ou = escapeshellarg($ou);

    // Ejecutar el script de PowerShell para crear el usuario en AD
    $command = "powershell.exe -ExecutionPolicy Unrestricted -Command -Command \"[Console]::OutputEncoding = [System.Text.UTF8Encoding]::UTF8; & './create_user.ps1' '$username' '$password' '$group' '$ou'\"";
    $output = shell_exec($command);

    // Mostrar el resultado en la página
    echo "<pre>$output</pre>";

    echo "<br><a href='index.php'>Volver al inicio</a>";
}
?>
