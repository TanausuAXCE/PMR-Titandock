# Obtener las concesiones DHCP y asegurarse de que se trata como un array
$leases = @(Get-DhcpServerv4Lease -ScopeId "192.168.1.0")

# Recorrer cada elemento para formar la lista de targets con el puerto agregado
$targets = foreach ($lease in $leases) {
    "$($lease.IPAddress):9182"
}

# Crear la estructura dentro de un array para asegurar los corchetes
$outputObject = @(
    @{
        targets = $targets
        labels  = @{ job = "windows_exporter" }
    }
)

# Convertir el objeto a JSON con formato indentado
$outputJson = $outputObject | ConvertTo-Json -Depth 3

# Asegurar que los corchetes [] estén en el archivo
$outputJson = "[ $outputJson ]"

# Guardar en archivo con UTF-8 sin BOM
[System.IO.File]::WriteAllText("\\192.168.1.7\targets\outputWin.json", $outputJson, [System.Text.Encoding]::GetEncoding(28591))
