param (
    [string]$UserName,
    [string]$Password,
    [string]$Group,
    [string]$OU
)

# Establecer la codificación de entrada y salida a UTF-8 para manejar caracteres especiales
$OutputEncoding = [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding


# Asegurarse de que el script termine si hay un error
$ErrorActionPreference = "Stop"

# Obtener las políticas de contraseñas
$PasswordPolicy = Get-ADDefaultDomainPasswordPolicy
$MinLength = $PasswordPolicy.MinPasswordLength
$Complexity = $PasswordPolicy.ComplexityEnabled

$PasswordErrors = @()

# Verificar si la contraseña cumple con la longitud mínima
if ($Password.Length -lt $MinLength) {
    $PasswordErrors += "La contraseña debe tener al menos $MinLength caracteres."
}

# Verificar complejidad de la contraseña si está habilitada
if ($Complexity) {
    if ($Password -notmatch "[A-Z]") {
        $PasswordErrors += "La contraseña debe contener al menos una letra mayúscula."
    }
    if ($Password -notmatch "[a-z]") {
        $PasswordErrors += "La contraseña debe contener al menos una letra minúscula."
    }
    if ($Password -notmatch "[0-9]") {
        $PasswordErrors += "La contraseña debe contener al menos un número."
    }
    if ($Password -notmatch "[^a-zA-Z0-9]") {
        $PasswordErrors += "La contraseña debe contener al menos un carácter especial (!@#$%^&*)."
    }
}

# Si hay errores, mostrar todo de una vez
if ($PasswordErrors.Count -gt 0) {
    Write-Host ($PasswordErrors -join "`n")
    exit 1
}

# Obtener el dominio por defecto
$DomainDN = (Get-ADDomain).DistinguishedName

# Si no se proporciona una OU, usar la predeterminada
if (-not $OU) {
    $OU = "CN=Users,$DomainDN"
} else {
    $OU = "OU=$OU,$DomainDN"
}

# Verificar si la OU existe
if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$OU'")) {
    Write-Host "ERROR: La OU especificada no existe ($OU)."
    exit 1
}

# Crear el usuario en Active Directory
try {
    New-ADUser -SamAccountName $UserName -UserPrincipalName "$UserName@$((Get-ADDomain).DNSRoot)" `
               -Name $UserName -GivenName $UserName `
               -Surname $UserName -Path $OU `
               -Enabled $true -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
               -PasswordNeverExpires $false -ChangePasswordAtLogon $true

    Write-Host "Usuario '$UserName' creado correctamente en AD."
} catch {
    Write-Host "Error al crear el usuario: $_"
    exit 1
}

# Si se proporciona un grupo, agregar el usuario a ese grupo
if ($Group) {
    if (Get-ADGroup -Filter "Name -eq '$Group'") {
        Add-ADGroupMember -Identity $Group -Members $UserName
        Write-Host "Usuario '$UserName' añadido al grupo '$Group'."
    } else {
        Write-Host "ERROR: El grupo '$Group' no existe."
        exit 1
    }
}
