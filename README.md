# Agent Architect Setup

Easy installation of Agent Architect from GitHub using PowerShell.

## Quick Start

**Download and run method** - copy and paste this into PowerShell:

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
# Basic installation
Invoke-WebRequest -Uri https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup.ps1 -OutFile setup.ps1; .\setup.ps1

# Silent installation for automation
Invoke-WebRequest -Uri https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup.ps1 -OutFile setup.ps1; .\setup.ps1 -Silent

# With overwrite options
Invoke-WebRequest -Uri https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup.ps1 -OutFile setup.ps1; .\setup.ps1 -OverwriteInstructions -OverwriteStandards
```

## Troubleshooting

### Execution Policy Error
If you get an execution policy error:

1. **Run PowerShell as Administrator** and set execution policy:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
2. **Bypass for this session**:
   ```powershell
   PowerShell -ExecutionPolicy Bypass -File setup.ps1
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
2. **Install AI assistant commands** (download method):
   ```powershell
   # For Claude Code
   Invoke-WebRequest -Uri https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup-claude-code.ps1 -OutFile setup-claude-code.ps1; .\setup-claude-code.ps1
   
   # For Cursor  
   Invoke-WebRequest -Uri https://raw.githubusercontent.com/jalalhejazi/agent-architect/main/setup-cursor.ps1 -OutFile setup-cursor.ps1; .\setup-cursor.ps1
   ```

## Support

For more information, visit: https://github.com/jalalhejazi/agent-architect

