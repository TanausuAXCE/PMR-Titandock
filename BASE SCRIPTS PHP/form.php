<?php
// Formulario para ingresar los datos del usuario
?>
<!DOCTYPE html>
<html>
<head>
    <title>Crear Usuario</title>
</head>
<body>
    <h1>Crear Nuevo Usuario</h1>
    <form action="create_user.php" method="POST">
        <label>Nombre de usuario:</label>
        <input type="text" name="username" required><br>

        <label>Contraseña:</label>
        <input type="password" name="password" required><br>

        <label>Grupo (opcional):</label>
        <input type="text" name="group"><br>

        <label>Unidad Organizativa (opcional):</label>
        <input type="text" name="ou"><br>

        <button type="submit">Crear Usuario</button>
    </form>
</body>
</html>
