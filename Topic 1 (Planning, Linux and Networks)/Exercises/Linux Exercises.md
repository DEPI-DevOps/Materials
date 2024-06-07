# Linux System Administration Tutorials

> Follow along with these guided exercises to practice essential Linux system administration tasks

[TOC]

## Exercise 1: Finding your way around Linux

- Check the distribution of Linux you have just installed

  ```bash
  lsb_release -a
  ```

- Check the username of the user who is currently logged on to the local system

  ```
  whoami
  ```

- View all currently logged in users

  ```
  users
  ```

- View the content of your current working directory

  ```
  pwd
  ```

- List the content of your current directory

  ```
  ls -lah
  ```

  >**Output fields explanation:**
  >
  >```
  >-rw-rw-r--  1 user group 3.4K Jul 24 10:27  file.txt
  >```
  >
  >1. **File permissions**
  >   - 1st bit can be `d` for directory, `-` for file, `s` for socket `p` for pipe, `D` for Door, `l` for symlinks, `c` for character special files.
  >   - 1st triple: owner permissions, 2nd: group, 3rd: everyone.
  >   - Numerical representation: `1=x, 2=w, 4=r`, thus: `3=-wx, 5=r-x, 6=rw-, 7=rws` which can be used with `chmod` alternative to `chmod +|-` syntax.
  >2. **Number of hard links to the file**
  >3. **Owning user**
  >4. **Owning user group**
  >5. **File size**
  >6. **Last modified date**
  >7. **File name.**

- Navigate to another directory

  ```
  cd ~/Downloads
  ```

- Check your current working directory again.

- View all shells installed on the machine

  > A shell is a program that provides an interface for the user to interact with the operating system. It gathers input (commands) from the user, executes them, and return the output when necessary. The terminal where you type your command is a shell.

  ```
  $ cat /etc/shells
  ```

- View the shell you are currently using

  ```
  echo "$SHELL"
  ```

- Check the manual for any command using `man`. Example:

  ```
  man ls
  ```



## Exercise 2: Command-line and file manipulation

### Part 1: echo, pipes, redirects and quotes

- On your machine login with password. Open terminal. Check your location

  ```
  pwd
  ```

- Create a directory

  ```
  mkdir mydocs
  ```

- Change directory

  ```
  cd mydocs
  ```

- Create file

  ```
  touch textproc
  ```

- Check directory

  ```
  ls -la
  ```

- Copy the files from the 

  ```
  /home/$USER/mydocs/textproc
  ```

   directory into your home directory

  ```
  cd ..
  cp -R mydocs/textproc ~ 
  ```

- Type in the following in a shell

  ```
  echo "My name is $USER and my home directory is $HOME" > simple_echo
  cat simple_echo
  ```

- We will now append to the file using the append operator: `>>`

  ```
  echo "My Salary is "$"100" >> simple_echo
  cat simple_echo
  ```

- Notice how the following copies a file. Same as using 

  ```
  cp simple_echo new_echo
  ```

  ```
  cat simple_echo > new_echo
  ```

- If we `cat` a file that doesn’t exist

  ```
  cat nofile
  ```

- We get an error message. This is stderr. Let’s redirect this error using the error redirection operator `2>` 

  ```
  cat nofile 2> error_out
  ```

- If you view the `error_out`, it now contains the error messages that would have gone to the screen. We can send errors to the same place as stdout by using `2>&1`

  ```
  cat nofile > allout 2>&1
  ```

- We should now have a file that contains the “simple_echo” text and the error message in the file `allout`.

- Type in the following

  ```
  cat << foobar
  Hello foobar
  foobar
  ```

- Notice how it only outputs when the line `foobar` is entered on its own line. Let’s add line numbers to the file fragmented using the `nl` command.

- Before you use it, create a file `fragmented.txt` with 5 lines of any text (you can use `nano ` to create the file)

  ```
  nl < fragmented.txt
  ```

- Notice how it only puts line numbers on lines with entries. Also re-run the command without the `<`. It should still work. This is because it takes its std input from a file. If no file was specified then it would expect std in from the keyboard. Try it. You will get a flashing cursor. Put some values in followed by return. Notice it numbers each entry. Use Ctrl-c to end it.

- Now let us read std input from the keyboard until a specific marker. We will make the specific marker the word “end”

  ```
  sort << end
  ```

- Enter some names followed by return. Then the last entry type 

  ```
  end
  ```

- Notice how it finishes the stdin from the keyboard and outputs the sorted information. If you wanted to store this information

  ```
  sort << end > sorted
  ```

- If you wanted to line number this output regardless of blank lines

  ```
  sort << end | nl -ba > sorted_numbered
  ```

- You can turn on the backslash escaped character like tab, backspace, form feed, newline etc, by specifying `-e`  with echo

  ```
  echo -e "Next is the \nNew line"
  ```

- Use combination of pipe `|` and `grep` to filter data in output

  ```
  cat /etc/passwd | grep $USER
  ```

- Write a compound command to write input to a file, and then sort the content of the file.

  ```
  echo -e "hello\na new day\nsee the world\ncall sign" > newfile.txt && sort newfile.txt
  ```

### Part 2: heads, tails, cat and tac

- Create a file and following data inside

  ```
  echo -e "for1\nfor2\nfor3\nfor4\nfor5\nfor6\nfor7\nfor8\nfor9\nfor10" > numbers
  ```

- Read the last five numbers

  ```
  tail -n5 numbers
  ```

- Look at the first 3 lines

  ```
  head -n3 numbers
  ```

- Reverse the contents of the file using tac

  ```
  tac numbers
  ```

### Part 3: cut

- To cut out specific information from a file you can use the cut command. You can specify delimiters and fields within the cut command. Following will pull out field 1, 4 and 5 in the passwd file

  ```
  cut -d: -f1,4,5 /etc/passwd
  ```

- To output the mounted filesystems. Space as the field delimiter

  ```
  cut -d" " -f1,2 /etc/mtab
  ```

- Extracting fields 1 3 11 and 12 from a uname kernel output.

  ```
  uname -a | cut -d" " -f1,3,11,12
  ```

### Part 4: unique lines extraction, sorting and filtering

- Create the following file called unique with the following content

  ```
  nano unique.txt
  ```

  Add the following content to the file

  ```
  This line occurs only once. 
  This line occurs twice.
  This line occurs twice.
  This line occurs three times.
  This line occurs three times.
  This line occurs three times.
  ```

- Using the `uniq` command we can count and extract unique lines

  ```
  uniq -c unique.txt
  uniq -u unique.txt
  ```

- We can sort files using the sort command.

  ```
  sort /etc/passwd
  ```

- If you wish to sort with a different delimiter then you must specify a delimiter with the `-t` option

  ```
  sort -t: -k1 /etc/passwd
  ```

### Part 5: bash helpers

- The bash history helps you view commands you have run in the past, and you can repeat them if you want. View your bash command history

  ```
  history
  ```

  Example output:

  ```
    1  uuidgen
    2  pwd
    3  sudo apt update
    4  sudo apt upgrade
    5  cd Downloads/
  ```

  The output contains unique index numbers with their corresponding command.

- Run any command in your history by typing `!N`. Replace `N` with the number that corresponds with the command you want to repeat. For example to repeat the command `pwd` in the output above, run `!2`

- Ping localhost on your machine

  ```
  ping 127.0.0.1
  ```

- Terminate the ping process by pressing `Ctrl-C`.

- Run the last command in your bash history

  ```
  !!
  ```

### Part 6: Environment Variables

Environment variables are accessible in your shell. They are commonly used to avoid writing explicit values in scripts, or to set secrets like passwords.

- Run  `printenv` to list all environment variables.
- Run `printenv USER`  or `echo $USER` to print the value of `$USER` variable
- Run `export VARIALBE=value` to set an environment variable.
  - The variable will only be accessible in the current shell/script. Run `printenv USER` in another terminal, you will see that the variable is not set there.
- To make the variable available in all bash sessions, you can modify `~/.bashrc` to include the export command.
  - Commands in `.bashrc` are executed every time a new shell is launched.
  - `.bashrc` is user-specific, while `/etc/environment` is accessible to all users.
- To load new changes, run `source ~/.bashrc`
  - `source` command runs a given script in the current shell (without creating a new shell). 
- **PATH** environment variable contains the list of directories containing executables (separated by `:`)
  - Run `printenv PATH`, you should see something similar to `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin`
  - Scripts for any executable you use (like `echo`, `cat`, ...) should be located in one of the directories to be recognizable.
- Run `export PATH=$PATH:/home/$USER` to include another directory in the PATH.



## Exercise 3: Text Filtration

- Copy `/etc/passwd` to your current directory

  ```
  cp /etc/passwd ./passwd
  ```

### Part 1: grep

The `grep` command searches for lines matching a pattern and prints the matching lines to output.

- View all occurrences of “systemd” in the `passwd` file.

  ```
  grep "systemd" passwd
  ```

  Sample output:

  ```
  systemd-network:x:100:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin
  systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin
  systemd-timesync:x:102:104:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin
  systemd-coredump:x:999:999:systemd Core Dumper:/:/usr/sbin/nologin
  ```

- Show line number of the matches.

  ```
  grep -n "systemd" passwd
  ```

- Invert the match to show lines without “systemd”. This is done with the `-v` option.

  ```
  grep -v "systemd" passwd
  ```

- It is also necessary in some cases to print the lines before or after a match.

  - Print 5 lines after the match.

    ```
    grep -A 5 "systemd" passwd
    ```

  - Print 3 lines before the match.

    ```
    grep -B 3 "systemd" passwd
    ```

  - Use the `-C` option to print 5 lines before and after a match.

    ```
    grep -C 5 "systemd" passwd
    ```

- Specify the `-P` option to use PCRE (Perl Compatible Regular Expression).

  ```
  grep -P "(systemd|root)" passwd
  ```

