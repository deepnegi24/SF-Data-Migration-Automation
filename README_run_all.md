# Salesforce Data Loader Batch Execution Script (run_all.bat)

## Overview
The `run_all.bat` script is an automated batch execution script that runs a sequence of Salesforce Data Loader processes in a predetermined order. It provides error handling, progress monitoring, and ensures data dependencies are respected during the loading process.

## Purpose
This script automates the complete data loading workflow for Salesforce objects, eliminating the need to manually execute each process individually. It's designed to handle data dependencies by executing processes in the correct sequence.

## Execution Sequence

The script runs the following processes in this specific order:

| Step | Process ID | Salesforce Object | Operation | Purpose |
|------|------------|-------------------|-----------|---------|
| 1 | `insert_Account` | Account | Upsert | Load customer/company records first |
| 2 | `insert_Contact` | Contact | Upsert | Load contacts (depends on Accounts) |
| 3 | `insert_Contract` | Contract | Upsert | Load contracts (depends on Accounts) |
| 4 | `update_Contract` | Contract | Upsert | Update contract records with additional data |
| 5 | `insert_Case` | Case | Upsert | Load support cases (depends on Accounts/Contacts) |

### Why This Order Matters
- **Accounts First**: Other objects reference Account records
- **Contacts After Accounts**: Contact records link to Account records
- **Contracts After Accounts**: Contract records are associated with Account records
- **Contract Updates**: Separate process for updating contract data
- **Cases Last**: Case records can reference both Accounts and Contacts

## Prerequisites

