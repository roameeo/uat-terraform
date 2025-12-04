# Add SQL Server login for UAT\udtsqlsvc
$query = @"
USE master;
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'UAT\udtsqlsvc')
BEGIN
    CREATE LOGIN [UAT\udtsqlsvc] FROM WINDOWS;
    ALTER SERVER ROLE sysadmin ADD MEMBER [UAT\udtsqlsvc];
    PRINT 'Login created successfully';
END
ELSE
BEGIN
    PRINT 'Login already exists';
END
"@

Invoke-Sqlcmd -Query $query -ServerInstance 'localhost' -TrustServerCertificate
Write-Host "SQL login configuration completed"
