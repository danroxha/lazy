#!/usr/bin/env sh
# name: lazy
# version: 0.0.2
# author: Daniel Rocha  <danielrocha.d.silva@gmail.com>
# repository: https://github.com/dannRocha/lazy/
# description: Commit generator
# license: MIT

export LC_TIME=en_US.utf8

    repository="green"
    path=$(pwd)

    main_file="file.txt"
    shuffler=false
    total_commits=0
    
    from=""
    to=""
    version="0.0.3"



datediff() 
{
    
    date_from=$(date -d "$1" +%s)
    date_to=$(date -d "$2" +%s)
    
    a_day_in_seconds=86400 

    date_diff=$(( (date_to - date_from) / a_day_in_seconds))

    echo $date_diff
}


add_commit()
{
    commit_date=$1


    __shuffler()
    {   
    
        nsec=$(date +%N)
        percent=8
        number_commit=$(echo $(date +%N) | cut -b 3)

        # Simulate days when "DEV" didn't code
        if [ $number_commit -gt $percent ] || [ $number_commit -eq 0 ]; then
            return
        fi

        
        inter=0
        while [ $inter -le $number_commit ]
        do

            inter=$(( inter + 1 ))
            total_commits=$(( total_commits + 1 ))

            cd "$path/$repository/"                 \
            && date >> "$main_file"                 \
            && git add .  > /dev/null               \
            && git commit -m "$number_commit FAKE - $commit_date"  \
            --date "$commit_date" > /dev/null \
            
        done
        
        echo "Last commit $(date)" > $main_file
        
        cd "$path/$repository/"                 \
        && git gc --quiet 

    }


    __default()
    {

        total_commits=$(( total_commits + 1 ))

        cd "$path/$repository/"                 \
        && date >> "$main_file"                 \
        && git add .                            \
        && git commit -m "FAKE - $commit_date"  \
        --date "$commit_date" > /dev/null

    }

    
    case $shuffler in
     true ) __shuffler ;;
     false) __default  ;;
    esac

}


create_repository()
{
   
    if ! [ -d "$path/$repository" ];
    then
        
        mkdir $repository 

        cd "$repository/"           \
        && touch -d "$1" .gitignore \
        && git init > /dev/null
    
    fi

}


handle_input()
{

_message=$(cat << EOF
Usage: ./lazy.sh 'date from' 'date to' 'repository-name'\n
Try './lazy --help or -h' for more information.
EOF
)

_help=$(cat << EOF
    NAME
        lazy - generator commit
    
    
    SYNOPSIS
        
        lazy.sh <date from> <date to> <repository-name>
        or
        lazy.sh -s <date from> <date to> <repository-name>


    DESCRIPTION

        The script generates a repository and populates it with
        commits between dates passed by argument. By default the
        repository is generated with a commit per day between the
        dates passed by arguments, with the default name of 'green'.


    OPTIONS

        --help     | -h : display this help and exit
        --install  | -g : make available throughout the system
        --uninstall| -r : remove from the system
        --version  | -v : show version
        --shuffler | -s : shuffler days and amount of commit

    EXEMPLE

        date: '1 Nov 15' day=number; month=string; year=number
         --> valid dates
            * "day month year"
            * "month day year"
            * "year day month"

            Example:
                "november 01 2015" or "nov 01 2015"

        Example:
            $ ./lazy.sh "1 Nov 20" "20 Nov 19" "sleep-project"
            $ ./lazy.sh -s "1 Nov 20" "20 Nov 19" "sleep-project"

EOF
)
    show_version()
    {
        echo "lazy version $version"
        exit 0
    }


    show_help()
    {
        echo "$_help" | less
        exit 0
    }


    install_lazy()
    {
        lazy --version $1 &> /dev/null

        if [ $? -eq 0 ]; then
            echo -e "\033[1;33m- lazy's installed\033[0;0m"
            exit 0
        fi

        echo -e "\033[1;32m- installing 'lazy' ...\033[0;0m"

        sudo --version $1 &> /dev/null;

        if [ $? -eq 0 ]; then
            sudo cp "$path"/lazy.sh /usr/bin/lazy ;
        else
            cp "$path"/lazy.sh /usr/bin/lazy ;
        fi

        echo -e "\033[1;33mfor uninstall:\n\t$ lazy -u or lazy --uninstall\033[0;0m"
        exit 0
    }


    uninstall_lazy()
    {
        lazy --version $1 &> /dev/null

        if [ $? -ne 0 ]; then
            echo -e "\033[1;33m- lazy not installed\033[0;0m"
            exit 0
        fi

        echo -e "\033[1;33m- uninstalling 'lazy'"

        sudo --version $1 &> /dev/null

        if [ $? -eq 0 ]; then
            sudo rm /usr/bin/lazy ;
        else
            rm /usr/bin/lazy ;
        fi

        echo -e "\033[1;32m- Finished\033[0;0m"
        exit 0
    }


    case $1 in
        "--help"     | "-h") show_help      ;;
        "--version"  | "-v") show_version   ;;
        "--install"  | "-i") install_lazy   ;;
        "--uninstall"| "-u") uninstall_lazy ;;
        "--shuffler" | "-s") shuffler=true 

            
            from="$2"
            to="$3"

            
            if ! [ -z $4 ];
            then
                repository="$4"
            fi


            if [ -z "$2" ] || [ -z "$3" ];
            then
                echo "$_message"
                exit 1
            fi
        
            return
        ;;
        * ) ;;
    esac
    

    from="$1"
    to="$2"


    if ! [ -z $3 ];
    then
        repository="$3"
    fi


    if [ -z "$1" ] || [ -z "$2" ];
    then
        echo "$_message"
        exit 1
    fi
}


fill_interval()
{

    from="$1"
    to="$2"

    days=$(datediff "$from" "$to")
    

    if [ $days -le  0 ];
    then
        echo -e "\033[1;31mDates must be 'from'\033[0;0m: \033[;7m past \033[0;0m \033[1;31m'to'\033[0;0m: \033[;7m future \033[0;0m\n\t\033[1;33mUse: ./lazy -h\033[0;0m\n"
        exit 1
    fi

    
    interator=0
    while [ $interator -le $days ]
    do
 
        echo -e -n "\r>> \033[;1mProcessing \033[0;0m$(( interator * 100 / days))%"

        interator=$(( interator + 1 ))
        commit_date=$(date -d "$from $interator days" +%a' '%b' '%d' '%H:%M:%S' '%Y' '%z)  
        add_commit "$commit_date"
        
    done

    echo -e "\n>> \033[;1mFinished"
    echo -e ">> \033[;1mGenerated repository from: \033[;7m$from\033[0;0m \033[;1mto:\033[0;0m \033[;7m$to\033[0;0m"
    echo -e "   \033[1;33mReport:\n\tDays:    $days\n\tCommits: $total_commits\n\033[0;0m"
    echo -e "   \033[;1mPath repository:\033[0;0m \033[;7m$path/$repository\033[0;0m\n"
}

handle_input "$1" "$2" "$3" "$4"
create_repository "$from"
fill_interval "$from" "$to"
