@echo off
echo Starting Salesforce Data Load Sequence...
pause

    :: Step 1 - Insert Account
    echo Running insert_Account process...
    call C:\Users\kuldeep.negi\dataloader_win_v56.0.6\bin\process.bat C:\Users\kuldeep.negi\dataloader_win_v56.0.6\process insert_Account
    if %ERRORLEVEL% neq 0 (
        echo insert_Account failed. Aborting sequence.
        exit /b %ERRORLEVEL%
    )
    echo insert_Account completed successfully.

    :: Step 2 - Insert Contacts
    echo Running insert_Contact process...
    call C:\Users\kuldeep.negi\dataloader_win_v56.0.6\bin\process.bat C:\Users\kuldeep.negi\dataloader_win_v56.0.6\process insert_Contact
    if %ERRORLEVEL% neq 0 (
        echo insert_Contact failed. Aborting sequence.
        exit /b %ERRORLEVEL%
    )
    echo insert_contacts completed successfully.

    :: Step 3 - Insert Contracts
    echo Running insert_Contract process...
    call C:\Users\kuldeep.negi\dataloader_win_v56.0.6\bin\process.bat C:\Users\kuldeep.negi\dataloader_win_v56.0.6\process insert_Contract
    if %ERRORLEVEL% neq 0 (
        echo insert_Contract failed. Aborting sequence.
        exit /b %ERRORLEVEL%
    )
    echo insert_contracts completed successfully.

    :: Step 4 - Update Contracts
    echo Running update_Contract process...
    call C:\Users\kuldeep.negi\dataloader_win_v56.0.6\bin\process.bat C:\Users\kuldeep.negi\dataloader_win_v56.0.6\process update_Contract
    if %ERRORLEVEL% neq 0 (
        echo update_Contract failed. Aborting sequence.
        exit /b %ERRORLEVEL%
    )
    echo update_Contracts completed successfully.

    :: Step 5 - Insert Cases
    echo Running insert_Case process...
    call C:\Users\kuldeep.negi\dataloader_win_v56.0.6\bin\process.bat C:\Users\kuldeep.negi\dataloader_win_v56.0.6\process insert_Case
    if %ERRORLEVEL% neq 0 (
        echo insert_Case failed. Aborting sequence.
        exit /b %ERRORLEVEL%
    )
    echo insert_Cases completed successfully.
  
    
echo All processes completed successfully.
pause