- Practice: save the following lines to a file `regextest.txt` and try to match all the fields.

  ```
  03/22 08:51:06 INFO   :...read_physical_netif: index #0, interface VLINK1 has address 129.1.1.1, ifidx 0
  03/22 08:51:06 ERROR   :...read_physical_netif: index #4, interface CTCD0 has address 9.67.116.98, ifidx 4
  ```

  > Regex [crash course](https://ryanstutorials.net/regular-expressions-tutorial/), [cheat sheet](https://quickref.me/grep), and [experimentation environment](https://regex101.com)

### Part 2: awk

AWK is a language designed for text processing and typically used as a data extraction and reporting tool. It can be uses like sed and grep to filter data with additional capabilities. It is a standard feature of most Unix-like operating systems.

- awk can be used like grep. The syntax is shown

  ```
  awk '/systemd/{print $0}' passwd
  ```

- We can use the `gsub` method to substiture all occurrences of systemd

  ```
  awk '{gsub(/systemd/, "NEWSYSTEMD")}{print}' passwd
  ```

- Add header and footer to the text document

  ```
  awk 'BEGIN {print "PASSWD FILE\n--------------"} {print} END {print "--------------\nEND OF PASSWD FILE"}' passwd
  ```

- We can specify delimiters to separate fields in a string. In the example below, we use `:` as the delimiter

  ```
  awk -F ":" '{print $1, $6, $7}' passwd
  ```

- Numeric comparison is possible with awk.

  ```
  awk -F ":" '{ if ($3 > 100) {print $0} }' passwd
  ```

### Part 3: sed

The sed command (short for stream editor) performs editing operation on text coming from standard input or file. The sed command can be used like grep but it has more functionalities.

- Sed by default will output the entire content of the file even when there is a match.

  ```
  sed '/systemd/p' passwd
  ```

  > The pattern we are searching for is enclosed in the `/.../`. In this case, we are searching for “systemd”.
  > The enclosed pattern is followed by a `p` command so that sed will print the line to standard output.

- Now, let’s use sed like grep. To print only the lines that match, we add the `-n` option.

  ```
  sed -n '/systemd/p' passwd
  ```

- Sed can substitute a matched pattern with another string before an output is displayed. It follows the structure `s/pattern/replacement/`.
  In the output, replace “systemd” with “NEWSYSTEMD”

  ```
  sed -n 's/systemd/NEWSYSTEMD/p' passwd
  ```

- In case you want to output all contents of the file to another file while replacing “systemd”, you can remove the `-n` option. Analyse the output from:

  ```
  sed 's/systemd/NEWSYSTEMD/' passwd
  ```

- We can restrict sed to perform it’s operation on a specific line number. In the example below, we restrict sed to line 1.

  ```
  sed '1 s/root/NOTROOT/' passwd
  ```

- We can specify a range of line numbers.

  ```
  sed '2,4 s/bin/NOBIN/g' passwd
  ```

  > `g` stands for global, which means that all matching occurrences in the line would be replaced. By default, sed will replace only the first occurrence in the line.

- We can also specify the line number where the match should start from. Sed will terminate when the first match is found.

  ```
  sed -n '5,/systemd/p' passwd
  ```

- Search for the word “sda” and replace it with “hda” globally (s/regexp/replacement/g), when the line contains the key “efi” (/regexp/) in the file fstab

  ```
  sed '/efi/ s/sda/hda/g' fstab
  ```

- Search for the word “:” and replace it with “;” when the line contains the key “root” in file passwd

  ```
  sed '/root/ s/:/;/g' passwd
  ```

- Create the following file called unique with the following content

  ```
  nano unique.txt
  ```

  ```
  This line occurs only once. 
  This line occurs twice.
  This line occurs twice.
  This line occurs three times. 
  This line occurs three times. 
  This line occurs three times.
  ```

- Delete line 2 and 3 from the file unique

  ```
  sed '2,3 d' unique.txt
  ```

- Delete all line that starts with “This”

  ```
  sed '/^This/ d' unique.txt
  ```

## Exercise 4: Bash Scripting

### Part 1: Bash scripting basics

- Create a shell script `script.sh` and add the following to see the output when you use the various echo options.

  > https://explainshell.com/ provides a quick way to explain options for a Linux command 

  ```bash
  #!/bin/bash
  echo -E "Printing text with newline. This is the dafult option."
  echo -n "What happens when we print text without new line"
  echo -e "\nEscaping \t characters \t to print\nnew lines for example"
  ```

- Execute the script.

  ```bash
  bash script.sh
  ```

- Single line comments begin with `#`

- Append the following lines to `script.sh` and run it again.te

  ```bash
  # Adding comments that do nothing
  echo "Testing single line comments"
  ```

- You can use multi line comments. The format is to start with a colon `:` followed by the comments enclosed in single quotes `'`

  ```bash
  : '
  This is a multi line comment
  Nothing happens in this section
  '
  echo "Back to executable commands"
  ```

- Double brackets are used to do arithmetic tasks. For example, append the following to your script.

  ```bash
  # Add two numeric values
  ((sum = 12 + 24))
  
  # Print the sum
  echo $sum
  ```

- Get user input with the `read` command. This is normally used in combination with echo to print a prompt to the user. Append the following to your script.

  ```bash
  echo "What is your favorite fruit?"
  read fruit
  echo "Hey! I like $fruit too."
  ```

### Part 2: Bash loops and conditions

- Create a simple **while** loop. Save the following script as `while_loop.sh`.

  ```bash
  #!/bin/bash
  
  counter=1
  while [ $counter -le 10 ]
  do
    echo $counter
    ((counter++))
  done
  echo All done
  ```

  > `-le` is the same as `<=`.

- Create an **until** loop. The until loop will execute the commands within it until the condition becomes true. Save the following script as `until_loop.sh`.

  ```bash
  #!/bin/bash
  
  counter=1
  until [ $counter -gt 10 ]
  do
    echo $counter
    ((counter++))
  done
  echo All done
  ```

  > `-gt` is the same as `>`.

- Create a simple **for** loop that iterates through the item in a list and prints each of them. Save the following script as `for_loop.sh`.

  ```bash
  #!/bin/bash
  
  names='John Peter Emily'
  for name in $names
  do
    echo $name
  done
  echo All done
  ```

- Bash for loop can be written in “C-Style”. For example save the following script as `uptime.sh`.

  ```bash
  #!/bin/bash
  
  # Loop of ten iterations to print system uptime every 2 seconds.
  for ((i = 1 ; i <= 10 ; i++)); do
    
    echo -e "$i.\t"$(uptime)
    sleep 2
  done
  ```

  Execute the script and analyze the output.

- The **break** statement tells bash to exit the loop. An example is shown in `break.sh` below.

  ```bash
  #!/bin/bash
  
  counter=1
  while [ $counter -le 10 ]
  do
    if [ $counter -eq 5 ]
    then
      echo Script encountered the value $counter
      break
    fi
    echo $counter
    ((counter++))
  done
  echo All done
  ```

  > `-eq` is the same as `=`.

- The **continue** statement skips the cuttent iteration of the loop. Save the following as `continue.sh` and run it.

  ```bash
  #!/bin/bash
  
  counter=0
  while [ $counter -lt 10 ]
  do
    ((counter++))
    if [ $counter -eq 6 ]
    then
      echo Number 6 encountered, skipping to the next iteration
      continue
    fi
    echo $counter
  done
  echo All done
  ```

  > `-lt` is the same as `<`.

### Part 3: If statements

- If statements allow us to make decisions in our script. This is usually utilized with a comparison operator. Save the following as `if_statement.sh`.

  ```bash
  #!/bin/bash
  
  echo -n "Enter the number: "
  read number
  if [ $number -gt 100 ]
  then
    echo That\'s a large number.
  elif [ $number -gt 50 ]
  then
    echo Not so much.
  else
    echo The number is way too small.
  fi
  ```

### Part 4: Bash functions

- Create a simple function

  ```
  fun () { echo "This is a function"; echo; }
  ```

- To view the content of all functions defined in the shell

  ```
  declare -f
  ```

- To list all functions by its name

  ```
  declare -F
  ```

- To view the content of the one your function

  ```
  declare -f fun
  ```

- To remove the function

  ```
  unset fun
  ```

- Now lets create a script with a 2 functions inside it

  ```
  nano funky.sh
  ```

- Inside nano type the following

  ```bash
  #!/bin/bash
  
  JUST_A_SECOND=3
  funky ()
  { # This is about as simple as functions get.
  
      echo "This is a funky function."
      echo "Now exiting funky function."
  } # Function declaration must precede call
  
  fun ()
  { # A somewhat more complex function. 
      i=0
      REPEATS=30
      echo
      echo "And now the fun really begins."
      echo 
      sleep $JUST_A_SECOND 
      while [ $i -lt $REPEATS ] #use as (<,>,=) or (-lt, -gt, -eq)
          do
          echo   "----------FUNCTIONS---------->"
          echo   "<------------ARE-------------"
          echo   "<------------FUN------------>"
          echo
          let "i+=1"
          done
  }
  
  add_fun()
  {
  # A function just to add numbers
  echo $((2+2))
  }
  #Now, call the functions
  funky
  fun
  echo The return value of add_fun is: $(add_fun)
  echo exit $? #check your exit status of the last function/command: if 0-success, otherwise is not
  ```

- Run the script

  ```
  bash funky.sh
  ```

- Notice how the functions are only available within the one shell (once you exit it is gone for the parent shell)

  ```
  declare -F
  ```

### Part 5: Directory and file manipulation

- You can create a new directory in bash with the `mkdir` command. Save the following script as `mkdir_bash.sh`.

  ```bash
  #!/bin/bash
  echo "Enter directory name"
  read newdir
  `mkdir $newdir`
  ```

- You can check for the existence of a directory before proceeding to create it. Update `mkdir_bash.sh` to look like the script shown below.

  ```bash
  #!/bin/bash
  echo "Enter directory name"
  read newdir
  if [ -d "$newdir" ]
  then
    echo "Directory exist"
  else
    `mkdir $newdir`
    echo "Directory created"
  fi
  ```

- Create a bash script to read every line of a specified file. The file name is passed as a command line argument. Save the following script as `file_reader.sh`.

  ```bash
  #!/bin/bash
  
  file=$1
  
  if [[ "$file" == "" || (! -f "$file") ]]
  then
    echo Using standard input!
    file="/dev/stdin"
  fi
  
  while read -r line
  do
    echo "$line"
  done < "${file}"
  ```

  > - The script reads the first value passed as a command line argument, represented by $1. If a text file is passed, the script will read and output each line of text.
  > - If no command line argument is passed or if the file does not exist, standard input (/dev/stdin) is used instead. This will prompt you to enter text and will output to the terminal screen what is received as input. To signal the end of your stdin input type CTRL+D

- Use this script to read `/etc/passwd`.

  ```
  bash file_reader.sh /etc/passwd
  ```

- The Internal Field Separator (IFS) is used to recognize word boundaries. The default value for IFS consists of whitespace characters. Whitespace characters are space, tab and newline. Add the following script to the file `ifs_test.sh`.

  ```bash
  #!/bin/bash
  
  mystring="foo:bar baz rab"
  for word in $mystring; do
    echo "Word: $word"
  done
  ```

- Run the script.

- The default value for the IFS can be changed. Modify `ifs_test.sh` to contain the following.

  ```bash
  #!/bin/bash
  
  IFS=:
  mystring="foo:bar baz rab"
  for word in $mystring; do
    echo "Word: $word"
  done
  ```

- Let’s do this on a larger scale. Read /etc/passwd word by word while using `:` as the IFS. Save the following as `ifs_word.sh`.

  ```bash
  #!/bin/bash
  
  if [[ $# -le 0 ]]
  then
    echo "You did not pass any files as arguments to the script."
    echo "Usage:" "$0" "my-file"
    exit
  fi
  
  IFS=:
  file=$1
  
  if [ ! -f "$file" ]
  then
    echo "File does not exist!"
  fi
  
  for word in $(cat "${file}")
  do
    echo "$word"
  done
  ```

  Run the script specifying `/etc/passwd` as an argument.

  ```bash
  bash ifs_test.sh /etc/passwd
  ```

### Part 6: Jump directories

Sometimes it is difficult to navigate directories with the possibly infinite number of parent directories we need to provide. For example `cd ../../../../../`. Let’s create a script that will help us jump to a specified directory without executing `cd ../`.

- Create the script `jump_dir.sh`

  ```bash
  # !/bin/bash
  
  # A simple bash script to move up to desired directory level directly
  
  function jump()
  {
    # original value of Internal Field Separator
    OLDIFS=$IFS
  
    # setting field separator to "/"
    IFS=/
  
    # converting working path into array of directories in path
    # eg. /my/path/is/like/this
    # into [, my, path, is, like, this]
    path_arr=($PWD)
  
    # setting IFS to original value
    IFS=$OLDIFS
  
    local pos=-1
  
    # ${path_arr[@]} gives all the values in path_arr
    for dir in "${path_arr[@]}"
    do
      # find the number of directories to move up to
      # reach at target directory
      pos=$[$pos+1]
      if [ "$1" = "$dir" ];then
  
    	# length of the path_arr
    	dir_in_path=${#path_arr[@]}
  
    	#current working directory
    	cwd=$PWD
    	limit=$[$dir_in_path-$pos-1]
    	for ((i=0; i<limit; i++))
    	do
    	  cwd=$cwd/..
    	done
    	cd $cwd
        break
      fi
    done
  }
  ```

- Make the script executable

  ```
  chmod +x jump_dir.sh
  ```

- Add it to the .bashrc file to make it available on every terminal session.

  ```
  echo "source ~/jump_dir.sh">> ~/.bashrc
  ```

- Open a new terminal and try jumping.

  ```
  jump directory_name
  ```

### Part 7: File and directory test operators

There are several options in bash to check the type of file you are interacting with. In many cases, the options are also used to check for the existence of a specified file or directory. The example below shows the options that can be used.

- Create a script `file_checker.sh` and add the following code:

  ```bash
  #!/bin/bash
  
  if [[ $# -le 0 ]]
  then
    echo "You did not pass any files as arguments to the script."
    echo "Usage:" "$0" "my-file-1 my-file-2"
    exit
  fi
  
  for arg in "$@"
  do
    # Does it actually exist?
    if [[ ! -e "$arg" ]]
    then
        echo "* Skipping ${arg}"
        continue
    fi
  
    # Is it a regular file?
    if [ -f "$arg" ]
    then
        echo "* $arg is a regular file!"
    else
        echo "* $arg is not a regular file!"
    fi
  
    [ -b "$arg" ] && echo "* $arg is a block device."
    [ -d "$arg" ] && echo "* $arg is a directory."
    [ ! -d "$arg" ] && echo "* $arg is not a directory."
  
    [ -x "$arg" ] && echo "* $arg is executable."
    [ ! -x "$arg" ] && echo "* $arg is not executable."
  
    [[ -h "$arg" ]] && echo "* $arg is a symbolic link."
    [ ! -h "$arg" ] && echo "* $arg is not a symbolic link."
  
    [[ -s "$arg" ]] && echo "* $arg has nonzero size."
    [ ! -s "$arg" ] && echo "* $arg has zero size."
  
    [[ -r "$arg" && -d "$arg" ]] && echo "* $arg is a readable directory."
    [[ -r "$arg" && -f "$arg" ]] && echo "* $arg is a readable regular file."
  done
  ```

- Run the script and specify the files you want to check as arguments.

  ```
  bash file_checker.sh /bin/i386 /etc/passwd
  ```

  You should get output similar to the following:

  ```
  * /bin/i386 is a regular file!
  * /bin/i386 is not a directory.
  * /bin/i386 is executable.
  * /bin/i386 is a symbolic link.
  * /bin/i386 has nonzero size.
  * /bin/i386 is a readable regular file.
  * /etc/passwd is a regular file!
  * /etc/passwd is not a directory.
  * /etc/passwd is not executable.
  * /etc/passwd is not a symbolic link.
  * /etc/passwd has nonzero size.
  * /etc/passwd is a readable regular file.
  ```

### Part 8: Hash tables in bash

A dictionary, or a hashmap, or an associative array is a data structure used to store a collection of things. A dictionary consists of a collection of key-value pairs. Each key is mapped to its associated value.

- To declare a dictionary variable in bash, use the `declare` statement with the `-A` option which means associative array. For example:

  ```
  declare -A newDictionary
  ```

- We have declared a variable called `newDictionary`. The following syntax can be used to add key-value pairs to the dictionary:

  ```
  newDictionary[key]=value
  ```

- Let’s add a key-value pair to the dictionary using the syntax above:

  ```
  newDictionary[1]=val1
  newDictionary[2]=val2
  ```

- To retrive the value of a dictionary key, we can use

  ```
  echo ${newDictionary[1]}
  ```

- To update the value of a key, we simply overwrite the existing value by writing to the key again. For example, to update `newDictionary[1]`, we do the following:

  ```
  newDictionary[1]=val1_upd
  ```

  Retrieve the value of the key `[1]` to verify the update.

  ```
  $ echo ${newDictionary[1]}
  val1_upd
  ```

- Use the `unset` command to remove a key-value pair from the dictionary.

  ```
  unset newDictionary[1]
  ```

- Verify that the pair has been removed from the dictionary.

  ```
  echo ${newDictionary[1]}
  ```

- You can iterate through the dictionary by creating a `for` loop. An example is shown in the script below:

  ```bash
  #!/bin/bash
  declare -A newDictionary
  newDictionary[1]=val1
  newDictionary[2]=val2
  newDictionary[3]=val3
  for key in "${!newDictionary[@]}"; do 
    echo "$key ${newDictionary[$key]}" 
  done
  ```

  You should get an output similar to the following when you run the script:

  ```
  3 val3
  2 val2
  1 val1
  ```

- You can also declare and instantiate a dictionary in one line.

  ```
  declare -A values=([1]=val1 [2]=val2 [3]=val3)
  ```

- Check the content of the dictionary.

  ```
  echo ${values[3]}
  ```

### Part 9: Creating bash menu

The menu allows the user to interact with your bash scripts. The menu typically provides the users options to select, and acts based on the user’s selection. The `select` statement can be used to create a basic bash menu. The `select` statement in combination with `case` statement can be used to create more sophisticated menu options.

#### 9.1. Create a basic menu

- The `select` statement is used to create a menu in the format shown below:

  ```bash
  select WORD in [LIST];
  do COMMANDS;
  done
  ```

- Create a basic menu `basic_menu.sh` that will prompt the user for their favorite color. Print out the value of any valid menu selection, and then break out of the select statement:

  ```bash
  #!/bin/bash
  
  echo "Enter the number corresponding to your favorite color:"
  
  select COLOR in red orange yellow green blue indigo violet
  do
     echo "Your favorite color is: $COLOR"
     break
  done
  ```

- Run the script and you should get results similar to the following:

  ```
  Enter the number corresponding to your favorite color:
  1) red
  2) orange
  3) yellow
  4) green
  5) blue
  6) indigo
  7) violet
  #? 5
  Your favorite color is: blue
  ```

#### 9.2. Create a menu using the case statement

- Utilizing the `case` statement provides more flexibility than when using the `select` statement alone. By adding a `case` for each selection, the script can execute separate tasks based on what the user selects. The reserved Bash variable `PS3` is used with `select` statements to provide a custom prompt to the user. The select statement when combined with `case` statement is used to create menu in the format shown below:

  ```bash
  select WORD in [LIST];
  do
    case $WORD in
      element-1-in-LIST)
        COMMAND1
        ;;
      element-2-in-LIST)
        COMMAND2
        ;;
    esac
  done
  ```

- Create a bash script `lazy_tool.sh` to help you check hostname, private IP address, and public IP address exit node based on selected options.

  ```bash
  #!/bin/bash
  
  echo "This script helps the lazy to check hostname, private IP addresses, and public IP address"
  echo "Enter a number corresponding to what you want to check"
  PS3="My selection is: "
  
  select UTILITY in hostname system-IP-address public-IP-address exit;
  do
     case $UTILITY in
        hostname)
            echo "Your hostname is: "$(hostname)
            ;;
        system-IP-address)
            echo "Your system IP addresses are: "$(ip -4 addr | grep -oP '(?<=inet\s)((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}')
            # We can also use the following regex to extract the IP address: (?<=inet\s)\d+(\.\d+){3}
            ;;
        public-IP-address)
            echo "Your public IP address is: "$(wget -qO - icanhazip.com)
            ;;
        exit)
            echo "You are now exiting this script."
                break
                ;;
        *)
            echo "Please make a selection from the provided options."
    esac
  done
  ```

  > Notice how one of the options in the script uses the `grep` utility to extract IP addresses from the output of the `ip -4 addr` command.

- Run the script and you should get results similar to the following:

  ```
  This script helps the lazy to check hostname, private IP addresses, and public IP address
  Enter a number corresponding to what you want to check
  1) hostname
  2) system-IP-address
  3) public-IP-address
  4) exit
  My selection is: 1
  Your hostname is: ADAGBA
  My selection is: 2
  Your system IP addresses are: 127.0.0.1 192.168.132.134
  My selection is: 4
  You are now exiting this script.
  ```

#### 9.3. Create a menu that includes a submenu

The concept of a basic menu and menu with the `case` statement are combined to create a menu that includes a submenu.

- Create a bash script `submenu.sh` that provides a menu with submenu. The script will read all files in the current working directory and display them to the user as selectable options. Once the user selects a file, a submenu will appear prompting the user to select an action to perform on the previously selected file. The submenu allows a user to delete a file, to display the file’s contents, or to simply exit the script.

  ```bash
  #!/bin/bash
  
  echo "Use this script to manipulate files in your current working directory:"
  echo "----------------------------------------------------------------------"
  echo "Here is a list of all your files. Select a file to access all"
  echo "available file actions:"
  
  select FILE in * exit;
  do
    case $FILE in
    exit)
        echo "Exiting script ..."
        break
        ;;
    *)
        select ACTION in delete view exit;
        do
            case $ACTION in
            delete)
                echo "You've chose to delete your file" "$FILE"
                rm -i "$FILE"
                echo "File ""$FILE" "has been deleted"
                echo "Exiting script ..."
                break
                ;;
            view)
                echo "Your selected file's contents will be printed to the terminal:"
                cat "$FILE"
                echo "------------------------"
                echo "Exiting script ..."
                break
                ;;
            exit)
                echo "Exiting script ..."
                break
                ;;
            esac
        done
        break
        ;;
    esac
  done
  ```

- Run the script and you should get results similar to the following:

  ```
  Use this script to manipulate files in your current working directory:
  ----------------------------------------------------------------------
  Here is a list of all your files. Select a file to access all
  available file actions:
  1) allout                                          8) lazy_tool.sh
  2) aws                                             9) log
  3) awscliv2.zip                                   10) regextest.txt
  4) basic_menu.sh                                  11) server-data.log
  5) cluster-role-trust-policy.json                 12) submenu.sh
  6) google-cloud-sdk                               13) uptime.sh
  7) google-cloud-sdk-377.0.0-linux-x86_64.tar.gz   14) exit
  #? 10
  1) delete
  2) view
  3) exit
  #? 2
  Your selected file's contents will be printed to the terminal:
  03/22 08:51:06 INFO   :...read_physical_netif: index #0, interface VLINK1 has address 129.1.1.1, ifidx 0
  03/22 08:51:06 ERROR   :...read_physical_netif: index #4, interface CTCD0 has address 9.67.116.98, ifidx 4
  ------------------------
  Exiting script ...
  ```

## Exercise 5: Execute Python commands in bash

- Python can run one-liners from an operating system command line using option `-c`. An example is shown with the command below:

  ```bash
  python3 -c "a = 2; b = 4; sum = a + b; print('Sum =', sum)"
  ```

- OR

  ```bash
  python -c "a = 2; b = 4; sum = a + b; print('Sum =', sum)"
  ```

- The following bash script executes the python command above.

  ```bash
  #!/bin/bash
  
  python3 -c "a = 2; b = 4; sum = a + b; print('Sum =', sum)"
  ```

- Alternatively, you scan split your python code into multi-lines by declaring a variable in the following fashion:

  ```bash
  #!/bin/bash
  
  py_script="
  a = 2
  b = 4
  sum = a + b
  print('Sum =', sum)
  "
  
  python3 -c "$py_script"
  ```

## Exercise 6: Debugging bash scripts

### Part 1: Command exit code

You can verify whether a bash command executed successfully by viewing the exit status code of the command. The exit status of the previously executed command is stored in the `$?` variable. A successful command returns a `0`, while an unsuccessful one returns a non-zero value that usually can be interpreted as an error code.

- Run the command `ls -lah`.
- View the exit status of the previous command with `echo "$?"`.
- Now run a command that will fail. For example: `ls -lah /directorythatdoesnotexist`
- Run `echo "$?"` again to view the exit status. You should get a value that is not `0`.

### Part 2: Using `set -xe`

When there is an error that stops the execution of a bash script, the bash interpreter usually displays the line number that triggered the error. However, in some cases, it might be necessary to trace the flow of execution of the script. This provides more insight into the conditions that are met, and the state of the loops.

- The `set` command is used to set or unset shell options or positional parameters.

- We can use the `set -e` option to exit the bash script if any command or statement generates a non-zero exit code. This is defined at the start of the script and it applies globally to all commands in the script.

- Additionally, we can also use the `set -x` option to display commands and arguments before they are executed. With this option, we can see every line of command that is executing in the script.

- The `set -e` option and `-x` options can be combined to become useful debugging tools. The option `-e` exits the script as soon as an error is encountered, and the option `-x` shows the command that was running when the error was encountered.

- Create a bash script `loop_debug.sh` and add the following to it:

  ```bash
  #!/bin/bash
  
  set -xe
  
  # This script prints  all user profiles.
  
  FILE=".bashrc"  #  File containing user profile,
              #+ was ".profile" in original script.
  
  for home in `awk -F: '{print $6}' /etc/passwd`
  do
    [ -d "$home" ] || continue    # If no home directory, go to next.
    [ -r "$home" ] || continue    # If not readable, go to next.
    (cd $home; [ -e $FILE ] && less $FILE)
  done
  
  exit 0
  ```

- Run the script and analyze the output. Did the script stop prematurely?

- Remove the option `-e` and run the script again. Did you notice any difference? Why is it different?

- Now completely remove `set -xe` to see how the program executes without these options.

## Exercise 7: Managing processes

### Part 1: Process id and jobs

- We will start a few processes and manage them through the command line. Open a command shell and change directory to your home. Start the top command and put it into the background. Use `&` to put the process in the background

  ```
  top &
  ```

- Then start a background process called `yes` and redirect its out to `/dev/null` (the black hole)

  ```
  yes > /dev/null &
  ```

- Now let’s start an `md5sum` process to calculate the md5 hash of the first drive on the system. Notice how this hangs the prompt; it should take a long time to complete this task.

  ```
  md5sum /dev/sda
  ```

- Let’s stop the process and background it. To stop the process push `CTRL+Z`.

- Now restart the job in the background. To see the jobs numbers use the command `jobs`

- Identify `id` number of the job `md5sum` from the previous command and point it with `bg` command

  ```
  bg 3
  ```

- Now list the current jobs running and stopped, see the changes

  ```
  jobs
  ```

- We can bring specific job also to the terminal screen.

  ```
  yes > /dev/null &fg 3
  ```

- Afterwards you can terminate the process by `CTRL+C`

  > `CTRL+C` – sends to a process by its controlling terminal (by the TTY driver) SIGINT signal to the current foreground job.

- To list the process IDs of the current processes running in the current shell

  ```
  ps
  ```

- The fundamental way of controlling processes in Linux is by sending signals to them. There are multiple signals that you can send to a process, to view all the signals run

  ```
  kill -l
  ```

- Identify the process ID for the `yes` process, in this example its ID is `27522`. To kill this process with a SIGTERM (-15)

  ```
  kill 27522
  ```

- If that failed, you can use a SIGKILL (-9)

  ```
  kill -9 27522
  ```

- To list all process running on the system, issue the following command

  ```
  ps -ef
  ```

- To find the process ID of a specific process named 

  ```
  bash
  ```

  ```
  ps -ef | grep bash
  ```

- Another useful command is the pstree command which shows a tree structure of the cascading process IDs (-p).

  ```
  pstree -p
  ```

- When you press the `CTRL+C` or Break key at your terminal during execution of a shell program, normally that program is immediately terminated, and your command prompt returns. This may not always be desirable. For instance, you may end up leaving a bunch of temporary files that won’t get cleaned up.

- Trapping these signals is quite easy, and the trap command has the following syntax:

  ```
  trap "commands" signals
  ```

  Here command can be any valid Unix command, or even a user-defined function, and signal can be a list of any number of signals you want to trap.

  There are two common uses for trap in shell scripts:

  - Clean up temporary files
  - Ignore signals

- Let’s create a script with a trap `SIGINT`. Save the script as `sleeper.sh`

  ```bash
  #!/bin/bash
  
  trap "echo SIGINT encountered, Goodbye forever!" SIGINT
  echo Hello, I am now going to sleep
  sleep infinity
  ```

  > The command to execute when the trap is encountered must be in quotes.

- Now run the script

  ```bash
  $ bash sleeper.sh
  Hello, I am now going to sleep
  ```

- Send a `SIGINT` by pressing `CTRL+C` on the keyboard. You should have the following output:

  ```bash
  $ bash sleeper.sh
  Hello, I am now going to sleep
  ^CSIGINT encountered, Goodbye forever!
  ```

  > Remember, you can also find the process ID and then use `kill` to send the signal in the form `$ kill -signal pid`

- You can also use trap to ensure the user cannot interrupt the script execution. This feature is important when executing sensitive commands whose interruption may permanently damage the system. The syntax for disabling a signal is:

  ```
  trap "command" [signal]
  ```

  - Double quotation marks mean that no command will be executed when the signal is received. For example, to trap the SIGINT and SIGABRT signals, type `trap "" SIGINT SIGABRT`

### Part 2: The proc file system

The `/proc/` directory — also called the proc file system — contains a hierarchy of special files which represent the current state of the kernel — allowing applications and users to peer into the kernel’s view of the system.
Within the `/proc/` directory, one can find a wealth of information detailing the system hardware and any processes currently running. In addition, some of the files within the `/proc/` directory tree can be manipulated by users and applications to communicate configuration changes to the kernel.

- You can view the `/proc/` virtual files with the command line file readers. For example, view `/proc/cpuinfo`

  ```
  cat /proc/cpuinfo
  ```

  You should receive output similar to the following:

  ```
  processor	: 0
  vendor_id	: AuthenticAMD
  cpu family	: 25
  model		: 80
  model name	: AMD Ryzen 5 5600H with Radeon Graphics
  stepping	: 0
  microcode	: 0xffffffff
  cpu MHz		: 3293.695
  cache size	: 512 KB
  physical id	: 0
  siblings	: 2
  core id		: 0
  cpu cores	: 2
  apicid		: 0
  initial apicid	: 0
  fpu		: yes
  fpu_exception	: yes
  cpuid level	: 13
  wp		: yes
  ```

  When viewing different virtual files in the `/proc/` file system, some of the information is easily understandable while some is not human-readable. This is in part why utilities exist to pull data from virtual files and display it in a useful way. Examples of these utilities include `lspci`, `apm`, `free`, and `top`.

- Most virtual files within the `/proc/` directory are read-only. However, some can be used to adjust settings in the kernel. This is especially true for files in the `/proc/sys/` subdirectory.

- To change the value of a virtual file, use the `echo` command and redirect (>) the new value to the file. For example, to change the hostname on the fly, type:

  ```
  echo newname > /proc/sys/kernel/hostname 
  ```

- Other files act as binary or Boolean switches. Typing `cat /proc/sys/net/ipv4/ip_forward` returns either a 0 or a 1. A `0` indicates that the kernel is not forwarding network packets. Using the echo command to change the value of the `ip_forward` file to `1` immediately turns packet forwarding on.

- On multi-user systems, it is often useful to secure the process directories stored in `/proc/` so that they can be viewed only by the `root` user. You can restrict the access to these directories with the use of the `hidepid` option.

- To change the file system parameters, you can use the `mount` command with the `-o` remount option.

  ```
  sudo mount -o remount,hidepid=value /proc
  ```

  Here, value passed to hidepid is one of:

  - `0` (default) — every user can read all world-readable files stored in a process directory.
  - `1` — users can access only their own process directories. This protects the sensitive files like cmdline, sched, or status from access by non-root users. This setting does not affect the actual file permissions.
  - `2` — process files are invisible to non-root users. The existence of a process can be learned by other means, but its effective UID and GID is hidden. Hiding these IDs complicates an intruder’s task of gathering information about running processes.

- To make process files accessible only to the root user, type:

  ```
  sudo mount -o remount,hidepid=1 /proc
  ```

  With `hidepid=1`, a non-root user cannot access the contents of process directories. An attempt to do so fails with the following message:

  ```
  ls /proc/1/
  ls: /proc/1/: Operation not permitted
  ```

  With hidepid=2 enabled, process directories are made invisible to non-root users:

  ```
  ls /proc/1/       
  ls: /proc/1/: No such file or directory
  ```

- Also, you can specify a user group that will have access to process files even when `hidepid` is set to 1 or 2. To do this, use the gid option.

  ```
  sudo mount -o remount,hidepid=value,gid=gid /proc
  ```

  > You can find system groups and their respective group IDs in `/etc/group`
  > Replace `gid` with the specific group id. For members of selected group, the process files will act as if `hidepid` was set to `0`. However, users which are not supposed to monitor the tasks in the whole system should not be added to the group.

### Part 3: `top`

- Open a command shell run the `top` command

  > This opens up a tool that shows the top processes running on your system. This tool can be used to kill processes, renice processes, sort and various other process management. Press the h command to get a list of help.
  > Read more at: https://www.guru99.com/managing-processes-in-linux.html

- By default, top sorts the process list using the %CPU column. To sort processes using a different column, press one of the following keys.

  - `M` Sort by the `%MEM` column.
  - `N` Sort by `PID` column.
  - `T` Sort by the `TIME+` column.
  - `P` Sort by the `%CPU` column.

- To show the process command line instead of just the process name, press `c`.

- The filter feature allows using a filter expression to limit which processes to see in the list. Activate the filter option by pressing `o`. The program prompts you to enter a filter expression. You can enter the following to filter processes using more than 1% CPU.

  ```
  %CPU>1.0
  ```

- Clear the filters by pressing `=`

- To filter processes by a specific user, specify the `-u` option when you run the top command

  ```
  top -u root
  ```

- The first five lines of the output show some useful statistics
  ```bash
  top - 20:38:40 up  3:56,  2 users,  load average: 0.48, 0.65, 0.59
  Tasks: 386 total,   1 running, 385 sleeping,   0 stopped,   0 zombie
  %Cpu(s):  1.2 us,  0.5 sy,  0.0 ni, 98.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st 
  MiB Mem :  15685.7 total,   8313.0 free,   3343.0 used,   4993.5 buff/cache     
  MiB Swap:      0.0 total,      0.0 free,      0.0 used.  12342.7 avail Mem 
  ```

  - `top` displays uptime information
  - `Tasks` displays process status information
  - `%Cpu(s)` displays various processor values
  - `MiB Mem` displays physical memory utilization
  - `MiB Swap` displays virtual memory utilization

### Part 4: `free`

- `free` is a popular command used by system administrators on Unix/Linux platforms. It’s a powerful tool that gives insight into the memory usage in human-readable format.
- The man page for this command states that free displays the total amount of free and used memory on the system, including physical and swap space, as well as the buffers and caches used by the kernel. The information is gathered by parsing `/proc/meminfo`.

- Run `free -h` for a human-readable output

  ```
  free -h
                 total        used        free      shared  buff/cache   available
  Mem:            15Gi       2,7Gi       265Mi       149Mi        12Gi        12Gi
  Swap:          2,0Gi       0,0Ki       2,0Gi
  ```

- `free` provides options to display amount of memory in various units. free `-b`, `-k`, `-m`, `-g` display the amount of memory in bytes, kilobytes, megabytes, gigabytes respectively.

- The various columns, displayed by the various releases above, seek to identify the Total, used, free, shared memory. It also seeks to display the memory held in cache and buffers as well.

##  Exercise 8: Creating cron jobs

- Let’s create an example script `job.sh`. We can check `log.txt` at any time to see whether our scheduled job has run. Create this script in your home directory

  ```bash
  #!/bin/bash
  echo `date +"%Y-%M-%d %T"`" - Hello $USER" >> /home/$USER/log.txt
  ```

### Part 1: Adding the job to the user crontab

- To understand the user crontab, let’s add the script to it manually

  ```
  crontab -e
  ```

- This command will open an editor to edit the existing user crontab. Let’s append our cron expression:

  ```
  30 0 * * * /home/$USER/job.sh
  ```

  This schedules the script to run every day, 30 minutes after midnight.

- We also need to be sure that the current user has execute permissions for this script. So, let’s use the chmod command to add them:

  ```
  chmod u+x /home/$USER/job.sh
  ```

  Now, `job.sh` is scheduled and will run every day. We can test this by inspecting the `log.txt` file

### Part 2: Adding the job to the system crontab
To understand the system crontab, let’s also add this script to it manually.

- The system crontab file is kept in `/etc/crontab`. Let’s append the following line:

  ```
  30 0 * * * root /home/$USER/job.sh
  ```

  We should note that we need to specify the root username. This is because jobs in system cron are system jobs and will be run by the root user.

### Part 3: Script for adding the job to the user crontab
Now let’s try automating the process to add to the user crontab. Install a new file to crontab.

- Let’s first create a new script file:

  ```
  touch /home/$USER/myScript.sh
  ```

- The first thing our script will do is take a copy of all the current jobs. Do not forget to add executable rights for the script to work

  ```bash
  #!/bin/bash
  crontab -l > crontab_new
  ```

  We now have all the previous jobs in the `crontab_new` file. This means we can append our new job to it and then rewrite the crontab by using the edited file as an input argument to the crontab command:

  ```
  echo "30 0 * * * /home/$USER/job.sh" >> crontab_new
  crontab crontab_new
  ```
  
- Since the `crontab_new` file is temporary, we can remove it:

  ```
  $ rm crontab_new
  ```

  This method works well, though it does require the use of a temporary file. The main idea here is to add multiple tasks to the existing user jobs. Let’s see if we can optimize it further.

### Part 4: Optimize the previous script by using a pipe
Our previous script relied on a temporary file and had to tidy it up. It also didn’t check whether the cron entry was already installed, and thus, it could install a duplicate entry if executed multiple times.

- We can address both of these by using a pipe-based script. If crontab command has a dash `-`, the crontab data is read from standard the input

  ```
  #!/bin/bash
  (crontab -l; echo "30 0 * * * /home/$USER/job.sh") | sort -u | crontab -
  ```

- As before, the `crontab -l` and `echo` commands write out the previous lines of the crontab as well as the new entry. These are piped through the sort command to remove duplicate lines. The `-u` option in `sort`  is for keeping only unique lines. The result of this is piped into the `crontab` command, which rewrites the `crontab` file with the new entries. We should be aware, though, that using sort will completely reorder the file, including any comments. 

- `sort -u` is pretty easy to understand in a script, but we can achieve a less destructive de-duplication with awk:

  ```bash
  #!/bin/bash
  (crontab -l; echo "30 0 * * * /home/$USER/job.sh")|awk '!x[$0]++'|crontab -
  ```

  This will remove all duplicates from the crontab without sorting it.

- The syntax of the awk command used is explained below:
  - `a[$0]` - uses the current line `$0` as key to the array, taking the value stored there. If this particular key was never referenced before, `a[$0]` evaluates to the empty string.
  - The `!` negates the value from before. If it was empty or zero (false), we now have a true result. If it was non-zero (true), we have a false result. If the whole expression evaluated to true, the whole line is printed as the default action print `$0`
  - `++` increment the value of `a[$0]`

### Part 5: Using system crontab

- First, let’s create a new script:

  ```
  touch /home/$USER/myScript2.sh
  ```

- The syntax of the system schedule line is similar to the user schedule. We just need to specify the root username in the schedule line

  ```
  #!/bin/bash
  sudo /bin/bash -c 'echo "30 0 * * * root /home/$USER/job.sh" >> /etc/crontab'
  ```

- We’re using `sudo /bin/bash` before `echo` because the user needs root access to both echo and redirect as the root user. Otherwise, we’ll get a permission denied error because just echo will run as root and the redirection will be made with the current user’s permission. The `-c` option tells bash to get the command in single quotes as a string and run it in a shell.

- Note that this is plain file manipulation, compared with the `crontab` command used earlier. We can add similar filters like sort or awk if we want to avoid duplicate entries.

### Part 6: Using the /etc/cron.d directory
Besides the `/etc/crontab` path, cron considers all the files in the `/etc/cron.d` directory as system jobs too. So, we can also put the schedule line in a new file in the `/etc/cron.d` directory.

- Let’s now make another script for adding a job to the `cron.d` directory, as an alternative to the `/etc/crontab` file:

  ```
  touch /home/$USER/myScript3.sh
  ```

- We need to put the schedule line in a new file in the cron.d directory — we’ll call our file schedule. Note that in `/etc/cron.d`, some filenames are considered invalid. For example, if we choose `schedule.sh` for the filename, it will be skipped because the filename should not have any extension:

  ```bash
  #!/bin/bash
  sudo touch /etc/cron.d/schedule
  ```

- The `cron.d` directory and its sub-directories are usually used by system services, and only the root user can have access to these directories. Also, the files in `/etc/cron.d` must be owned by root. So, we need to use sudo.

- Let’s now add our schedule line to the schedule file and change the permissions.

  ```
  sudo /bin/bash -c 'echo "30 0 * * * root /home/$USER/job.sh" > /etc/cron.d/schedule'
  sudo chmod 600 /etc/cron.d/schedule
  ```

- Note that we change the file’s permissions to a minimum `600`. This is because files in `/etc/cron.d` must not be writable by group or other. Otherwise, they will be ignored. Also, the schedule files under `/etc/cron.d` do not need to be executable. So, we don’t need permission `700`.

## Exercise 9: Systemd

### Part 1: Create a shell script

- Create a custom web server with bash. The web server displays the processes running on the server by executing the `top` command.

  ```
  sudo nano /usr/bin/script.sh 
  ```

- Add the following to the file.

  ```bash
  #!/bin/bash
  
  while true;
    do dd if=/dev/zero of=/dev/null
  done &
  
  while true;
    do echo -e "HTTP/1.1 200 OK\n\n$(top -bn1)" \
    | nc -l -k -p 8080 -q 1;
  done
  ```

  > `dd` has been added for a purpose which you will see in further sections.
  > Consider the web server as a means of remotely viewing the resource usage of `dd`.

- Save the script and set execute permission.

  ```
  sudo chmod +x /usr/bin/script.sh 
  ```

- You have to manually run this script whenever the system is restarted. We can solve this by creating a systemd service for it. This will give us more options for managing the script’s execution.

### Part 2: Create a systemd file

- Next, create a `systemd` service file for the script on your system. This file must have `.service` extension and saved under the `/lib/systemd/system/` directory

  ```
  sudo nano /lib/systemd/system/shellscript.service
  ```

- Now, add the following content and update the script filename and location. You can also change the description of the service. After that, save the file and close it

  ```ini
  [Unit]
  Description=My custom web service to show system processes
  
  [Service]
  ExecStart=/usr/bin/script.sh
  
  [Install]
  WantedBy=multi-user.target
  ```

  > The [Unit] section describes the service, specifies the ordering dependencies, as well as conflicting units. In [Service], a sequence of custom scripts is specified to be executed during unit activation, on stop, and on reload. Finally, the [Install] section lists units that depend on the service.

### Part 3: Enable the service

- Your systemd service has been added to your system. Let’s reload the systemctl daemon to read new files. You need to reload the configuration file of a unit each time after making changes in any `*.service` file.

  ```
  sudo systemctl daemon-reload 
  ```

- Enable the service to start on system boot and also start the service using the following commands.

  ```
  sudo systemctl enable shellscript.service 
  sudo systemctl start shellscript.service 
  ```

  > When you enable a service, a symbolic link of that service is created in the `/etc/systemd/system/multi-user.target.wants` directory.

- Finally, verify that the script is up and running as a systemd service.

  ```
  sudo systemctl status shellscript.service 
  ```

- Example output when we access the web service via port 8080 is shown below.
  ![img](https://i.imgur.com/GfB4DAB.jpg)

- The `dd` process shown in the output was executed by the service we just created. This process is using 100% of the CPU. We can fix this problem by making use of systemd control groups.

### Part 4: Systemd control groups (cgroups)

Systemd control group is a mechanism that allows you to control the use of system resources by a group of processes.

- You can view the cgroup of a service with the `systemctl status <service_name>` command.
  Let’s view the status of our custom system service `shellscript.service` again.

  ```
  systemctl status shellscript.service
  ```

  You get an output similar to the following

  ```bash
  ● shellscript.service - My Shell Script
     Loaded: loaded (/lib/systemd/system/shellscript.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2022-10-23 19:39:02 +04; 1s ago
   Main PID: 6821 (script.sh)
      Tasks: 4 (limit: 9415)
     Memory: 1.0M
        CPU: 1.945s
     CGroup: /system.slice/shellscript.service
             ├─6821 /bin/bash /usr/bin/script.sh
             ├─6822 /bin/bash /usr/bin/script.sh
             ├─6824 nc -l -k -p 8080 -q 1
             └─6825 dd if=/dev/zero of=/dev/null
  ```

  The output shows that `shellscript.service` is under the `system.slice` control group.
  The second line `6821 /bin/bash /usr/bin/script.sh` shows the process ID and the command used to start `shellscript.service`.
  Subsequent lines under the `CGroup` are the other commands executed in the service.

- View your system’s cgroup hierarchy

  ```
  systemctl status
  ```

- You can view the system resource usage by each cgroup

  ```
  systemd-cgtop
  ```

- Slices allow one to create a hierarchical structure in which relative shares of resources are defined for the entities that belong to those slices.
  View a list of all systemd slices

  ```
  systemctl -t slice --all
  ```

- Create a systemd slice at `/etc/systemd/system/testslice.slice`. Add the following to the file.

  ```bash
  [Unit]
  Description=Custom systemd slice
  Before=slices.target
  
  [Slice]
  MemoryAccounting=true
  CPUAccounting=true
  MemoryMax=10%
  CPUQuota=10%
  ```

- This slice will set CPU and memory usage limit to all processes running under it. As seen in the configuration, a maximum of 10% of memory and CPU resources can be used by the processes running under this control group `testslice.slice`.

- Let’s add our custom service `shellscript.service`to this new control group.
  Modify the service file `/lib/systemd/system/shellscript.service` to use this systemd slice by adding the line `Slice=testslice.slice` to the `[Service]` section as shown below:

  ```ini
  [Unit]
  Description=My custom web service to show system processes
  
  [Service]
  ExecStart=/usr/bin/script.sh
  Slice=testslice.slice
  
  [Install]
  WantedBy=multi-user.target
  ```

- Reload the daemon and restart the service to apply the changes

  ```
  sudo systemctl daemon-reload
  sudo systemctl restart shellscript.service
  ```

- Refresh the web page. The output shows that `dd` now uses less than 10% of the CPU.
  ![img](https://i.imgur.com/SQ5xb0b.jpg)

- Run `systemd-cgtop` to view resource usage by cgroups.

  ```
  Control Group                            Tasks   %CPU   Memory  Input/s Output/s
  /                                          774   13,9     1.7G        -        -
  testslice.slice                              2    9,9   956.0K        -        -
  testslice.slice/shellscript.service          2    9,9   576.0K        -        -
  user.slice                                 489    3,1     1.5G        -        -
  user.slice/user-1000.slice                 489    3,4     1.3G        -        -
  ```

- View the hierarchy and other artifacts about the cgroup.

  ```
  systemctl -t slice --all
  systemctl status
  ```

- View systemd log for your service

  ```
  journalctl -u shellscript.service
  ```

## Exercise 10: Logging and Auditing

### Part 1: journald

- Journald rate limits log messages and will drop all messages from a service if it passes certain limits. These limits can be configured via `RateLimitBurst` and `RateLimitIntervalSec`, which default to 10000 and 30s respectively. The rate limiting feature is very handy when you have services that generate a lot of logs.

  ```
  cat /etc/systemd/journald.conf | grep RateLimit
  ```

- `journalctl` is the main tool for interacting with the journal. Run this tool `journalctl`

- View all the options you can use with journalctl.

  ```
  man journalctl
  ```

- Show only the last 10 lines of the journal with the `-n` option

  ```
  journalctl -n 10
  ```

- Follow the logs with the `-f` option.

  ```
  journalctl -f
  ```

- View the journal in reverse order. From the newest to the oldest.

  ```
  journalctl --reverse
  ```

- The `--output` in journalctl can be used to format the output of the journal in various forms.

- View the journal in json format with the option `--output=json-pretty` or just `--output=json`. If you want it compact, use

  ```
  journalctl --output=json-pretty
  ```

- Filter journal for specific systemd unit with the command `journalctl -u <systemd-unit>`.

  ```
  journalctl -u multiuser.target
  ```

- You can also filter with the `-p` option to specify event severity levels that should be displayed.

- Show only kernel messages.

  ```
  journalctl --dmesg
  ```

- You can filter by time with the `--since` and `--until` options.

  ```
  $ journalctl --since="2022-10-30 23:00:00"
  
  OR
  
  $ journalctl --since=yesterday --until=now
  ```

- You can view the time that the system was reboot in the journal

  ```
  journalctl MESSAGE="Server listening on 0.0.0.0 port 22."
  ```

### Part 2: rsyslog

- Use the `logger` utility to generate logs.

  ```
  logger Test
  ```

- View the log in `/varlog/syslog`

  ```
  tail /var/log/syslog
  ```

- You should see a line of log similar to the following.

  ```
  Oct 30 02:06:04 <hostname> root: Test
  ```

- Rsyslog rules typically have the facility and the level. These two combined in the form `facility.level` define the priority of the log message.
  - More about facility and level: https://success.trendmicro.com/dcx/s/solution/TP000086250

- Create an rsyslog rule that stores all logs with `user.emerg` priority to a log file `/var/log/test.log`. Do this by adding the following rule to `/etc/rsyslog.conf`

  ```
  user.emerg /var/log/test.log
  ```

- Restart rsyslog to apply the changes.

  ```
  systemctl restart rsyslog
  ```

- Follow the logs from the file:

  ```
  tail -f /var/log/test.log
  ```

- Open a new terminal in another tab where you will run the `logger` utility to test this rule and execute the following command.

  ```
  logger -p user.emerg "test log"
  ```

- Go to the previous terminal tab, you should see the log appear.


### Part 3: User authentication activities

- System login activity are saved in the log file `/var/log/auth.log`. You can see user sessions opened and other events such as authentication failure.

- Let’s create a new user `testuser` which we will use to simulate failed login.

  ```
  sudo adduser testuser
  ```

- Try switching to the `testuser` with `su` command. Enter a wrong password on the prompt.

  ```bash
  $ su testuser
  Password: 
  su: Authentication failure
  ```

- Check the log file `/var/log/auth.log`  to view this failed login activity.

  ```
  tail /var/log/auth.log
  ```

  You should see lines of log similar to the following two. These are the failed login events.

  ```
  Oct 30 20:03:07 <hostname> su: pam_unix(su:auth): authentication failure; logname= uid=1000 euid=0 tty=/dev/pts/0 ruser=user1 rhost=  user=testuser
  Oct 30 20:03:09 <hostname> su: FAILED SU (to testuser) user1 on pts/0
  ```

- Try switching to the `root` user. This time, enter three consecutive wrong passwords in the prompt.

  ```bash
  $ sudo su
  [sudo] password for user1: 
  Sorry, try again.
  [sudo] password for user1: 
  Sorry, try again.
  [sudo] password for user1: 
  sudo: 3 incorrect password attempts
  ```

- View the authentication log file again.

  ```
  tail /var/log/auth.log
  ```

- You should see the following lines in the output.

  ```
  Oct 30 20:09:05 <hostname> sudo: pam_unix(sudo:auth): authentication failure; logname= uid=1000 euid=0 tty=/dev/pts/1 ruser=user1 rhost=  user=user1
  Oct 30 20:09:13 <hostname> sudo:    user1 : 3 incorrect password attempts ; TTY=pts/1 ; PWD=/home/user1 ; USER=root ; COMMAND=/usr/bin/su
  ```

- The audit log file contains several other events. We can filter for failed log in attempts with the text filtering editors.

  ```
  cat /var/log/auth.log | grep -P "(?i)authentication failure|incorrect password"
  ```

- `journalctl` can also display such logs. Let’s run `journalctl` and filter for authentication failure.

  ```
  journalctl | grep -P "(?i)authentication failure|incorrect password"
  ```

- Create a script that automatically extracts these failed authentication logs and save them to another file. This makes it easier to quickly detect security violations. Create a script `track_auth_fail.sh` with the following content:

  ```bash
  #!/bin/bash
  
  tail -n0 -f /var/log/auth.log | \
  grep -P --line-buffered "authentication failure|incorrect password" |\
  tee /var/log/failed_auth.log
  ```

- Run the script in the background and suppress it’s output.

  ```
  sudo bash track_auth_fail.sh > /dev/null 2>&1 &
  ```

- Simulate a failed login for `testuser`

  ```bash
  $ su testuser
  Password: 
  su: Authentication failure
  ```

- Check the new log file with `tail /var/log/failed_auth.log` and you should see log similar to the following:

  ```
  Oct 30 21:15:37 sna-vm su: pam_unix(su:auth): authentication failure; logname= uid=1000 euid=0 tty=/dev/pts/0 ruser=user1 rhost=  user=testuser
  ```

## Exercise 10: User sessions and sudo usage

- We can run commands as other users from our login session. When we do this, a new user session is opened. Run a command as `testuser`

  ```
  $ su - testuser -c "whoami"
  Password: 
  testuser
  ```

- Now check the auth log file to see if this activity is logged.

  ```
  $ tail  /var/log/auth.log
  ```

  You should get output similar to the following:

  ```
  Oct 30 21:55:49 <hostname> su: (to testuser) user1 on pts/1
  Oct 30 21:55:49 <hostname> su: pam_unix(su-l:session): session opened for user testuser(uid=1001) by (uid=1000)
  Oct 30 21:55:50 <hostname> su: pam_unix(su-l:session): session closed for user testuser
  ```

  - The first line of log above shows that `user1` first attempted to use the `su` utility to switch to `testuser`.
  - The second line shows that the session was opened.
  - The third line shows that the session was closed. This happened after the command finished executing.

- Sudo usage logs are also saved in `/var/log/auth.log`. When a user runs `sudo`, they open a sudo session.

- Filter the log file for `sudo`. Run the following command:

  ```
  sudo ip a
  ```

- View the log file using `tail  /var/log/auth.log` You should get output siilar to the following:

  ```
  Oct 30 22:03:20 sna-vm sudo:    user1 : TTY=pts/0 ; PWD=/home/user1 ; USER=root ; COMMAND=/usr/sbin/ip a
  Oct 30 22:03:20 sna-vm sudo: pam_unix(sudo:session): session opened for user root(uid=0) by (uid=1000)
  Oct 30 22:03:20 sna-vm sudo: pam_unix(sudo:session): session closed for user root
  ```

- When a user attempts to use sudo to execute a command as `root`, that command is logged to the auth file as seen in the first line of the output above.

- Filter the log to view all attempts made to execute commands as `root`

  ```
  cat /var/log/auth.log | grep -P "USER=root.*COMMAND="
  ```

  You should get output similar to the following:

  ```
  Oct 30 21:15:23 sna-vm sudo:    user1 : TTY=pts/0 ; PWD=/home/user1 ; USER=root ; COMMAND=/usr/bin/bash track_auth_fail.sh
  Oct 30 21:47:54 sna-vm sudo:    user1 : TTY=pts/1 ; PWD=/home/user1 ; USER=root ; COMMAND=/usr/sbin/ip a
  Oct 30 22:03:20 sna-vm sudo:    user1 : TTY=pts/0 ; PWD=/home/user1 ; USER=root ; COMMAND=/usr/sbin/ip a
  Oct 30 22:07:25 sna-vm sudo:    user1 : 3 incorrect password attempts ; TTY=pts/4 ; PWD=/home/user1 ; USER=root ; COMMAND=/usr/sbin/ip a
  ```

## Exercise 11: Time zone

- Check the current time zone

  ```
  timedatectl
  ```

  You should get output similar to the following:

  ```
  Local time: Sun 2024-03-10 21:37:11 EET
             Universal time: Sun 2024-03-10 19:37:11 UTC
                   RTC time: Sun 2024-03-10 21:37:10
                  Time zone: Africa/Cairo (EET, +0200)
  System clock synchronized: yes
                NTP service: active
            RTC in local TZ: yes
  ```

- Assume that we are somewhere else and we want to change the timezone to (GMT +10). To do this, first get a list of all available time zones.

  ```
  timedatectl list-timezones
  ```

  You will find the full name for the time zone in the long list of output.

- Now that we have identified the name of the time zone on our system, switch to that with the following command:

  ```
  sudo timedatectl set-timezone Continent/Country
  ```

- Run `timedatectl` and you should get output different from what we had initially.

- You can manually change the time zone with a symlink. The symlink at `/etc/localtime` points to the time zone that is currently configured.

  ```
  $ ls -l /etc/localtime
  lrwxrwxrwx 1 root root 36 ноя  6 18:54 /etc/localtime -> /usr/share/zoneinfo/Asia/Vladivostok
  ```

- Remove the symlink

  ```
  sudo rm -rf /etc/localtime
  ```

- Let’s change time zone to Moscow time. To do this, create a new symlink to the Moscow time `Europe/Moscow` in `/usr/share/zoneinfo/`

  ```
  sudo ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
  ```

- Check the time zone again.

  ```
  timedatectl
  ```

## Exercise 12: Package managers

A package manager automates the process of installing, configuring, upgrading, and removing packages. There are several package managers depending on the OS. This exercise focuses on Ubuntu package managers.

> Note that Ubuntu is based on the Debian distro and it uses the same APT packaging system as Debian and shares a huge number of packages and libraries from Debian repositories.

### Part 1: dpkg

`dpkg` is a tool that allows the installation and analysis of `.deb` packages. It can also be used to package software.

- View a list of all installed packages using `dpkg -l`. You should get an output similar to the following:
  ![img](https://i.imgur.com/Te0ZnIm.png)

- Install a local `.deb` file using the command `dpkg -i <deb-package>`. Let’s download and install Google Chrome browser

  ```
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  dpkg -i google-chrome-stable_current_amd64.deb
  ```

- Verify the package installation using `dpkg -s <deb-package>`

  ```
  dpkg -s google-chrome-stable
  ```

  You get an output similar to the following

  ```
  Package: google-chrome-stable
  Status: install ok installed
  Priority: optional
  Section: web
  Installed-Size: 299404
  Maintainer: Chrome Linux Team <chromium-dev@chromium.org>
  Architecture: amd64
  Version: 107.0.5304.87-1
  Provides: www-browser
  Depends: ca-certificates, fonts-liberation, libasound2 (>= 1.0.17), libatk-bridge2.0-0 (>= 2.5.3), libatk1.0-0 (>= 2.2.0), libatspi2.0-0 (>= 2.9.90), libc6 (>= 2.17), libcairo2 (>= 1.6.0), libcups2 (>= 1.6.0), libcurl3-gnutls | libcurl3-nss | libcurl4 | libcurl3, libdbus-1-3 (>= 1.5.12), libdrm2 (>= 2.4.60), libexpat1 (>= 2.0.1), libgbm1 (>= 8.1~0), libglib2.0-0 (>= 2.39.4), libgtk-3-0 (>= 3.9.10) | libgtk-4-1, libnspr4 (>= 2:4.9-2~), libnss3 (>= 2:3.26), libpango-1.0-0 (>= 1.14.0), libwayland-client0 (>= 1.0.2), libx11-6 (>= 2:1.4.99.1), libxcb1 (>= 1.9.2), libxcomposite1 (>= 1:0.4.4-1), libxdamage1 (>= 1:1.1), libxext6, libxfixes3, libxkbcommon0 (>= 0.4.1), libxrandr2, wget, xdg-utils (>= 1.0.2)
  Pre-Depends: dpkg (>= 1.14.0)
  Recommends: libu2f-udev, libvulkan1
  Description: The web browser from Google
   Google Chrome is a browser that combines a minimal design with sophisticated technology to make the web faster, safer, and easier.
  ```

- List all files installed by a package with the command `dpkg -L <package-name>`

  ```
  dpkg -L google-chrome-stable
  ```

- Remove a package using `dpkg -r <package-name>`

  ```
  dpkg -r google-chrome-stable
  ```

- Check the status of the package again and you should see that it is in the `deinstall` state, but the configuration files are still present.

  ```
  dpkg -s google-chrome-stable
  Package: google-chrome-stable
  Status: deinstall ok config-files
  ```

  The `-r` option simply removes the package but all the configuration files are preserved.

- To remove a package along with its configuration files, specify the `--purge` option.

  ```
  $ dpkg --purge google-chrome-stable
  ```

- Check the status of the package to verify that the package and all its configuration files have been removed.

  ```
  $ dpkg -s google-chrome-stable
  dpkg-query: package 'google-chrome-stable' is not installed and no information is available
  Use dpkg --info (= dpkg-deb --info) to examine archive files.
  ```

### Part 2: APT

The Advanced Packaging Tools (APT) is a package manager on Ubuntu systems. `apt` acts as a user friendly tool that interacts with `dpkg`. Unlike `dpkg`, `apt` allows download and installation of packages from online repositories.

- View all available packages in your repository using `apt list`

- To list only installed packages, use `apt list --installed`

- Search for a package using `apt search`.

  ```
  apt search chromium
  ```

- After knowing the correct package name, you can find out more details about the package using `apt show`

  ```
  apt show chromium-browser
  ```

- Proceed to install the package using `apt install`

  ```
  apt install chromium-browser
  ```

- Remove a package using `apt remove`

  ```
  apt remove chromium-browser
  ```

  > You can install or remove multiple packages in one command by separating them by spaces. e.g `apt install package1 package2 package3`.
  > To remove multiple packages is similar e.g `apt remove package1 package2 package3`.

- Specify the `remove` option in combination with the `--purge` option to remove a package along with its configuration.

  ```
  apt remove --purge chromium-browser
  ```

- Specify `autoremove` to remove the package and its dependencies, if not used by any other application. The format is shown below:

  ```
  apt autoremove <package-name>
  ```

  > `apt autoremove` without a package name will remove unused dependencies and free space. 

- You can update the APT package index to get a list of the available packages. This list can indicate installed packages that need upgrading, as well as new packages that have been added to the repositories. The repositories are defined in the `/etc/apt/sources.list` file and in the `/etc/apt/sources.list.d` directory.

- View the `sources.list` file to see all the defined repositories.

  ```
  cat /etc/apt/sources.list
  ```

- To update the local package index with latest updates to repositories, use the following command:

  ```
  apt update
  ```

- APT maintains a list of packages (package index) in `/var/lib/apt/lists/`

  ```
  ls -lah /var/lib/apt/lists/
  ```

- To upgrade a single package that has been previously installed, run the `apt install <package-name>` command.

- To upgrade all installed packages, run the following command:

  ```
  $ apt upgrade
  ```

  This command will upgrade all packages that can be upgraded without installing additional packages or removing conflicting installed packages.

- Run `apt full-upgrade` to upgrade the packages, the kernel, and remove conflicting packages or install new ones. The `full-upgrade` option is “smart” and can remove unnecessary dependency packages, or install new ones (if required).

### Part 3: sources.list

- View the `sources.list`file without the comments

  ```
  $ grep -o '^[^#]*' /etc/apt/sources.list
  deb http://ru.archive.ubuntu.com/ubuntu/ jammy main restricted
  deb http://ru.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
  deb http://ru.archive.ubuntu.com/ubuntu/ jammy universe
  deb http://ru.archive.ubuntu.com/ubuntu/ jammy-updates universe
  deb http://ru.archive.ubuntu.com/ubuntu/ jammy multiverse
  deb http://ru.archive.ubuntu.com/ubuntu/ jammy-updates multiverse
  deb http://ru.archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
  deb http://security.ubuntu.com/ubuntu jammy-security main restricted
  deb http://security.ubuntu.com/ubuntu jammy-security universe
  deb http://security.ubuntu.com/ubuntu jammy-security multiverse
  ```

- Each line in the `sources.list` has a structure in the following order: 

  ```
  Type	URL	Distribution	Component
  ```

- Let’s analyze the first line in the `sources.list` above.

  - The **Type** is `deb`. The term `deb` indicates that it is a repository of binaries.
  - The repository **URL** is `http://ru.archive.ubuntu.com/ubuntu/`. This is the location of the repository where the packages will be downloaded.
  - The **Distribution** is `jammy`. This is the short code name of the release. Run `$ cat /etc/os-release` to view the `VERSION_CODENAME` of your system.
  - The Components are `main` and `restricted`. These are information about the licensing of the packages in the repository.
    - `main` contains Canonical supported free and open source software.
    - `restricted` contains proprietary drivers for devices.
    - `universe` contains community supported free and open source software.
    - `multiverse` contains software restricted by copyright or legal issues.

### Part 4: Adding repositories

- Let’s try to install a package that is not in Ubuntu repository by default. Try installing MongoDB using `apt install mongo-db`. You should get an output similar to the following

  ```
  Reading package lists... Done
  Building dependency tree... Done
  Reading state information... Done
  E: Unable to locate package mongodb-org
  ```

- We need to add the MongoDB repository to our repository sources. The basic syntax of the add-apt-repository command is as follows:

  ```
  add-apt-repository [options] repository
  ```

- The `repository` can be a regular repository entry that can be added to `sources.list` in the format 

  ```
  deb http://ru.archive.ubuntu.com/ubuntu/ distro component
  ```

- Or a PPA repository in the `ppa:<user>/<ppa-name>` format

- First import MongoDB PGP key. The key is used to verify the integrity of packages that are downloaded from this repository.

  ```
  $ curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-6.gpg
  ```

- Create a list for MongoDB

  ```
  add-apt-repository 'deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse'
  ```

  > Alternatively, you can manually create the list file and add the repository to it.
  >
  > ```
  > echo "echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
  > ```

- View the new list file that has been created

  ```
  cat /etc/apt/sources.list.d/*mongodb*.list
  ```

- The `add-apt-repository` command automatically updates the local package database for you. If you added the repository via an alternative means, you need to run `apt update` to update the local package database.

- View the package index directory to see the MongoDB related files created.

  ```
  ls -lah /var/lib/apt/lists/ | grep mongodb
  ```

  > MongoDB requires `libssl1.1 (>= 1.1.1)`. So let’s download and install this package before proceeding
  >
  > ```
  > $ wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb
  > $ dpkg -i ./libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb
  > ```

- You can now proceed to install MongoDB from the newly enabled repository.

  ```
  apt install mongodb-org
  ```

  > You can answer the prompt that asks you to type `Y` to verify your choice by adding the option `-y` to your install command in the format `apt install mongodb-org -y`. This is very useful when writing scripts that install packages.

- Verify that MongoDB has been installed

  ```
  mongod --version
  ```

- You can remove a previously enabled repository using the format 

  ```
  add-apt-repository --remove repository
  ```

- Let’s remove the MongoDB repository

  ```
  add-apt-repository --remove 'deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse'
  ```

- Run the following commands to verify that the repository has been removed.

  ```
  ls -lah /var/lib/apt/lists/ | grep mongodb
  cat /etc/apt/sources.list.d/*mongodb*.list
  ```

- You can use `apt purge` to remove a package along with its configuration

  ```
  apt purge mongodb-org
  ```

### Part 5: Creating a custom Ubuntu package

- Create a directory for the package. We will name the package `test`

  ```
  mkdir test_package
  ```

- Create the internal structure by placing your program files where they should be installed to on the target system. In this case, we want to place the program file in `/usr/local/bin` on the target system, therefore we create the directory `test/usr/local/bin`

  ```
  mkdir -p test_package/usr/local/bin
  ```

- Create the program file (script) `nano test_package/usr/local/bin/script` and add the following to it.

  ```bash
  #!/bin/bash
  echo "Hello World!"
  ```

- Give the program file execute permission

  ```
  chmod +x test_package/usr/local/bin/test_package
  ```

- Create a directory `DEBIAN` in the package directory

  ```
  mkdir test_package/DEBIAN
  ```

- Create the control file in the `DEBIAN` directory. The control file contains package description and information about the maintainer. Create the file `test/DEBIAN/control` and add the following content.

  ```
  Package: test_package
  Version: 1.0
  Maintainer: <username>
  Architecture: all
  Description: Test Script
  ```

  > These are mandatory fields in the control file. There are several other fields that can be defined.

- Build the package with 

  ```
  dpkg-deb --build --root-owner-group test_package
  ```

  > The `--root-owner-group` flag makes all deb package content owned by the root user. Without this flag, all files and folders would be owned by your user, which might not exist in the target system the deb package would be installed to.

- You should have a debian package in your current working directory named `test_package.deb`. Proceed to install this package.

  ```
  dpkg -i test_package.deb
  ```

- You should get an output similar to the following

  ```
  Selecting previously unselected package test_package.
  (Reading database ... 195723 files and directories currently installed.)
  Preparing to unpack test_package.deb ...
  Unpacking test_package (1.0) ...
  Setting up test_package (1.0) ...
  ```

- Run the newly installed package. You can have a compiled application in place of the script we have used.

  ```
  $ test_package
  Hello World!
  ```

