# Agent Architect Setup

This directory contains PowerShell setup scripts for Agent Architect on Windows.

## Quick Start

Open PowerShell and run:
```powershell
.\setup.ps1
```

## Available Options

The PowerShell script supports the following options:

- `-OverwriteInstructions` - Overwrite existing instruction files
- `-OverwriteStandards` - Overwrite existing standards files  
- `-Help` - Show help message

### Examples:
```powershell
# Show help
.\setup.ps1 -Help

# Overwrite all files
.\setup.ps1 -OverwriteInstructions -OverwriteStandards

# Only overwrite standards
.\setup.ps1 -OverwriteStandards
```

## Troubleshooting

### Execution Policy Error
If you get an execution policy error, you can:

1. **Run PowerShell as Administrator** and set execution policy:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
2. **Bypass for this session only**:
   ```powershell
   PowerShell -ExecutionPolicy Bypass -File setup.ps1
   ```

### Network Issues
If downloads fail, check:
- Your internet connection
- Firewall settings
- Proxy configuration (if applicable)

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

1. **Customize your standards** in the `standards` directory
2. **Install AI assistant commands**:
   - For Claude Code: Download and run `setup-claude-code.ps1`
   - For Cursor: Download and run `setup-cursor.ps1`

## Support

For more information, visit: https://github.com/jalalhejazi/agent-architect

