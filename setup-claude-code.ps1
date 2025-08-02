# Agent Architect Claude Code Setup Script for Windows PowerShell
# This script installs Agent Architect agents for Claude Code

param(
    [switch]$Help
)

# Show help if requested
if ($Help) {
    Write-Host "Usage: .\setup-claude-code.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Help                     Show this help message"
    Write-Host ""
    exit 0
}

# Set error action preference to stop on errors
$ErrorActionPreference = "Stop"

Write-Host "🚀 Agent Architect Claude Code Setup for Windows"
Write-Host "========================================="
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
Write-Host "📁 Creating .claude-code/agents directory..."
$ClaudeCodeAgentsDir = ".claude-code\agents"
if (!(Test-Path $ClaudeCodeAgentsDir)) {
    New-Item -ItemType Directory -Path $ClaudeCodeAgentsDir -Force | Out-Null
}

# Base URL for raw GitHub content
$BaseUrl = "https://raw.githubusercontent.com/jalalhejazi/agent-architect/main"

Write-Host ""
Write-Host "📥 Downloading and setting up Claude Code agent files..."

# Function to download agent file
function Download-AgentFile {
    param(
        [string]$AgentName
    )
    
    $Url = "${BaseUrl}/claude-code/agents/${AgentName}.md"
    $LocalPath = Join-Path $ClaudeCodeAgentsDir "${AgentName}.md"
    
    try {
        Invoke-WebRequest -Uri $Url -OutFile $LocalPath -UseBasicParsing
        Write-Host "  ✓ .claude-code\agents\${AgentName}.md"
    }
    catch {
        Write-Host "  ❌ Failed to download ${AgentName}.md`: $($_.Exception.Message)"
        return $false
    }
    
    return $true
}

# Download each agent file
$Agents = @("context-fetcher", "file-creator", "git-workflow", "test-runner")

foreach ($Agent in $Agents) {
    Download-AgentFile -AgentName $Agent
}

Write-Host ""
Write-Host "✅ Agent Architect Claude Code setup complete!"
Write-Host ""
Write-Host "📍 Files installed to:"
Write-Host "   .claude-code\agents\     - Claude Code agent files"
Write-Host ""
Write-Host "Next steps:"
Write-Host ""
Write-Host "Use Agent Architect agents in Claude Code:"
Write-Host "  context-fetcher  - Fetches context from your codebase"
Write-Host "  file-creator     - Creates new files with proper structure"
Write-Host "  git-workflow     - Manages Git operations and workflows"
Write-Host "  test-runner      - Runs and manages tests"
Write-Host ""
Write-Host "Learn more at https://github.com/jalalhejazi/agent-architect"
Write-Host "" 