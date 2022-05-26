#!/bin/bash
# local judger !

mkdir .pyt_history

printf "if you want to change your judger's history : \n"
printf "0 -> no\n"
printf "1 -> yes\n"
read op
printf "\n"

if [ $op -eq 1 ]
then {
    printf "choose the tpye : \n"
    printf "0 : use data maker\n"
    printf "1 : use data\n"
    read typ
    printf "\n"

    printf "your cpp's name : \n"
    read nam
    printf "\n"

    printf "how many testcases do you want to judge : \n"
    read lim
    printf "\n"

    {
        printf "$typ\n"
        printf "$nam\n"
        printf "$lim\n"
    } > ./.pyt_history/all_history
}
else {
    {
        read typ
        read nam
        read lim
    } < ./.pyt_history/all_history
}
fi

shopt -s expand_aliases
alias by="g++ -O2"

if [ $typ -eq 0 ]
then {
    mkdir .pyt_make
    if [ $op -eq 1 ]
    then {
        printf "maker's name : "
        read maker
        printf "\n"

        printf "std's name : "
        read std
        printf "\n"

        {
            printf "$maker\n"
            printf "$std\n"
        } > ./.pyt_history/make_history
    }
    else {
        {
            read maker
            read std
        } < ./.pyt_history/make_history
    }
    fi
    by $maker.cpp -o $maker
    by $nam.cpp -o $nam
    by $std.cpp -o $std
    for((i=1;i<=$lim;i++))
    do
        ./$maker > ./.pyt_make/pyt.in
        time ./$nam < ./.pyt_make/pyt.in > ./.pyt_make/pyt.out
        ./$std < ./.pyt_make/pyt.in > ./.pyt_make/std.out
        if diff ./.pyt_make/pyt.out ./.pyt_make/std.out
        then printf "$i testcase Accepted! \n"
        else {
            printf "Wrong Answer on test $i \n"
            cp ./.pyt_make/pyt.in wa.in
            cp ./.pyt_make/std.out wa.out 
            break
        }
        fi
    done
}
else {
    mkdir .pyt_data
    if [ $op -eq 1 ]
    then {
        printf "data's name : \n"
        read dat
        printf "\n"

        printf "timelimits : \n"
        read tim
        printf "\n"

        {
            printf "$dat\n" 
            printf "$tim\n"
        } > ./.pyt_history/data_history
    }
    else {
        {
            read dat
            read tim
        } < ./.pyt_history/data_history
    }
    fi
    let cnt_ac=0
    let cnt_tle=0
    let cnt_wa=0
    let wa_id=0
    let tle_id=0
    by $nam.cpp -o $nam
    time for((i=1;i<=$lim;i++))
    do
        cp ./testcases/$dat$i.in ./.pyt_data/pyt.in
        cp ./testcases/$dat$i.ans ./.pyt_data/pyt.out
        if ! timeout $tim ./$nam < ./.pyt_data/pyt.in > ./.pyt_data/my.out
        then {
            printf "# test $i : "
            printf "Time Limit Exceeded ! \n"
            time ./$nam < ./.pyt_data/pyt.in > ./.pyt_data/my.out
            let cnt_tle=cnt_tle+1
            if [ $tle_id -eq 0 ]
            then {
                tle_id=$i;
            }
            fi
            printf "\n"
            continue;
        }
        fi
        if diff ./.pyt_data/pyt.out ./.pyt_data -w -q
        then {
            printf "# test $i : "
            printf "Accepted ! \n"
            let cnt_ac=cnt_ac+1
        }
        else {
            printf "# test $i : "
            printf "Wrong Answer ! \n"
            let cnt_wa=cnt_wa+1
            if [ $wa_id -eq 0 ]
            then {
                wa_id=$i;
            }
            fi
        }
        fi
        printf "\n"
    done

    printf "\nover!\n"

    printf "Accepted             on $cnt_ac testcases ! \n"
    printf "Wrong Answer         on $cnt_wa testcases ! \n"
    printf "Time Limit Exceeded  on $cnt_tle testcases ! \n"
    printf "\n"
    if [ $wa_id -ne 0 ]
    then {
        printf "The first Wrong Answer on test $wa_id \n"
    }
    fi
    if [ $tle_id -ne 0 ]
    then {
        printf "The first Time Limit Exceeded on test $tle_id \n"
    }
    fi
    printf "\n"
    let float sco=100*$cnt_ac/$lim
    printf "your score : $sco \n"
}
fi
