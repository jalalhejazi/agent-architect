# Agent Architect Cursor Setup Script for Windows PowerShell
# This script installs Agent Architect commands for Cursor in the current project

param(
    [switch]$Help
)

# Show help if requested
if ($Help) {
    Write-Host "Usage: .\setup-cursor.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Help                     Show this help message"
    Write-Host ""
    exit 0
}

# Set error action preference to stop on errors
$ErrorActionPreference = "Stop"

Write-Host "🚀 Agent Architect Cursor Setup for Windows"
Write-Host "===================================="
Write-Host ""

# Check if Agent Architect base installation is present
$HomeDir = $env:USERPROFILE
$AgentArchitectInstructions = Join-Path $HomeDir ".agent-architect\instructions"
$AgentArchitectStandards = Join-Path $HomeDir ".agent-architect\standards"

if (!(Test-Path $AgentArchitectInstructions) -or !(Test-Path $AgentArchitectStandards)) {
    Write-Host "⚠️  Agent Architect base installation not found!"
    Write-Host ""
    Write-Host "Please install the Agent Architect base installation first:"
    Write-Host ""
    Write-Host "Option 1 - Automatic installation:"
    Write-Host "  Invoke-WebRequest -Uri https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup.ps1 -OutFile setup.ps1; .\setup.ps1"
    Write-Host ""
    Write-Host "Option 2 - Manual installation:"
    Write-Host "  Follow instructions at https://github.com/jalalhejazi/agent-architect"
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "📁 Creating .cursor\rules directory..."
$CursorRulesDir = ".cursor\rules"
if (!(Test-Path $CursorRulesDir)) {
    New-Item -ItemType Directory -Path $CursorRulesDir -Force | Out-Null
}

# Base URL for raw GitHub content
$BaseUrl = "https://raw.githubusercontent.com/jalalhejazi/agent-architect/main"

Write-Host ""
Write-Host "📥 Downloading and setting up Cursor command files..."

# Function to process a command file
function Process-CommandFile {
    param(
        [string]$Command
    )
    
    $TempFile = Join-Path $env:TEMP "${Command}.md"
    $TargetFile = Join-Path $CursorRulesDir "${Command}.md"
    
    try {
        # Download the file
        Invoke-WebRequest -Uri "${BaseUrl}/commands/${Command}.md" -OutFile $TempFile -UseBasicParsing
        
        # Create the front-matter and append original content
        $FrontMatter = @"
---
alwaysApply: false
---

"@
        
        # Read the original content
        $OriginalContent = Get-Content $TempFile -Raw
        
        # Combine front-matter with original content
        $CombinedContent = $FrontMatter + $OriginalContent
        
        # Write to target file
        Set-Content -Path $TargetFile -Value $CombinedContent -NoNewline
        
        # Clean up temp file
        Remove-Item $TempFile -Force
        
        Write-Host "  ✓ .cursor\rules\${Command}.md"
    }
    catch {
        Write-Host "  ❌ Failed to download ${Command}.md`: $($_.Exception.Message)"
        return $false
    }
    
    return $true
}

# Process each command file
$Commands = @("plan-product", "create-spec", "execute-tasks", "analyze-product")

foreach ($Cmd in $Commands) {
    Process-CommandFile -Command $Cmd
}

Write-Host ""
Write-Host "✅ Agent Architect Cursor setup complete!"
Write-Host ""
Write-Host "📍 Files installed to:"
Write-Host "   .cursor\rules\             - Cursor command rules"
Write-Host ""
Write-Host "Next steps:"
Write-Host ""
Write-Host "Use Agent Architect commands in Cursor with @ prefix:"
Write-Host "  @plan-product    - Initiate Agent Architect in a new product's codebase"
Write-Host "  @analyze-product - Initiate Agent Architect in an existing product's codebase"
Write-Host "  @create-spec     - Initiate a new feature (or simply ask 'what's next?')"
Write-Host "  @execute-tasks    - Build and ship code"
Write-Host ""
Write-Host "Learn more at https://github.com/jalalhejazi/agent-architect"
Write-Host "" 