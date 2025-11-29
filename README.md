# Administrative-Tool-Kit-Windows-and-Linux-

This project provides a beginner-friendly toolkit for automating common system administrative tasks on both Windows and Linux environments. The toolkit uses CSV datasets to simulate organizational user data and directories. This enables bulk user management, automated log rotation and system health reporting. 





## Project Overview
This toolkit was specifically designed to simplify and streamline common admin tasks on Windows and Linux systems. Using sample datasets and simulated organizational directories, this toolkit automates user management, log rotation and system health monitoring. The main objective of our toolkit is to reduce human error and improve operational efficiency for organizations. In addition, this toolkits produces daily reports to assess the success of the toolkit and report any issues on the system. 
## Disclaimers
- Admin privileges need to be given in order to successfully run scripts
- Each system and organization is different, requiring careful customization of scripts to work best for your organization
- Naming conventions or paths can be altered as needed to fit the organization. For example, "Employees.csv" can be altered if necessary. 
- Default passwords given to newly created user accounts need to be changed in a timely manner to avoid unwanted access by threat actors 
- Automation in our toolkit was performed at 2pm (Windows) 2:45pm (Linux) to work best for our academic schedule. Times should be changed accordingly to best fit the organization. Recommended time for automation is during off-peak hours (ex: 3am) as to not interfere with organizational tasks. 
## Project Relevance
Effective and timely system administration is a crucial component of cybersecurity. Manual management of user accounts, log files and system health is not only time-consuming but also prone to human error, putting organizations and companies at risk of data breaches or cyber attacks. This toolkit addresses those concerns by automating routine admin tasks, ensuring consistency and efficiency. 

We chose this project because it demonstrates how automation can enhance an organization's operational functions and security. Working with this toolkit allows students and professionals to easily strengthen their user management, log analysis and reporting- all of which are fundamental components of cybersecurity. 
## Methodology
1. Setup and Environment:
- This project was implemented using two virtual machines to simulate a real-world enterprise environment
- Windows 11 and Ubuntu/Linux
- Both machines were running with administrative privileges in order to successfully run tasks
- CSV's titled "Employees.csv" and "TerminatedUsers.csv" were used to handle user management tasks to simulate real-world conditions

2. Tools, Frameworks & Datasets
- PowerShell was used in the Windows environment
- Bash was used in the Ubuntu/Linux environment
- Employees.csv contains sample employee data for bulk creation, deletion and department assignments
- TerminatedUsers.csv contains sample data for automated deletion
- Sample directories (Logs, Backups) and log files were used for testing log rotation and compression
- Scripts generate system health metrics saved as dated reports

3. Architecture/Workflow
- User Management: bulk creates users from CSV, assign users to department-based groups, and bulk delete users listed in TerminatedUsers.csv
- Log Management: identify logs other than a customizable threshold, move old logs to backup folders, compress moved logs into dated ZIP archives and delete logs from original folder to avoid duplication and save space
- System Health Checks: gather metrics (disk usage, memory usage, user activity) and save reports in a dedicated SystemHealthChecks folder
- Master Automation: the master script (MasterAutomation) orchestrates all child scripts, and are scheduled to run at a customizable time that works best for the organization. In addition, the MasterAutomation script collects logs and errors from all scripts and generates a master summary which is compressed into a ZIP file. 

4. Step-by-step Process

Environment Setup:
- Install Windows VM or Ubuntu Linux and grant admin privileges
- Create project directories (AdminToolKit, OrgData, Logs, Backups)

Data Preparation:
- Download designated CSV's for employee data (Employees.csv and TerminatedUsers.csv)
- Create sample organizational directories and log files to simulate real-world conditions

Script Development (Windows)
- BulkCreateUsers: creates users based on CSV data
- BulkDeleteUsers: deletes terminated users
- BulkAssignDepartments: creates department groups and assigns users based on employee data
- ArchiveOldLogs: moves and compresses old logs
- SystemHealthChecks: generates system health reports
  
Script Development (Linux)
- create_project_files.sh: creates project directories 
- create_users.sh: creates users based on CSV data
- bulk_delete_users.sh: deletes terminated users
- create_users_departments.sh: creates department groups and assigns users based on employee data
- log_manager.sh: moves and compresses old logs
- backup_orgdata.sh: compress orgdata to backups
- system_health.sh: generates system health reports

