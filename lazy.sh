#!/bin/sh
# name: lazy
# version: 0.0.1
# author: Daniel Rocha  <danielrocha.d.silva@gmail.com>
# describe: Commit generator
# license: MIT

LC_TIME=en_US.utf8

    repository="green"
    path=$(pwd)
    date=$(date)
    main_file="file.txt"
    
    from=$1
    to=$2

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
                        
   cd "$path/$repository/"                  \
    && date >> "$main_file"                 \
    && git add .                            \
    && git commit -m "FAKE - $commit_date"  \
       --date "$commit_date" > /dev/null
     
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
 Usage: ./lazy.sh <date from> <date to> <repository-name>
    options    
        --help\t | -h : display this help and exit
        --global | -g : make available throughout the system
        --remove | -r : remove from the system
        --version
        
            date: '1 Nov 15' day, month, year
        
        Example:
            $ ./lazy.sh "1 Nov 20" "20 Nov 19" "sleep-project"

EOF
)
    
    if [ "$1" = "--help" ] || [ "$1" = "-h" ];
    then
        echo "$_help"
        exit 0
    fi

    if [ "$1" = "--global" ] || [ "$1" = "-g" ];
    then
        echo "Adicionando"
        exit 0
    fi

    if [ "$1" = "--remove" ] || [ "$1" = "-r" ];
    then
        echo "Removendo"
        exit 0
    fi

    # Renomear repositorio
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
        echo "Dates must be 'from': past 'to': future\n\tUse: ./lazy -h\n"
        exit 1
    fi


    echo ">> Processing ..."
    
    interator=0
    while [ $interator -le $days ]
    do
        interator=$(( interator + 1 ))
        commit_date=$(date -d "$from $interator days" +%a' '%b' '%d' '%H:%M:%S' '%Y' '%z)  
        add_commit "$commit_date"
    done

    echo ">> Finished"
    echo ">> Generated repository from: '$from' to: '$to':"
    echo "   Report:\n\tDays:    $days\n\tCommits: $interator\n"
    echo "   Path repository: $path/$repository\n"
}

handle_input "$1" "$2" "$3"
create_repository "$from"
fill_interval "$from" "$to"
