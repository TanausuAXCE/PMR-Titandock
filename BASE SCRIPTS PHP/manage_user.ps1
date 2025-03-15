param(
    [string]$Username,
    [string]$Password,
    [string]$Group,
    [string]$OU,
    [string]$Enabled,
    [string]$Expiration,
    [string]$PwdExpire,
    [string]$Country,
    [string]$Phone,
    [string]$Email
)

# Verificar si el usuario existe
if (-not (Get-ADUser -Filter {SamAccountName -eq $Username})) {
    Write-Host "❌ El usuario $Username no existe en Active Directory."
    exit
}

# Cambiar contraseña
if ($Password -ne "NULL") {
    $SecurePassword = ConvertTo-SecureString -AsPlainText $Password -Force
    Set-ADAccountPassword -Identity $Username -NewPassword $SecurePassword -Reset
}

# Habilitar o deshabilitar cuenta
if ($Enabled -eq "true") {
    Enable-ADAccount -Identity $Username
} else {
    Disable-ADAccount -Identity $Username
}

# Cambiar la expiración de la cuenta
if ($Expiration -ne "NULL") {
    Set-ADUser -Identity $Username -AccountExpirationDate (Get-Date $Expiration)
}

# Configurar si la contraseña expira o no
Set-ADUser -Identity $Username -PasswordNeverExpires ([bool]$PwdExpire)

# Cambiar grupo si se especifica
if ($Group -ne "NULL") {
    if (-not (Get-ADGroup -Filter {Name -eq $Group})) {
        $choice = Read-Host "El grupo $Group no existe. ¿Desea crearlo? (Sí/No)"
        if ($choice -eq "Sí") {
            New-ADGroup -Name $Group -GroupScope Global -PassThru
        } else {
            exit
        }
    }
    Add-ADGroupMember -Identity $Group -Members $Username
}

# Cambiar Unidad Organizativa si se especifica
if ($OU -ne "NULL") {
    $DomainDN = (Get-ADDomain).DistinguishedName
    $OUPath = "OU=$OU,$DomainDN"
    
    if (-not (Get-ADOrganizationalUnit -Filter {Name -eq $OU})) {
        $choice = Read-Host "La OU $OU no existe. ¿Desea crearla? (Sí/No)"
        if ($choice -eq "Sí") {
            New-ADOrganizationalUnit -Name $OU -Path $DomainDN
        } else {
            exit
        }
    }
    Move-ADObject -Identity (Get-ADUser -Identity $Username).DistinguishedName -TargetPath $OUPath
}

# Actualizar datos personales
Set-ADUser -Identity $Username -Country $Country -OfficePhone $Phone -EmailAddress $Email

Write-Host "✅ Modificaciones aplicadas correctamente para $Username."