### Software Requirements
- Salesforce Data Loader v56.0.6 installed at: `C:\Users\kuldeep.negi\dataloader_win_v56.0.6\`
- Windows Command Prompt or PowerShell
- Valid Salesforce credentials configured in `process-conf.xml`

### File Dependencies
Ensure all required files exist before execution:

#### Input Data Files
- `C:\Users\kuldeep.negi\dataloader_win_v56.0.6\data\Account.csv`
- `C:\Users\kuldeep.negi\dataloader_win_v56.0.6\data\Contact.csv`
- `C:\Users\kuldeep.negi\dataloader_win_v56.0.6\data\Contract.csv`
- `C:\Users\kuldeep.negi\dataloader_win_v56.0.6\data\Contract_Update.csv`
- `C:\Users\kuldeep.negi\dataloader_win_v56.0.6\data\Case.csv`

#### Configuration Files
- `process-conf.xml` - Process definitions
- All required `.sdl` mapping files
- `config.properties` - Global configuration

#### Output Directories
Ensure these directories exist and are writable:
- `C:\NR Report\Reports\` - For success and error logs

## Usage Instructions

### Running the Script

1. **Open Command Prompt as Administrator** (recommended for file access permissions)

2. **Navigate to the script directory**:
   ```cmd
   cd "C:\Users\kuldeep.negi\Desktop\Process Config"
   ```

3. **Execute the script**:
   ```cmd
   run_all.bat
   ```

4. **Follow the prompts**:
   - The script will pause initially - press any key to start
   - Monitor the console output for progress updates
   - The script will pause at the end - press any key to close

### Alternative Execution Methods

#### Double-click Execution
- Simply double-click `run_all.bat` in Windows Explorer
- Command prompt window will open and show progress

#### Scheduled Execution
For automated runs, use Windows Task Scheduler:
```cmd
schtasks /create /tn "Salesforce Data Load" /tr "C:\path\to\run_all.bat" /sc daily /st 09:00
```

## Script Behavior

### Error Handling
- **Fail-Fast Approach**: If any process fails, the entire sequence stops
- **Error Codes**: Each process returns an error level that the script checks
- **Abort on Failure**: Prevents data inconsistencies by stopping on errors
- **Error Reporting**: Clear console messages indicate which process failed

### Progress Monitoring
The script provides real-time feedback:
```
Starting Salesforce Data Load Sequence...
Running insert_Account process...
insert_Account completed successfully.
Running insert_Contact process...
insert_contacts completed successfully.
...
All processes completed successfully.
```

### Logging
- **Console Output**: Real-time progress and status messages
- **Data Loader Logs**: Individual process logs in Data Loader directories
- **Success/Error Files**: CSV files in `C:\NR Report\Reports\` directory

## Troubleshooting

### Common Issues

#### Script Fails to Start
**Error**: `'C:\Users\kuldeep.negi\dataloader_win_v56.0.6\bin\process.bat' is not recognized`
**Solution**: 
- Verify Data Loader installation path
- Update the path in the batch file if installation directory differs

#### Process Fails Mid-Sequence
**Error**: `insert_Account failed. Aborting sequence.`
**Solutions**:
1. Check Salesforce connectivity and credentials
2. Verify input CSV file exists and is properly formatted
3. Review Data Loader logs for specific error details
4. Check Salesforce user permissions

#### Permission Errors
**Error**: Access denied to files or directories
**Solutions**:
- Run Command Prompt as Administrator
- Check file and folder permissions
- Ensure output directories exist and are writable

#### Data Dependency Errors
**Error**: Process succeeds but data relationships are missing
**Solutions**:
- Ensure parent records (Accounts) are loaded before child records
- Check external ID fields are properly mapped
- Verify CSV data contains correct reference values

### Debug Mode
For detailed troubleshooting:
1. Open `process-conf.xml`
2. Ensure `sfdc.debugMessages` is set to `true` for all processes
3. Review detailed logs in Data Loader log directory

### Manual Recovery
If the script fails partway through:
1. Identify the failed process from console output
2. Fix the underlying issue (data, permissions, connectivity)
3. Either:
   - Re-run the entire script (if using upsert operations)
   - Run individual processes from the failure point using Data Loader UI

## Customization

### Modifying Execution Order
To change the process sequence:
1. Reorder the process calls in the batch file
2. Ensure data dependencies are maintained
3. Test thoroughly with sample data

### Adding New Processes
To include additional processes:
```batch
:: Step N - Insert New Object
echo Running insert_NewObject process...
call C:\Users\kuldeep.negi\dataloader_win_v56.0.6\bin\process.bat C:\Users\kuldeep.negi\dataloader_win_v56.0.6\process insert_NewObject
if %ERRORLEVEL% neq 0 (
    echo insert_NewObject failed. Aborting sequence.
    exit /b %ERRORLEVEL%
)
echo insert_NewObject completed successfully.
```

### Environment Adaptation
For different environments or users:
1. Update the Data Loader installation path
2. Modify the process configuration directory path
3. Ensure all file paths match the target environment

### Optimization Tips
1. **Batch Size Tuning**: Adjust batch sizes in `process-conf.xml` based on:
   - Network performance
   - Salesforce API limits
   - System memory availability

2. **Data Preparation**: 
   - Remove unnecessary columns from CSV files
   - Sort data for better processing efficiency
   - Validate data before processing

## Security Considerations

⚠️ **Important Security Notes**:
- Script inherits security settings from `process-conf.xml`
- Ensure secure storage of configuration files
- Run with minimum required permissions
- Monitor execution logs for sensitive data exposure
- Consider using secure credential storage methods

### Related Documentation
- `README.md` - Process configuration documentation
- `process-conf.xml` - Individual process definitions
- Data Loader official documentation

### Change Log
When modifying this script:
1. Document changes in comments
2. Test with sample data first
3. Update this README with any new requirements or procedures
4. Backup working configurations before changes

## Quick Reference

### Essential Commands
```batch
# Run the complete sequence
run_all.bat

# Check if Data Loader is accessible
C:\Users\kuldeep.negi\dataloader_win_v56.0.6\bin\process.bat

# Run individual process (if needed)
C:\Users\kuldeep.negi\dataloader_win_v56.0.6\bin\process.bat C:\Users\kuldeep.negi\dataloader_win_v56.0.6\process insert_Account
```

### Key File Locations
- **Script**: `run_all.bat`
- **Process Config**: `process-conf.xml`  
- **Data Loader**: `C:\Users\kuldeep.negi\dataloader_win_v56.0.6\`
- **Reports**: `C:\NR Report\Reports\`
- **Input Data**: `C:\Users\kuldeep.negi\dataloader_win_v56.0.6\data\`
