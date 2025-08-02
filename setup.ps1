# Agent Architect Setup Script for Windows PowerShell
# This script installs Agent Architect files to your system

param(
    [switch]$OverwriteInstructions,
    [switch]$OverwriteStandards,
    [switch]$Help
)

# Show help if requested
if ($Help) {
    Write-Host "Usage: .\setup.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -OverwriteInstructions    Overwrite existing instruction files"
    Write-Host "  -OverwriteStandards       Overwrite existing standards files"
    Write-Host "  -Help                     Show this help message"
    Write-Host ""
    exit 0
}

# Set error action preference to stop on errors
$ErrorActionPreference = "Stop"

Write-Host "🚀 Agent Architect Setup Script for Windows"
Write-Host "===================================="
Write-Host ""

# Base URL for raw GitHub content
$BaseUrl = "https://raw.githubusercontent.com/jalalhejazi/agent-architect/main"

# Get user's home directory
$HomeDir = $env:USERPROFILE
$AgentArchitectDir = Join-Path $HomeDir ".agent-architect"

# Create directories
Write-Host "📁 Creating directories..."
$Directories = @(
    (Join-Path $AgentArchitectDir "standards"),
    (Join-Path $AgentArchitectDir "standards\code-style"),
    (Join-Path $AgentArchitectDir "instructions"),
    (Join-Path $AgentArchitectDir "instructions\core"),
    (Join-Path $AgentArchitectDir "instructions\meta")
)

foreach ($Dir in $Directories) {
    if (!(Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

# Function to download file with overwrite logic
function Download-File {
    param(
        [string]$Url,
        [string]$LocalPath,
        [bool]$ShouldOverwrite,
        [string]$FileType
    )
    
    $Exists = Test-Path $LocalPath
    $ShouldDownload = !$Exists -or $ShouldOverwrite
    
    if ($Exists -and !$ShouldOverwrite) {
        Write-Host "  ⚠️  $LocalPath already exists - skipping"
        return
    }
    
    try {
        Invoke-WebRequest -Uri $Url -OutFile $LocalPath -UseBasicParsing
        if ($Exists -and $ShouldOverwrite) {
            Write-Host "  ✓ $LocalPath (overwritten)"
        } else {
            Write-Host "  ✓ $LocalPath"
        }
    }
    catch {
        Write-Host "  ❌ Failed to download $LocalPath`: $($_.Exception.Message)"
    }
}

# Download standards files
Write-Host ""
Write-Host "📥 Downloading standards files to $AgentArchitectDir\standards\"

$StandardsFiles = @(
    @{Url = "$BaseUrl/standards/tech-stack.md"; LocalPath = Join-Path $AgentArchitectDir "standards\tech-stack.md"},
    @{Url = "$BaseUrl/standards/code-style.md"; LocalPath = Join-Path $AgentArchitectDir "standards\code-style.md"},
    @{Url = "$BaseUrl/standards/best-practices.md"; LocalPath = Join-Path $AgentArchitectDir "standards\best-practices.md"}
)

foreach ($File in $StandardsFiles) {
    Download-File -Url $File.Url -LocalPath $File.LocalPath -ShouldOverwrite $OverwriteStandards -FileType "standards"
}

# Download code-style subdirectory files
Write-Host ""
Write-Host "📥 Downloading code style files to $AgentArchitectDir\standards\code-style\"

$CodeStyleFiles = @(
    @{Url = "$BaseUrl/standards/code-style/css-style.md"; LocalPath = Join-Path $AgentArchitectDir "standards\code-style\css-style.md"},
    @{Url = "$BaseUrl/standards/code-style/html-style.md"; LocalPath = Join-Path $AgentArchitectDir "standards\code-style\html-style.md"},
    @{Url = "$BaseUrl/standards/code-style/javascript-style.md"; LocalPath = Join-Path $AgentArchitectDir "standards\code-style\javascript-style.md"}
)

foreach ($File in $CodeStyleFiles) {
    Download-File -Url $File.Url -LocalPath $File.LocalPath -ShouldOverwrite $OverwriteStandards -FileType "standards"
}

# Download instruction files
Write-Host ""
Write-Host "📥 Downloading instruction files to $AgentArchitectDir\instructions\"

# Core instruction files
Write-Host "  📂 Core instructions:"

$CoreInstructionFiles = @(
    @{Url = "$BaseUrl/instructions/core/plan-product.md"; LocalPath = Join-Path $AgentArchitectDir "instructions\core\plan-product.md"},
    @{Url = "$BaseUrl/instructions/core/create-spec.md"; LocalPath = Join-Path $AgentArchitectDir "instructions\core\create-spec.md"},
    @{Url = "$BaseUrl/instructions/core/execute-tasks.md"; LocalPath = Join-Path $AgentArchitectDir "instructions\core\execute-tasks.md"},
    @{Url = "$BaseUrl/instructions/core/execute-task.md"; LocalPath = Join-Path $AgentArchitectDir "instructions\core\execute-task.md"},
    @{Url = "$BaseUrl/instructions/core/analyze-product.md"; LocalPath = Join-Path $AgentArchitectDir "instructions\core\analyze-product.md"}
)

foreach ($File in $CoreInstructionFiles) {
    Download-File -Url $File.Url -LocalPath $File.LocalPath -ShouldOverwrite $OverwriteInstructions -FileType "instructions"
}

# Meta instruction files
Write-Host ""
Write-Host "  📂 Meta instructions:"

$MetaInstructionFiles = @(
    @{Url = "$BaseUrl/instructions/meta/pre-flight.md"; LocalPath = Join-Path $AgentArchitectDir "instructions\meta\pre-flight.md"}
)

foreach ($File in $MetaInstructionFiles) {
    Download-File -Url $File.Url -LocalPath $File.LocalPath -ShouldOverwrite $OverwriteInstructions -FileType "instructions"
}

Write-Host ""
Write-Host "✅ Agent Architect base installation complete!"
Write-Host ""
Write-Host "📍 Files installed to:"
Write-Host "   $AgentArchitectDir\standards\     - Your development standards"
Write-Host "   $AgentArchitectDir\instructions\  - Agent Architect instructions"
Write-Host ""

if (!$OverwriteInstructions -and !$OverwriteStandards) {
    Write-Host "💡 Note: Existing files were skipped to preserve your customizations"
    Write-Host "   Use -OverwriteInstructions or -OverwriteStandards to update specific files"
} else {
    Write-Host "💡 Note: Some files were overwritten based on your flags"
    if (!$OverwriteInstructions) {
        Write-Host "   Existing instruction files were preserved"
    }
    if (!$OverwriteStandards) {
        Write-Host "   Existing standards files were preserved"
    }
}

Write-Host ""
Write-Host "Next steps:"
Write-Host ""
Write-Host "1. Customize your coding standards in $AgentArchitectDir\standards\"
Write-Host ""
Write-Host "2. Install commands for your AI coding assistant(s):"
Write-Host ""
Write-Host "   - Using Claude Code? Install the Claude Code commands with:"
Write-Host "     Invoke-WebRequest -Uri https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup-claude-code.ps1 -OutFile setup-claude-code.ps1; .\setup-claude-code.ps1"
Write-Host ""
Write-Host "   - Using Cursor? Install the Cursor commands with:"
Write-Host "     Invoke-WebRequest -Uri https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup-cursor.ps1 -OutFile setup-cursor.ps1; .\setup-cursor.ps1"
Write-Host ""
Write-Host "   - Using something else? See instructions at https://github.com/jalalhejazi/agent-architect"
Write-Host ""
Write-Host "Learn more at https://github.com/jalalhejazi/agent-architect"
Write-Host "" 