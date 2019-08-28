!/bin/bash
#File: addressbook.sh
#Name: Casey Grove
#Email: caseg1@umbc.edu
#
#From the command line, manage a simple address book in the home directory 
#Users can add, remove, and search entries


dir=~/.book/
file=$dir/book_data.txt

mkdir -p $dir
touch $file
#test -f $file || touch $file

if [ "$1" == "help" ]; then
    echo "--addressbook.sh HELP--
help -you're here!
add -takes first name, last name, email
  duplicates permitted
remove -takes first and last name
  Y to confirm removal, N to not remove
search -takes last name and returns all matches
  flags can change input type (can use both simultaneously)
    --whole-name  -searches both first and last name fields
    --email       -searches only the email field"

    #ADD
elif [ "$1" == "add" ]; then
    
    #validating num of input parameters
    if [ -z $2 ] || [ -z $3 ] || [ -z $4 ]; then
	echo -e "ERROR: missing parameters
Usage: ./addressbook.sh add FIRST LAST EMAIL" && exit 1;
    fi
    echo "$2 $3 $4" >> $file
    
    #REMOVE
elif [ "$1" == "remove" ]; then
    confirm=N
    exists=N
    
    #validating num of input parameters
    if [[ -z $2  ||  -z $3 ]]; then
	echo -e "ERROR: missing parameters
Usage: ./addressbook.sh remove FIRST LAST" && exit 1;
    fi

    #the &3 and done 3< necessary for reading file and user input to stdin at same time
    while IFS=" " read -r fname lname email <&3;
    do
	if [[ $fname =~ ${2} && $lname =~ ${3} ]]; then
	    read -p "Would you like to delete $fname $lname, with email address $email? (Y/N)" confirm
	    exists=Y
	    
	    if [[ $confirm == Y ]]; then
		sed -i "/$fname\s$lname\s$email/d" $file
	    fi
	    
	fi
    done 3< "$file"

    #did not find person to remove
    if [ $exists == N ]; then
       echo "ERROR: Could not find $2 $3"
    fi
       
    #SEARCH (very inefficiently done && ugly)
elif [ "$1" == "search" ]; then

    #validating num of input parameters
    if [ -z $2 ]; then
	echo -e "ERROR: missing parameters
Usage: ./addressbook.sh search LAST
       ./addressbook.sh search EMAIL --email
       ./addressbook.sh search FIRST LAST --whole-name
       ./addressbook.sh search FIRST LAST EMAIL --email --whole-name" && exit 1;
    fi

    #both flags
    if [ $6 ]; then
	echo "The following results were found for $2 $3 $4:"
	printf "First Name%-10s Last Name%-12s Email%-12s\n"
	echo "---------------------------------------------------";
	while IFS=" " read -r fname lname email
	do
	    if [[ $fname =~ ${2} && $lname =~ ${3} && $email =~ ${4} ]]; then
		printf "%-20s %-21s %-12s\n" $fname $lname $email;
	    fi
	done < "$file"

	#whole-name flag
    elif [[ $4 == "--whole-name" ]] && [[ -z $5 ]]; then
	echo "The following results were found for $2 $3:"
	printf "First Name%-10s Last Name%-12s Email%-12s\n"
	echo "---------------------------------------------------";
	while IFS=" " read -r fname lname email
	do
	    if [[ $fname =~ ${2} && $lname =~ ${3} ]]; then
		printf "%-20s %-21s %-12s\n" $fname $lname $email;
	    fi
	done < "$file"

	#email flag
    elif [[ $3 == "--email" ]] && [[ -z $4 ]]; then
	echo "The following results were found for $2:"
	printf "First Name%-10s Last Name%-12s Email%-12s\n"
	echo "---------------------------------------------------";
	while IFS=" " read -r fname lname email
	do
	    if [[ $email =~ ${2} ]]; then
		printf "%-20s %-21s %-12s\n" $fname $lname $email;
	    fi
	done < "$file"
	
	#default last name
    elif [ $2 ] && [ -z $3 ]; then
	echo "The following results were found for $2:"
	printf "First Name%-10s Last Name%-12s Email%-12s\n"
	echo "---------------------------------------------------";    
	while IFS=" " read -r fname lname email
	do
	    if [[ $lname =~ ${2} ]]; then
		printf "%-20s %-21s %-12s\n" $fname $lname $email;
	    fi
	done < "$file"

	#This might be unreachable
    else
	echo -e "Error: parameter error
Usage: ./addressbook.sh search LAST
       ./addressbook.sh search EMAIL --email
       ./addressbook.sh search FIRST LAST --whole-name
       ./addressbook.sh search FIRST LAST EMAIL --email --whole-name" && exit 1; 
    fi
    
    #ERROR
else
    echo "Error: unrecognized command"
fi
