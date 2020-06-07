#!/bin/sh
# ./main.sh "from date" "to date"
# ./main.sh "1 Nov 15" "1 Aug 20"
# ./main.sh "1 Aug 20" "1 Nov 15"  

    repository="green"
    path=$(pwd)
    date=$(date)

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

    from=$2
    to=$1

    date_between=$(datediff "$from" "$to")
    # echo $date_between


# hours=$(date -d "now" +%d:%m:%y)
fill_interval()
{
    interator=0
    while [ $interator -le  $date_between ]
    do
        # echo $interator
        interator=$(( interator + 1 ))
        echo $(date -d "$interator $(date -d "$from" +%b' '%Y)")
        # echo $(date -d "$from" +%b' '%Y)
    done
}

# fill_interval

git_add()
{
    cd $repository          \
    && date >> file.txt \
    && git add .        \
    && git commit -m "  
        FAKE - $date    

        Adding a fake commit git"  \
        > /dev/null \
    && echo "OK!"
}



#   CRIAR PASTA PARA O REPOSITORIO FAKE
if ! [ -d "$path/$repository" ];
then
    mkdir $repository
fi


#   INICIAR REPOSITORIO
if ! [ -d "$path/$repository/.git/" ];
then
    echo "Criado repositorio : '$repository' \r"
    git init "$path/$repository/" > /dev/null
fi

git_add
    # && git commit --amend --no-edit --date "$(date)" 





# # git commit --amend --no-edit --date "$(date)"
# # date --date="165 day ago" 
# # git log --pretty=format:'' | wc -l