##############################################################################################################################
#
# powershell script to create image of SQL in docker
#
# Links :
#      https://docs.microsoft.com/en-us/sql/linux/tutorial-restore-backup-in-sql-server-container?view=sql-server-ver15
#      https://blog.sqlauthority.com/2019/03/06/sql-server-how-to-get-started-with-docker-containers-with-latest-sql-server/
#
##############################################################################################################################


# Clear the host output window
    clear

# Get latest SQL image
docker pull mcr.microsoft.com/mssql/server:2019-latest

# Create SQL container
#
#  Modify -v C:\Projects\Docker:/sql to your location that contains the SQL backup file
#

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Pass@Word1" `
-p 11143:1433 --name sql19-local `
-v C:\Projects\Docker:/sql `
-d mcr.microsoft.com/mssql/server:2019-latest

# start container
docker start sql19-local

# show status of all containers 	
docker container ls -a

# Create backup folder in the container
    docker exec -it sql19-local mkdir /var/opt/mssql/backup

# Download backup file
curl -OutFile "wwi.bak" "https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak"

# Use docker cp to copy the backup file into the container in the /var/opt/mssql/backup directory.
docker cp wwi.bak sql19-local:/var/opt/mssql/backup

# Restore database
docker exec -it sql19-local /opt/mssql-tools/bin/sqlcmd -S localhost `
   -U SA -P "Pass@Word1" `
   -Q "RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/backup/wwi.bak'"
#
docker exec -it sql19-local /opt/mssql-tools/bin/sqlcmd `
   -S localhost -U SA -P "Pass@Word1" `
   -Q "RESTORE DATABASE WideWorldImporters FROM DISK = '/var/opt/mssql/backup/wwi.bak' WITH MOVE 'WWI_Primary' TO '/var/opt/mssql/data/WideWorldImporters.mdf', MOVE 'WWI_UserData' TO '/var/opt/mssql/data/WideWorldImporters_userdata.ndf', MOVE 'WWI_Log' TO '/var/opt/mssql/data/WideWorldImporters.ldf', MOVE 'WWI_InMemory_Data_1' TO '/var/opt/mssql/data/WideWorldImporters_InMemory_Data_1'"
#
# Verify restore
docker exec -it sql19-local /opt/mssql-tools/bin/sqlcmd `
   -S localhost -U SA -P "Pass@Word1" `
   -Q "SELECT Name FROM sys.Databases"

#
############################################
#
#  SSMS
#
#  1. Open SSMS
#  2. ServerName : localhost,11143
#  3. Login      : sa
#  4. password   : Pass@Word1
#
############################################
#
# Manual download sample backup file from
#  https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0