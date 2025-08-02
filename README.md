# Agent Architect Setup

Easy installation of Agent Architect directly from GitHub using PowerShell.

## Quick Start (Recommended)

**One-line installation** - copy and paste this into PowerShell:

```powershell
iwr -useb https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup.ps1 | iex
```

**Alternative method** if you prefer to download first:
```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup.ps1 -OutFile setup.ps1; .\setup.ps1
```

## Available Options

The PowerShell script supports the following options:

- `-OverwriteInstructions` - Overwrite existing instruction files
- `-OverwriteStandards` - Overwrite existing standards files  
- `-Silent` - Run without prompts (for automated installation)
- `-Help` - Show help message

### Examples:
```powershell
# Direct installation (recommended)
iwr -useb https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup.ps1 | iex

# Silent installation for automation
iex "& { $(iwr -useb https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup.ps1) } -Silent"

# Download first, then run with options
.\setup.ps1 -OverwriteInstructions -OverwriteStandards
```

## Troubleshooting

### Execution Policy Error
If you get an execution policy error with direct installation:

1. **Run PowerShell as Administrator** and set execution policy:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
2. **Bypass for direct installation**:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; iwr -useb https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup.ps1 | iex
   ```

### Network Issues
If downloads fail, check:
- Your internet connection
- Firewall settings
- Proxy configuration (if applicable)

### Display Issues
The setup scripts use ASCII symbols `[>] [+] [*] [i] [!] [-]` for maximum PowerShell compatibility across all Windows versions and terminal configurations.

### File Permission Issues
If you get permission errors:
- Run PowerShell as Administrator
- Check that you have write access to your user directory

## What Gets Installed

The PowerShell script installs Agent Architect files to:
- `%USERPROFILE%\.agent-architect\standards\` - Development standards
- `%USERPROFILE%\.agent-architect\instructions\` - Agent Architect instructions

## Next Steps

After installation, you can:

1. **Customize your standards** in `%USERPROFILE%\.agent-architect\standards\`
2. **Install AI assistant commands** (direct from GitHub):
   ```powershell
   # For Claude Code
   iwr -useb https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup-claude-code.ps1 | iex
   
   # For Cursor  
   iwr -useb https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup-cursor.ps1 | iex
   ```

## Support

For more information, visit: https://github.com/jalalhejazi/agent-architect