Automation
- Combine all scripts into MasterAutomation script
-Schedule daily execution at a customizable time

Testing and Verification
- All scripts were ran on small public datasets first obtained by: Kaggle.com
- Verified the success of the scripts and then further tested their success on AI-generated datasets (ChatGPT was used to create large datasets of 500+ employees so that our toolkit could be tested on new, never-before-seen data)

Error Reporting
- Master script captures errors from scripts
- Compresses all logs and the summary into a dated ZIP archive for review
## Visual Aids
The visual below illustrates the folder setup for the Admin Toolkit (Windows)
![pic4](https://github.com/user-attachments/assets/0a5559ca-6966-473e-b9d4-dc5317500938)

The visual below illustrates the folder setup for the Admin Toolkit (Ubuntu/Linux)

![UbuntuBashLinuxWorkflow2](https://github.com/user-attachments/assets/16aea8b4-f79f-4c75-b700-65590f78a71d)

## Results (Screenshots)
1. Windows

The image below shows a successful setup (Windows)
<img width="811" height="287" alt="Screen Shot 2025-11-28 at 5 58 40 PM" src="https://github.com/user-attachments/assets/e3b9a869-c90e-4778-be4f-9508eee633ea" />

The image below shows users being created from the CSV file (Windows)
<img width="1097" height="633" alt="519- Users created" src="https://github.com/user-attachments/assets/262ec1ae-95fc-461c-a201-78293e6811cd" />

The two images below show the successful assignment of users to their corresponding departments (Windows)
<img width="1013" height="673" alt="519 Assign Users Code" src="https://github.com/user-attachments/assets/b8528685-c0c8-4a5d-b288-877eccb9e296" />
<img width="1147" height="632" alt="519 Created Groups Success" src="https://github.com/user-attachments/assets/c464418e-d462-441b-97d4-03ee61e987b1" />

The two images below show the successful rotation and compression of log files (Windows)
<img width="1005" height="590" alt="519 archived logs prood" src="https://github.com/user-attachments/assets/caf921e0-f1b3-424b-83b2-11fe3ed89a00" />
<img width="954" height="276" alt="519 archive old logs code success" src="https://github.com/user-attachments/assets/bddd050d-728a-481d-a5a9-17a7cf21ed5b" />

The image below shows a System Health Check report that is created when our script is ran (Windows)
<img width="744" height="563" alt="519 system health checks report" src="https://github.com/user-attachments/assets/b2aa30ee-eb04-4cf6-a412-d548e1550b3f" />

The image below shows a successful run of the automated scripts and gives the user a report showing that each task was successful (Windows)

<img width="748" height="546" alt="519 Successful Run" src="https://github.com/user-attachments/assets/36eb51dd-0d07-47f6-8294-f2ada092fcd3" />


2. Ubuntu/Linux
The image below shows a successful setup (Linux-Bash) with the AdminToolKit and Tools folders

<img width="749" height="58" alt="create_desktop_admintoolkit" src="https://github.com/user-attachments/assets/6df9b16a-8389-4ba8-aac1-aa747639a2a4" />

<img width="805" height="61" alt="create_desktop_admintoolkit2" src="https://github.com/user-attachments/assets/1cbd6fbd-ea16-45ee-b305-87d21e420217" />

<img width="798" height="29" alt="Screenshot 2025-11-28 204221" src="https://github.com/user-attachments/assets/daa103ea-45c4-47ff-baac-acb093e8541d" />

The image below shows moved sample CSV file for employee management into the folder: 
<img width="1076" height="71" alt="move employees csv to toolkit" src="https://github.com/user-attachments/assets/a5708b76-0b44-45d6-9db7-68d9c24c4c70" />

The image below shows the script that automatically configures all permissions forever:
<img width="1200" height="526" alt="setup privs" src="https://github.com/user-attachments/assets/7b00f690-103f-4fc1-8aaf-ad4160459239" />

The images below shows users being created from the CSV file (Linux), by creating a script (nano) and making it executable (chmod +x) 

**Note your file path should be ~/Desktop/AdminToolKit/Tools/create_users.sh***
<img width="809" height="328" alt="Screenshot 2025-11-28 215431" src="https://github.com/user-attachments/assets/0137b0d7-02df-4545-aa08-a6e9d0a7309c" />

<img width="810" height="135" alt="users created" src="https://github.com/user-attachments/assets/fdb4fb37-a6f0-4659-aeb5-91e8385f1d72" />

<img width="580" height="52" alt="users processed" src="https://github.com/user-attachments/assets/9629990c-420a-4d45-b3cf-f207a22f9b78" />

The images below show the successful assignment of users to their corresponding departments (Linux)

**Note your file path should be ~/Desktop/AdminToolKit/Tools/create_users_departments.sh***

<img width="811" height="351" alt="Screenshot 2025-11-28 215546" src="https://github.com/user-attachments/assets/a28cd8a7-1b07-469f-bd26-c02500dc4fc1" />


<img width="906" height="352" alt="user groups employees" src="https://github.com/user-attachments/assets/127a6b3d-1657-4765-a743-aee29e346f32" />

<img width="992" height="258" alt="users processed groups" src="https://github.com/user-attachments/assets/fca1c549-27a0-4827-a798-88ff6b569b26" />

The images below show the creation of log_manager.sh script for successful rotation and compression of log files (Linux)

**Note your file path should be ~/Desktop/AdminToolKit/Tools/log_manager.sh***

<img width="812" height="379" alt="Screenshot 2025-11-28 215208" src="https://github.com/user-attachments/assets/8c629a72-b6f2-4a8c-9070-4c945639eb83" />

<img width="886" height="538" alt="Screenshot 2025-11-28 215054" src="https://github.com/user-attachments/assets/1d8e95df-eb93-4877-ad18-f3a6d182f0e6" />

The image below shows the creation of the master_automation.sh script that automates all the sysadmin tasks: 

<img width="1090" height="465" alt="master_automation" src="https://github.com/user-attachments/assets/d0a90a9a-e391-4e10-983b-e790ee37d4ef" />

The image below is the automation summary success txt output after running: 

<img width="708" height="515" alt="summary success" src="https://github.com/user-attachments/assets/7c56e395-e408-4613-a591-18a5cf5819a2" />

The images below shows a System Health Check report that is created when our script is ran (Linux)

<img width="736" height="262" alt="report folder_sys health" src="https://github.com/user-attachments/assets/a93cfa50-7737-436f-948c-264b8b0cc8e8" />

<img width="693" height="442" alt="system health report text editor" src="https://github.com/user-attachments/assets/78b4b650-fb3a-4fe8-b775-fff3ce03b7ba" />

The image below shows the AdminToolKit after all tasks have been automated with the zipped Daily Report file: 


<img width="705" height="540" alt="Screenshot 2025-11-28 211116" src="https://github.com/user-attachments/assets/e69f2829-e4ef-4683-b29b-c9689d35709d" />


## Conclusion
The Administrative Toolkit demonstrates how repetitive administrative tasks can be streamlined to reduce human error and improve operational efficiency in a simulated enterprise environment. 
## Our key findings: ##
- Automation simplifies routine tasks, freeing administrators from time-consuming manual work.
- Error handling and reporting are crucial to identify which aspect of the toolkit is causing an error. This ensures transparency and allows administrators to quickly identify and resolve issues.
- Scalability and flexibility are critical to operate in real-world environments. Every organization is different and has different operational structures, making flexibility a critical component of administative toolkits. 

## Lessons Learned ##
- Data validation and sanitization help prevent runtime errors
- Ubuntu/Linux and Windows have separate security conditions, making each user experience slightly different
- Testing with small datasets first is essential before scaling to large datasets to quickly identify errors and perfect scripts
- Shell scripting requires careful consideration of whitespace
- When scripts require admin/root privileges, grant only the minimum permissions required to run safely- not full unrestricted control.
- Ubuntu/Linux had more obstacles related to password controls and security, making Windows a better and less complex environment for beginners. 

## Potential Next Steps ##
In the future, we hope to add encryption and password management for user accounts. We had to use default passwords for user account creation, which could be a potential security risk. In addition, we hope to integrate real-time monitoring dashboards for system health metrics.

## Target Audience ##
This toolkit and methodology is perfect for IT and system administrators seeking automation solutions for daily tasks. It is especially useful for medium-small sized organizations looking to standardize administrative processes. In addition, this toolkit is useful for cybersecurity students wanting hands-on experience in scripting, log management and user account management.
