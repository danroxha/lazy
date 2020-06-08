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
    check=$(false)

datediff() {
    # >> $ datediff '1 Nov' '1 Aug'
    # >> 91 days
    
    date_from=$(date -d "$1" +%s)
    date_to=$(date -d "$2" +%s)
    
    date_diff=$(( (date_from - date_to) / 86400 ))

    if [ $date_diff -lt  0 ];
    then
        date_diff=$(( date_diff * -1 ))
    fi

    echo $date_diff
}

    from=$1
    to=$2

    date_between=$(datediff "$from" "$to")


git_add()
{
    
    cd "$path/$repository/"         \
    && date >> file.txt             \
    && git add .                    \
    && git commit -m "  
        FAKE - $1    
 
        Adding a fake commit git"   \
        > /dev/null                 \
    && git commit --amend --no-edit --date "$1" > /dev/null
}


create_fake_repository()
{
    #   CRIAR PASTA PARA O REPOSITORIO FAKE
    if ! [ -d "$path/$repository" ];
    then
        mkdir $repository
    fi


    #   INICIAR REPOSITORIO
    if ! [ -d "$path/$repository/.git/" ];
    then
        echo ">> Repositorio Criado: '$repository' \r"
        git init "$path/$repository/" > /dev/null
    fi

}


handle_input()
{
    _message="
    Usage: ./fake.sh 'date' 'date' 'repository-name'\n
    Try './fake --help or -h' for more information.
    "

    _help="
    Usage: ./fake.sh <date> <date> 'repository-name'\n
        \t--help | -h : display this help and exit\n
        \n    
        \tdate: '1 Nov 15' day, mouth, year \n
        \n
        \tExample: \n
            \t\t$ ./fake.sh \"1 Nov 20\" \"20 Nov 19\" \"sleep-project\"
   
    "

    if [ $1 = "--help" ] || [ $1 = "-h" ];
    then
        echo $_help
        exit 1
    fi

    if [ -z $1 ] || [ -z $2 ];
    then
        echo $_message
        exit 1
    fi

}


fill_interval()
{
    interator=0
    echo ">> Processing ..."
    while [ $interator -le $date_between ]
    do
        interator=$(( interator + 1 ))
        new_date=$(date -d "$from $interator days" +%a' '%b' '%d' '%H:%M:%S' '%Y' '%z)  
        git_add "$new_date"
    done

    echo ">> Finished"
    echo ">> Fake repository: \n\t$path/$repository"
}

handle_input $1 $2

if ! [ -z $3 ];
then
    repository=$3
fi

create_fake_repository

fill_interval
