# Agent Architect Setup Script for Windows PowerShell
# This script installs Agent Architect files to your system

param(
    [switch]$OverwriteInstructions,
    [switch]$OverwriteStandards,
    [switch]$Silent,
    [switch]$Help
)

# Show help if requested
if ($Help) {
    Write-Host "Usage: .\setup.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -OverwriteInstructions    Overwrite existing instruction files"
    Write-Host "  -OverwriteStandards       Overwrite existing standards files"
    Write-Host "  -Silent                   Run without prompts (for automated installation)"
    Write-Host "  -Help                     Show this help message"
    Write-Host ""
    Write-Host "Quick Install from GitHub:"
    Write-Host "  iwr -useb https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup.ps1 | iex"
    Write-Host ""
    exit 0
}

# Set error action preference to stop on errors
$ErrorActionPreference = "Stop"

# Check if running from remote execution
$IsRemoteExecution = $MyInvocation.MyCommand.Path -eq $null
if ($IsRemoteExecution -and !$Silent) {
    Write-Host "🌐 Running Agent Architect Setup directly from GitHub"
    Write-Host "====================================================="
} else {
    Write-Host "🚀 Agent Architect Setup Script for Windows"
    Write-Host "===================================="
}
Write-Host ""

# Test network connectivity
if (!$Silent) {
    Write-Host "🔗 Testing network connectivity..."
    try {
        $null = Invoke-WebRequest -Uri "https://raw.githubusercontent.com" -Method Head -UseBasicParsing -TimeoutSec 10
        Write-Host "✓ Network connection successful"
    }
    catch {
        Write-Host "❌ Network connectivity issue detected"
        Write-Host "Please check your internet connection and try again."
        Write-Host "Error: $($_.Exception.Message)"
        exit 1
    }
    Write-Host ""
}

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

# Function to download file with overwrite logic and retry
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
        if (!$Silent) { Write-Host "  ⚠️  $LocalPath already exists - skipping" }
        return $true
    }
    
    $MaxRetries = 3
    $RetryDelay = 2
    
    for ($i = 1; $i -le $MaxRetries; $i++) {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $LocalPath -UseBasicParsing -TimeoutSec 30
            if ($Exists -and $ShouldOverwrite) {
                if (!$Silent) { Write-Host "  ✓ $LocalPath (overwritten)" }
            } else {
                if (!$Silent) { Write-Host "  ✓ $LocalPath" }
            }
            return $true
        }
        catch {
            if ($i -eq $MaxRetries) {
                if (!$Silent) { 
                    Write-Host "  ❌ Failed to download $LocalPath after $MaxRetries attempts"
                    Write-Host "     Error: $($_.Exception.Message)"
                }
                return $false
            } else {
                if (!$Silent) { Write-Host "  ⚠️  Retry $i/$MaxRetries for $LocalPath..." }
                Start-Sleep -Seconds $RetryDelay
            }
        }
    }
    return $false
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
if ($IsRemoteExecution) {
    Write-Host "✅ Agent Architect successfully installed from GitHub!"
} else {
    Write-Host "✅ Agent Architect base installation complete!"
}
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
Write-Host "   📦 Claude Code (direct install):"
Write-Host "     iwr -useb https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup-claude-code.ps1 | iex"
Write-Host ""
Write-Host "   🎯 Cursor (direct install):"
Write-Host "     iwr -useb https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup-cursor.ps1 | iex"
Write-Host ""
Write-Host "   - Using something else? See instructions at https://github.com/jalalhejazi/agent-architect"
Write-Host ""
Write-Host "Learn more at https://github.com/jalalhejazi/agent-architect"
Write-Host "" 