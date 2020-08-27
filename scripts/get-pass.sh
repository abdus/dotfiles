FILE=~/.passwd.csv.gpg
printf "\n\n"

gpg --decrypt "$FILE" 2>/dev/null | grep --color="always" -i $1

printf "\n\nclearing in "
sleep 1
printf ..5 
sleep 1
printf ..4 
sleep 1
printf ..3 
sleep 1
printf ..2 
sleep 1
printf ..1
sleep 1
printf 0
clear


