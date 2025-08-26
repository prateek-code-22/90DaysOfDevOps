# Task - 1 User & Group Management
# Create a user devops_user and add them to a group devops_team.
# Set a password and grant sudo access.
# Restrict SSH login for certain users in /etc/ssh/sshd_config.

# to create devops_user
sudo useradd devops_user

# to create devops_team group
sudo groupadd devops_team

# add the "devops_user" user to "devops_team" group
sudo gpasswd -a devops_user devops_team

# add password for user
sudo passwd devops_user

# give sudo access to user
sudo usermod -aG sudo devops_user

# edit ssh config file to restrict users 
sudo nano /etc/ssh/sshd_config

# add this line in file to allow users
AllowUsers user1 user2

# to deny users add this line
DenyUsers user1 user2

# -----------------------------------------------------------------------
# Task 2 - File & Directory Permissions
# Create /devops_workspace and a file project_notes.txt.
# Set permissions:
# Owner can edit, group can read, others have no access.
# Use ls -l to verify permissions.

# to create directory 
mkidr devops_workspace

# create file 
touch project_notes.txt

# setting permission to file, by default was 644(owner-read/write, group-read, other-read)
chmod 640 project_notes.txt

# -----------------------------------------------------------------------
# TASK 3 -  Log File Analysis with AWK, Grep & Sed
# Logs are crucial in DevOps! You’ll analyze logs using the Linux_2k.log file from LogHub (GitHub Repo).

# Download the log file from the repository.
# Extract insights using commands:
# Use grep to find all occurrences of the word "error".
# Use awk to extract timestamps and log levels.
# Use sed to replace all IP addresses with [REDACTED] for security.
# Bonus: Find the most frequent log entry using awk or sort | uniq -c | sort -nr | head -10

# to find all occurrences of the word "error".
grep -i error Linux_2k.log

# awk to extract timestamps and log levels
awk '/{print $1}' Linux_2k.log

# -E: Enables extended regex.
# The pattern ([0-9]{1,3}\.){3}[0-9]{1,3} matches IPv4 addresses.
# /g replaces all occurrences on each line.
# sed to replace all IP addresses with [REDACTED] for security
sed -E 's/([0-9]{1,3}\.){3}[0-9]{1,3}/[REDACTED]/g' Linux_2k.log


# Find the most frequent log entry using awk or sort | uniq -c | sort -nr | head -10
sort Linux_2k.log | uniq -c | sort -nr | head -1

# -----------------------------------------------------------------------
#  Volume Management & Disk Usage
# Create a directory /mnt/devops_data.
# Mount a new volume (or loop device for local practice).
# Verify using df -h and mount | grep devops_data.

sudo mkdir /mnt/devops_data

# dd = low-level copy command (used to make disk images).
# if=/dev/zero = input file is a special device that gives endless 0s (blank data).
# of=/dev/loop_devops.img = output file, this will be your fake “disk file”.
# bs=1M = block size of 1 megabyte.
# count=1024 = number of blocks.
# This creates a 1 GB empty file (1 MB × 1024 = 1024 MB = 1 GB) that we’ll treat like a disk.

sudo dd if=/dev/zero of=/dev/loop_devops.img bs=1M count=1024

# Format it with ext4 so linux store file/dir
sudo mkfs.ext4 /dev/loop_devops.img

# mount 
sudo mount -o loop /dev/loop_devops.img /mnt/devops_data

# verify 
df -h | grep devops_data





