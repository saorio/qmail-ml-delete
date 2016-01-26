#!/bin/bash
#var1 = userid
#var2 = userid@dmm.com / userid@dooga.co.jp
#var3 = operator

echo -n "Enter the values of variables 'var1' and 'var2' "
echo -n "(separated by a space or tab): "
read var1 var2 var3
#echo "var1 = $var1      var2 = $var2"
date=`date +%Y%m%d`
homedir=`id $var1`

#array
mailad=(`find /var/qmail/alias/ -type f -name ".qmail*" | xargs grep ${var2}`)
disp_mailad=`find /var/qmail/alias/ -type f -name ".qmail*" | xargs grep ${var2}`
mailad=($(find /var/qmail/alias/ -type f -name ".qmail*" | xargs grep ${var2}))
printf "%s -----------home directory--------\n"
printf "%s$homedir\n"
printf "%s ---------------------------------\n"
printf "%s------------mailing list----------\n"
printf "%s$disp_mailad\n"
printf "%s----------------------------------\n"

#sanitize1
for obj in "${mailad[@]}"; do
  obj2=($(printf "$obj" | sed -e "s/:.*//"))
# if [[ ${obj} =~ \d{8} ]]; then
# echo 'this is skip'
#else
 obj3+=("$obj2")
# fi
done

#echo -e ${obj3[@]}

#sanitize2
ptn='([0-9]{8})'
for obj4 in "${obj3[@]}"; do
# echo $obj4
 if [[ ! "${obj4[@]}" =~ $ptn ]]; then
#  echo "tooru"
 delmail+=("$obj4")
else
 unset obj4
 fi
done

printf "%s------------delete list--------\n"
echo -e ${delmail[@]}
printf "%s--------------------------------\n"

#sanitize3
for mlfile in "${delmail[@]}"; do
# echo $mlfile
  mlfile_stz=($(printf ""$mlfile | sed -e "s/^\/var\/qmail\/alias\///"))
  mlfile_lst+=("$mlfile_stz")
# echo -e ${mlfile_lst}
done

#copy-ml-file
for mailfile in "${mlfile_lst[@]}"; do
 echo $mailfile
 cp -p /var/qmail/alias/$mailfile /backup/2016/$mailfile.$date.$var3
done

#mailing-list-delete
for mailfile in "${mlfile_lst[@]}"; do
 echo $mailfile
#sed -e 's/^\$var2//g' /var/qmail/alias/$mailfile > /var/qmail/alias/$mailfile
 sed -i -e '/^$var2/d' /var/qmail/alias/$mailfile
done

#mailad2=`echo $mailad | egrep -v '[0-9]{8}'`
#mailad2=`echo $mailad | awk 'match($0, [0-9]{8}`
#mailad2=`awk '!/[0-9]{8}/' ${mailad}`
# if [[ `echo $mailad | grep -v  [0-9]{8}` ]]; then
#    mailad2 = $mailad
# fi
#for item in ${mailad}; do
#if [[ $item != /[0-9]/ ]]; then
#   rm ${item}
#else
#   mailad2=${item}
# fi
#echo $item
#done
#printf "%s$mailad2"
