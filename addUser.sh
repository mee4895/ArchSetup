#!/bin/bash

# open fd
exec 3>&1
# get and store user input
VALUES=$(dialog --ok-label "Create User" \
	--backtitle "Mee's Arch Setup" \
	--title "New sudo user" \
	--form "Enter username and fullname of the new user" \
	9	60	0 \
	" Username:"	1	1	""	1	12	42	0 \
	" Fullname:"	2	1	""	2	12	42	0 \
2>&1 1>&3)
# close fd
exec 3>&-

# parse the values variable to its sub parts
username=$(echo "$VALUES" | sed -n 1p)
fullname=$(echo "$VALUES" | sed -n 2p)


# Add sudo group if it doesn't exist
if grep -q -E "^sudo:" /etc/group; then true; else
	groupadd -r sudo
fi


# Create the user
useradd -c "$fullname" -G sudo $username

# Create the home directory
mkdir /home/$username
chown $username:$username /home/$username

# Set the password
clear && passwd $username

# Setup the home directory
su -c "./gitignore.mkf" $username
