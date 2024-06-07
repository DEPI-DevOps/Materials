# Linux-Related Cheat Sheets

> [Recommended video](https://www.youtube.com/watch?v=gd7BXuUQ91w)

## 1 – SYSTEM INFORMATION

```bash
# Display Linux system information
uname -a

# Display kernel release information
uname -r

# Show operating system information such as distribution name and version
cat /etc/os-release

# Show how long the system has been running + load
uptime

# Show system host name
hostname

# Display all local IP addresses of the host.
hostname -I

# Show system reboot history
last reboot

# Show the current date and time
date

# Show this month's calendar
cal

# Display who is online
w

# Who you are logged in as
whoami
```

## 2 – HARDWARE INFORMATION

```bash
# Display messages in kernel ring buffer
dmesg

# Display CPU information
cat /proc/cpuinfo

# Display memory information
cat /proc/meminfo

# Display free and used memory ( -h for human readable, -m for MB, -g for GB.)
free -h

# Display PCI devices
lspci -tv

# Display USB devices
lsusb -tv

# Display DMI/SMBIOS (hardware info) from the BIOS
dmidecode

# Show info about disk sda
hdparm -i /dev/sda

# Perform a read speed test on disk sda
hdparm -tT /dev/sda

# Test for unreadable blocks on disk sda
badblocks -s /dev/sda
```

## 3 – PERFORMANCE MONITORING AND STATISTICS

```bash
# Display and manage the top processes
top

# Interactive process viewer (top alternative)
htop

# Display processor related statistics
mpstat 1

# Display virtual memory statistics
vmstat 1

# Display I/O statistics
iostat 1

# Display the last 100 syslog messages  (Use /var/log/syslog for Debian based systems.)
tail -100 /var/log/messages

# Capture and display all packets on interface eth0
tcpdump -i eth0

# Monitor all traffic on port 80 ( HTTP )
tcpdump -i eth0 'port 80'

# List all open files on the system
lsof

# List files opened by user
lsof -u user

# Display free and used memory ( -h for human readable, -m for MB, -g for GB.)
free -h

# Execute "df -h", showing periodic updates
watch df -h
```

## 4 – USER INFORMATION AND MANAGEMENT

```bash
# Display the user and group ids of your current user.
id

# Display the last users who have logged onto the system.
last

# Show who is logged into the system.
who

# Show who is logged in and what they are doing.
w

# Create a group named "test".
groupadd test

# Create an account named john, with a comment of "John Smith" and create the user's home directory.
useradd -c "John Smith" -m john

# Delete the john account.
userdel john

# Add the john account to the sales group
usermod -aG sales john
```

## 5 – FILE AND DIRECTORY COMMANDS

```bash
# List all files in a long listing (detailed) format
ls -al

# Display the present working directory
pwd

# Create a directory
mkdir directory

# Remove (delete) file
rm file

# Remove the directory and its contents recursively
rm -r directory

# Force removal of file without prompting for confirmation
rm -f file

# Forcefully remove directory recursively
rm -rf directory

# Copy file1 to file2
cp file1 file2

# Copy source_directory recursively to destination. If destination exists, copy source_directory into destination, otherwise create destination with the contents of source_directory.
cp -r source_directory destination

# Rename or move file1 to file2. If file2 is an existing directory, move file1 into directory file2
mv file1 file2

# Create symbolic link to linkname
ln -s /path/to/file linkname

# Create an empty file or update the access and modification times of file.
touch file

# View the contents of file
cat file

# Browse through a text file
less file

# Display the first 10 lines of file
head file

# Display the last 10 lines of file
tail file

# Display the last 10 lines of file and "follow" the file as it grows.
tail -f file
```

## 6 – PROCESS MANAGEMENT

```bash
# Display your currently running processes
ps

# Display all the currently running processes on the system.
ps -ef

# Display process information for processname
ps -ef | grep processname

# Display and manage the top processes
top

# Interactive process viewer (top alternative)
htop

# Kill process with process ID of pid
kill pid

# Kill all processes named processname
killall processname

# Start program in the background
program &

# Display stopped or background jobs
bg

# Brings the most recent background job to foreground
fg

# Brings job n to the foreground
fg n
```

## 7 – FILE PERMISSIONS

```bash
        PERMISSION      EXAMPLE

         U   G   W
        rwx rwx rwx     chmod 777 filename
        rwx rwx r-x     chmod 775 filename
        rwx r-x r-x     chmod 755 filename
        rw- rw- r--     chmod 664 filename
        rw- r-- r--     chmod 644 filename

# NOTE: Use 777 sparingly!

        LEGEND
        U = User
        G = Group
        W = World

        r = Read
        w = write
        x = execute
        - = no access
```

## 8 – NETWORKING

```bash
# Display all network interfaces and IP address
ip a

# Display eth0 address and details
ip addr show dev eth0

# Query or control network driver and hardware settings
ethtool eth0

# Send ICMP echo request to host
ping host

# Display whois information for domain
whois domain

# Display DNS information for domain
dig domain

# Reverse lookup of IP_ADDRESS
dig -x IP_ADDRESS

# Display DNS IP address for domain
host domain

# Display the network address of the host name.
hostname -i

# Display all local IP addresses of the host.
hostname -I

# Download http://domain.com/file
wget http://domain.com/file

# Display listening tcp and udp ports and corresponding programs
netstat -nutlp
```

## 9 – ARCHIVES (TAR FILES)

```bash
# Create tar named archive.tar containing directory.
tar cf archive.tar directory

# Extract the contents from archive.tar.
tar xf archive.tar

# Create a gzip compressed tar file name archive.tar.gz.
tar czf archive.tar.gz directory

# Extract a gzip compressed tar file.
tar xzf archive.tar.gz

# Create a tar file with bzip2 compression
tar cjf archive.tar.bz2 directory

# Extract a bzip2 compressed tar file.
tar xjf archive.tar.bz2
```

## 10 – INSTALLING PACKAGES (Red Hat)

```bash
# Search for a package by keyword.
yum search keyword

# Install package.
yum install package

# Display description and summary information about package.
yum info package

# Install package from local file named package.rpm
rpm -i package.rpm

# Remove/uninstall package.
yum remove package

# Install software from source code.
tar zxvf sourcecode.tar.gz
cd sourcecode
./configure
make
make install
```

## 11 – SEARCH

```bash
# Search for pattern in file
grep pattern file

# Search recursively for pattern in directory
grep -r pattern directory

# Find files and directories by name
locate name

# Find files in /home/john that start with "prefix".
find /home/john -name 'prefix*'

# Find files larger than 100MB in /home
find /home -size +100M
```

## 12 – SSH LOGINS

```bash
# Connect to host as your local username.
ssh host

# Connect to host as user
ssh user@host

# Connect to host using port
ssh -p port user@host
```

## 13 – FILE TRANSFERS

```bash
# Secure copy file.txt to the /tmp folder on server
scp file.txt server:/tmp

# Copy *.html files from server to the local /tmp folder.
scp server:/var/www/*.html /tmp

# Copy all files and directories recursively from server to the current system's /tmp folder.
scp -r server:/var/www /tmp

# Synchronize /home to /backups/home
rsync -a /home /backups/

# Synchronize files/directories between the local and remote system with compression enabled
rsync -avz /home server:/backups/
```

## 14 – DISK USAGE

```bash
# Show free and used space on mounted filesystems
df -h

# Show free and used inodes on mounted filesystems
df -i

# Display disks partitions sizes and types
fdisk -l

# Display disk usage for all files and directories in human readable format
du -ah

# Display total disk usage off the current directory
du -sh
```

## 15 – DIRECTORY NAVIGATION

```bash
# To go up one level of the directory tree.  (Change into the parent directory.)
cd ..

# Go to the $HOME directory
cd

# Change to the /etc directory
cd /etc
```

## 16 – SECURITY

```bash
# Change the current user's password.
passwd

# Switch to the root account with root's environment. (Login shell.)
sudo -i

# Execute your current shell as root. (Non-login shell.)
sudo -s

# List sudo privileges for the current user.
sudo -l

# Edit the sudoers configuration file.
visudo

# Display the current SELinux mode.
getenforce

# Display SELinux details such as the current SELinux mode, the configured mode, and the loaded policy.
sestatus

# Change the current SELinux mode to Permissive. (Does not survive a reboot.)
setenforce 0

# Change the current SELinux mode to Enforcing. (Does not survive a reboot.)
setenforce 1

# Set the SELinux mode to enforcing on boot by using this setting in the /etc/selinux/config file.
SELINUX=enforcing

# Set the SELinux mode to permissive on boot by using this setting in the /etc/selinux/config file.
SELINUX=permissive

# Set the SELinux mode to disabled on boot by using this setting in the /etc/selinux/config file.
SELINUX=disabled
```

## 17 – LOGGING AND AUDITING

```bash
# Display messages in kernel ring buffer.
dmesg

# Display logs stored in the systemd journal.
journalctl

# Display logs for a specific unit (service).
journalctl -u servicename
```



## **Linux Directory hierarchy**

> [Recommended Article](https://www.geeksforgeeks.org/linux-file-hierarchy-structure/) and [Video](https://www.youtube.com/watch?v=42iQKuQodW4)

- `/` is the root directory, parent to all others

- `/bin`: binaries (e.g., `ls`, `cp`, …) 

- `/boot`: static files for boot loader.

- `/dev`: contains files for external devices attached to the system, (USBs, display, keyboard) as well as `/dev/null` 

- `/etc`: config files local to the machine.

- `/home`: contains a subfolder for each normal (non-system) user with their name, containing user desktop files, documents, etc.

- `/lib`: software libraries shared by programs (e.g., `ld*`,`lib`, `*.so.*`)

- `/media`: mounted file systems of removable media (e.g., flash memory)

- `/mnt`: temporarily mounted file systems (user can mount FSs there)

- `/proc`: contains information about running processes, their memory and CPU utilization. 

- `/root`: home directory for root, hidden from user, contains system files.

- `/var`: dynamic files; constantly being written to or changed (websites are typically stored there)

- `/srv` site-specific data served by the file system.

- `/sbin` binaries used by root (e.g., `fsck`)

- `/tmp` temporary files, cleaned regularly on boot or by a job

- `/usr` contains user application, typically stored under `/usr/local` 

- `/opt` for optional application addons.

## **Special Characters, Shell Variables, and Shortcuts**

- **Some special characters in bash.**

  ```bash
  ~	Home directory	
  #	Comment	
  $	Variable expression
  &	Background job	
  *	String wildcard	
  (	Start subshell	
  )	End subshell	
  \	Escape next character	
  |	Pipe (send output of left as input to right)
  [	Start character-set wildcard	
  ]	End character-set wildcard	
  {	Start command block	
  }	End command block	
  ;	Shell command separator	
  '	Strong quote (quotes everyting until next ') 
  "	Weak quote ($ is evaluated inside)
  <	Input redirect	
  >	Output redirect	
  2>	Stderr redirect
  >>	Append to file
  /	Pathname directory separator	
  ?	Single-character wildcard	
  &&	logical AND
  ||	logical OR
  !	logical NOT
  .	This directory
  ..	Parent directory
  ```

- **Special $ shell variables**

  ```bash
  $1, $2,...	are the positional parameters.
  $@	is an array-like construct of all positional parameters.
  $*	is the IFS expansion of all positional parameters.
  $#	is the number of positional parameters.
  $-	current options set for the shell.
  $$	pid of the current shell (not subshell).
  $_	most recent parameter (or the abs path of the command to start the current shell immediately after startup).
  $IFS	is the (input) field separator.
  $?	is the most recent foreground pipeline exit status.
  $!	is the PID of the most recent background command.
  $0	is the name of the shell or shell script.
  ```

- **Some CTRL shortcuts**

  ```bash
  CTRL+A	Move to the beginnging of the line
  CTRL+E	Move to the beginnging of the line
  CTRL+C	Interrup (SIGINT) the currently running command
  CTRL+L	Clear screen keeping the last line
  CTRL+R	Reverse shell (search for command in history)
  CTRL+X	Lists possible filename completions
  CTRL+Z	Suspend (SIGSTP) executing command, resume with fg|bg <PID>
  ```

