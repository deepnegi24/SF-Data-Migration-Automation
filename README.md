# Salesforce Data Loader Process Configuration

## Overview
This `process-conf.xml` file is a Spring configuration file for Salesforce Data Loader that defines automated data loading processes for various Salesforce objects. It contains pre-configured beans for inserting and updating data in a Salesforce preprod environment.

## File Structure
The configuration file is built using Spring Framework's bean definitions and contains multiple `ProcessRunner` beans, each representing a specific data loading operation.

## Configured Processes

### Available Operations
The following data loading processes are configured:

| Bean ID | Description | Salesforce Object | Operation | Batch Size |
|---------|-------------|-------------------|-----------|------------|
| `insert_Account` | Insert Account records | Account | upsert | 500 |
| `insert_Contact` | Insert Contact records | Contact | upsert | 200 |
| `insert_Contract` | Insert Contract records | Contract | upsert | 200 |
| `update_Contract` | Update Contract records | Contract | upsert | 200 |
| `insert_Case` | Insert Case records | Case | upsert | 100 |

## Configuration Parameters

### Salesforce Connection Settings
- **Environment**: Salesforce Test/Preprod (`https://test.salesforce.com`)
- **Username**: `kuldeep.negi@company.co.nz.test.preprod`
- **Authentication**: Password-based (OAuth disabled)
- **Debug Messages**: Enabled for troubleshooting

### Data Processing Settings
- **Data Format**: CSV files with UTF-8 encoding
- **Date Format**: European format (`dd/MM/yyyy`)
- **External ID Field**: `RecordId__c` (used for upsert operations)
- **CSV Validation**: Disabled for faster processing

### File Paths Structure
```
Data Input Files:     C:\Users\kuldeep.negi\dataloader_win_v56.0.6\data\
Mapping Files:        C:\Users\kuldeep.negi\dataloader_win_v56.0.6\mapping\
Success Reports:      C:\NR Report\Reports\
Error Reports:        C:\NR Report\Reports\
```

## Prerequisites

### Software Requirements
- Salesforce Data Loader v56.0.6 or compatible version
- Java Runtime Environment
- Windows operating system (paths are Windows-specific)

### File Dependencies
Ensure the following files exist before running processes:

#### Input CSV Files
- `Account.csv` - Account data for insertion
- `Contact.csv` - Contact data for insertion  
- `Contract.csv` - Contract data for insertion
- `Contract_Update.csv` - Contract data for updates
- `Case.csv` - Case data for insertion

#### Mapping Files (.sdl)
- `Account_Mapping.sdl`
- `Contact_Mapping.sdl`
- `Contract_Mapping.sdl`
- `Contract_Mapping_Update.sdl`
- `Case_Mapping.sdl`

## Usage Instructions

### Running a Process
1. **Via Data Loader UI**: Select the desired process from the process picker
2. **Via Command Line**: 
   ```cmd
   process.bat -p "process_name"
   ```
   Example: `process.bat -p "insert_Account"`

### Monitoring Results
After each process execution, check the output directories:
- **Success logs**: `C:\NR Report\Reports\[ObjectName]_success.csv`
- **Error logs**: `C:\NR Report\Reports\[ObjectName]_error.csv`

## Security Considerations

⚠️ **Important Security Notes**:
- This file contains encrypted Salesforce credentials
- Store this file securely and restrict access
- Never commit unencrypted passwords to version control
- Regularly rotate passwords and update the configuration
- Use environment-specific configurations for different deployments

## Customization

### Modifying Batch Sizes
Adjust the `sfdc.batchSize` value based on:
- Data complexity
- Salesforce API limits
- Performance requirements
- Error handling needs

### Adding New Processes
To add a new object process:
1. Copy an existing bean definition
2. Update the `id` and `name` properties
3. Modify the `sfdc.entity` value
4. Update file paths for data, mapping, and output files
5. Adjust batch size as needed

### Environment Migration
When moving to different environments:
1. Update `sfdc.endpoint` (production: `https://login.salesforce.com`)
2. Change `sfdc.username` to target environment user
3. Update `sfdc.password` with new encrypted password
4. Modify file paths to match target system structure

## Troubleshooting

### Common Issues
1. **Authentication Failures**: Verify username/password and endpoint URL
2. **File Not Found**: Ensure all input CSV and mapping files exist
3. **Permission Errors**: Check Salesforce user permissions for target objects
4. **Batch Size Errors**: Reduce batch size for complex data or large records

### Debug Mode
Debug messages are enabled (`sfdc.debugMessages=true`) for detailed logging. Check Data Loader logs for detailed error information.


## Related Files
- `config.properties` - Global Data Loader configuration
- Field mapping files (*.sdl) - Define field relationships between CSV and Salesforce
- Input CSV files - Source data for processing
- Log files - Process execution results and errors
