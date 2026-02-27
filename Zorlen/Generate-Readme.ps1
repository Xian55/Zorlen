$luaPath = ".\Zorlen_Paladin.lua"
$readmePath = "..\README.md"
$beginMarker = "<!-- BEGIN PALADIN -->"
$endMarker = "<!-- END PALADIN -->"
$lines = Get-Content $luaPath

# Array to hold all function metadata
$entries = @()

function New-Entry {
    param (
        [string]$Function,
        [string]$SpellName,
        [string]$Description,
        [string]$Alias = ""
    )
    [PSCustomObject]@{
        Function    = $Function
        SpellName   = $SpellName
        Description = if ($Description) { $Description.Trim() } else { "(no description)" }
        Alias       = $Alias
    }
}


# Parse BuffCheckMap
$inBuffMap = $false
foreach ($line in $lines) {
    if ($line -match "local\s+BuffCheckMap") {
        $inBuffMap = $true
        continue
    }

    if ($inBuffMap) {
        if ($line -match '^\s*}') {
            $inBuffMap = $false
            continue
        }

        if ($line -match '^\s*(\w+)\s*=\s*"([^"]+)"') {
            $entries += New-Entry -Function $matches[1] -SpellName $matches[2] -Description ""
        }
    }
}

# Parse AuraCastMap
$inCastMap = $false
foreach ($line in $lines) {
    if ($line -match "local\s+AuraCastMap") {
        $inCastMap = $true
        continue
    }

    if ($inCastMap) {
        if ($line -match '^\s*}') {
            $inCastMap = $false
            continue
        }

        if ($line -match '^\s*(\w+)\s*=\s*"([^"]+)"') {
            $entries += New-Entry -Function $matches[1] -SpellName $matches[2] -Description ""
        }
    }
}

# Parse standalone functions with optional preceding comment
for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]

    if ($line -match '^\s*function\s+(\w+)\s*\(') {
        $func = $matches[1]
        $desc = ""
        $alias = ""

        # Check if function matches is*Active
        if ($func -match '^is(.+)Active$') {
            $short = $matches[1]
            # Get capital letters from the inner part to form alias (e.g. DevotionAura → DA)
            $alias = "is" + ($short -creplace '[^A-Z]', '') + "A"
        }

        for ($j = $i - 1; $j -ge 0; $j--) {
            $prevLine = $lines[$j].Trim()
            if ($prevLine -match '^\s*--\s*(.+)$') {
                $desc = $matches[1]
                break
            } elseif ($prevLine -match '^\s*$') {
                continue
            } else {
                break
            }
        }

        $entries += New-Entry -Function $func -SpellName "-" -Description $desc -Alias $alias
    }
}

# Format markdown table
function Format-MarkdownTable {
    param (
        [array]$entryList
    )

    $md = @()
    $md += "| Function | Spell Name | Description | Alias |"
    $md += "|----------|-------------|-------------|--------|"

    foreach ($entry in $entryList) {
        $func = "``$($entry.Function)()``"
        $spell = "``$($entry.SpellName)``"
        $desc = $entry.Description
        $alias = if ($entry.Alias) { "``$($entry.Alias)()``" } else { "" }
        $md += "| $func | $spell | $desc | $alias |"
    }

    return $md
}

# Generate markdown table content
$markdownLines = Format-MarkdownTable -entryList $entries
$generatedContent = $markdownLines -join "`n"

# Insert into main README.md between markers
if (Test-Path $readmePath) {
    $readmeContent = Get-Content $readmePath -Raw

    if ($readmeContent -match [regex]::Escape($beginMarker) -and $readmeContent -match [regex]::Escape($endMarker)) {
        $pattern = "(?s)$([regex]::Escape($beginMarker)).*?$([regex]::Escape($endMarker))"
        $replacement = "$beginMarker`n$generatedContent`n$endMarker"
        $readmeContent = [regex]::Replace($readmeContent, $pattern, $replacement)
        $readmeContent | Set-Content -Encoding UTF8 -NoNewline -Path $readmePath
        Write-Host "README.md updated (Paladin section replaced between markers)"
    } else {
        Write-Host "ERROR: Markers not found in README.md. Expected '$beginMarker' and '$endMarker'"
        exit 1
    }
} else {
    Write-Host "ERROR: README.md not found at $readmePath"
    exit 1
}
