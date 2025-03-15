<!DOCTYPE html>
<html>
<head>
    <title>Modificar Usuario</title>
    <script>
        function loadUsers() {
            fetch('get_users.php')
            .then(response => response.json())
            .then(data => {
                let userSelect = document.getElementById('username');
                userSelect.innerHTML = ""; // Limpiar opciones previas
                data.forEach(user => {
                    let option = document.createElement('option');
                    option.value = user;
                    option.textContent = user;
                    userSelect.appendChild(option);
                });
            })
            .catch(error => console.error('Error cargando usuarios:', error));
        }
    </script>
</head>
<body onload="loadUsers()">
    <h1>Modificar Usuario en Active Directory</h1>
    <form action="process_modify.php" method="POST">
        <label>Nombre de Usuario:</label>
        <select id="username" name="username" required></select><br>

        <label>Nueva Contraseña (opcional):</label>
        <input type="password" name="password"><br>

        <label>Nuevo Grupo (opcional):</label>
        <input type="text" name="group"><br>

        <label>Nueva Unidad Organizativa (opcional):</label>
        <input type="text" name="ou"><br>

        <label>Cuenta Habilitada:</label>
        <select name="enabled">
            <option value="true">Sí</option>
            <option value="false">No</option>
        </select><br>

        <label>Expiración de Cuenta (YYYY-MM-DD, opcional):</label>
        <input type="text" name="expiration"><br>

        <label>Contraseña Expira:</label>
        <select name="pwd_expire">
            <option value="true">Sí</option>
            <option value="false">No</option>
        </select><br>

        <label>País:</label>
        <input type="text" name="country"><br>

        <label>Número de Teléfono:</label>
        <input type="text" name="phone"><br>

        <label>Correo Electrónico:</label>
        <input type="email" name="email"><br>

        <button type="submit">Modificar Usuario</button>
    </form>
</body>
</html>
