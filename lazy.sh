#!/bin/sh
# name: lazy
# version: 0.0.2
# author: Daniel Rocha  <danielrocha.d.silva@gmail.com>
# describe: Commit generator
# license: MIT

LC_TIME=en_US.utf8

    repository="green"
    path=$(pwd)

    main_file="file.txt"
    shuffler=false
    total_commits=0
    
    from=""
    to=""
    version="0.0.2"



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
            cd "$path/$repository/"                 \
            && git gc --quiet 

    }

    __default()
    {
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
        echo "Version: $version"
        exit 0
    }


    show_help()
    {
        echo "$_help" | less
        exit 0
    }


    install_lazy()
    {
        echo "- installing 'lazy' ..."
        sudo cp "$path"/lazy.sh /usr/bin/lazy
        echo "for uninstall:\n\t$ lazy -u or lazy --uninstall"
        exit 0
    }


    uninstall_lazy()
    {
        echo "- uninstalling 'lazy'"
        sudo rm /usr/bin/lazy 
        echo "- Finished"
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

    # echo "P1: $1 P2: $2"

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
        echo "Dates must be 'from': past 'to': future\n\tUse: ./lazy -h\n"
        exit 1
    fi

    
    interator=0
    while [ $interator -le $days ]
    do
 
        echo -n "\r>> Processing $(( interator * 100 / days))%"

        interator=$(( interator + 1 ))
        commit_date=$(date -d "$from $interator days" +%a' '%b' '%d' '%H:%M:%S' '%Y' '%z)  
        add_commit "$commit_date"
    done

    echo "\n>> Finished"
    echo ">> Generated repository from: '$from' to: '$to':"
    echo "   Report:\n\tDays:    $days\n\tCommits: $total_commits\n"
    echo "   Path repository: $path/$repository\n"
}

handle_input "$1" "$2" "$3" "$4"
create_repository "$from"
fill_interval "$from" "$to"
