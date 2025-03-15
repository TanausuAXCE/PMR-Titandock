# Obtener todos los usuarios de Active Directory y devolver sus SamAccountName en JSON
$users = Get-ADUser -Filter * | Select-Object -ExpandProperty SamAccountName
$users | ConvertTo-Json -Compress