#!/bin/bash

# --------------------------------------------------------------------------------------------
# Part 1: Account Creation

# check if user is already present or not,
# user_status is a global variable used in other parts of script
# id -u "$username" will return the id of user if exists, otherwise error
# /dev/null is the black hole directory, the data gets deleted in this dir.
# so if id returns error write them in this file.
check_user()
{
    if id -u "$username" &>/dev/null;
    then
        user_status="true"
    else
        user_status="false"
    fi
}


# create user
# if user already present exit and try again, otherwise create new user.
# -s flag hides password input for security (no visible typing)
# chpasswd is used in place of passwd because it take password from user once.
# and passwd will take password twice, chpasswd take username as well for mapping the password.
create_user()
{
    echo "Creating new User..."
    read -p "Enter the username: " username
    check_user "$username"
    if [ "$user_status" == "true" ];
    then
        echo "User already exists, try again"
        exit 1
    fi

    sudo useradd $username
    read -s -p "Enter the password: " password
    printf "$username:$password" | sudo chpasswd
    echo
    echo "User '$username' created successfully!"
}

# ---------------------------------------------------------------------------------------------
# Part 2: Account Deletion

# Delete the user if present
delete_user()
{
    read -p "Enter the username: " username
    check_user "$username"

    if [ "$user_status" == "true" ];
    then
        sudo userdel $username
        echo "User deleted successfully!"
    else
        echo "User does not exists"
        exit 1
    fi

}

# ---------------------------------------------------------------------------------------------
# Part 3: Password Reset

# reset password for known user
reset_password()
{
    read -p "Enter the username: " username
    check_user "$username"

    if [ "$user_status" == "true" ];
    then
        read -s -p "Enter the password: " password
        echo "$username:$password" | sudo chpasswd
        echo
    else
        echo "User does not exists"
        exit 1
    fi

    echo "User '$username' password is reset successfully!"

}

# ---------------------------------------------------------------------------------------------
# Part 4: List User Accounts

# list all user
list_users()
{
    echo "User   UID"
    awk -F: '$3 >= 1000 {print $1, $3}' /etc/passwd

}


# ---------------------------------------------------------------------------------------------
# Part 5: Help and Usage Information
commands_available()
{
    echo "Select from these commands for user management"
    echo "-c or --create for creating the new user"
    echo "-d or --delete for deleting the user"
    echo "-r or --reset for reseting the password for known user"
    echo "-l or --list for listing all the users"
    echo "-h or --help for commands available for user management"
}



# ---------------------------------------------------------------------------------------------
# main function
# "$1" using "" around variable, will not throw error if empty value is passed.
main()
{
    if [[ "$1" == '-c' || "$1" == "--create" ]];
    then
        create_user

    elif [[ "$1" == '-d' || "$1" == "--delete" ]];
    then
        delete_user

    elif [[ "$1" == '-r' || "$1" == "--reset" ]];
    then
        reset_password

    elif [[ "$1" == '-l' || "$1" == "--list" ]];
    then
        list_users

    elif [[ "$1" == '-h' || "$1" == "--help" ]];
    then
        commands_available
    else
        echo "type -h for commands help!"
    fi
}

main "$@"