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
 obj3+=("$obj2")
done

#sanitize2
ptn='([0-9]{8})'
for obj4 in "${obj3[@]}"; do
 if [[ ! "${obj4[@]}" =~ $ptn ]]; then
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
  mlfile_stz=($(printf ""$mlfile | sed -e "s/^\/var\/qmail\/alias\///"))
  mlfile_lst+=("$mlfile_stz")
done

#copy-ml-file
for mailfile in "${mlfile_lst[@]}"; do
 cp -p /var/qmail/alias/$mailfile /backup/2016/$mailfile.$date.$var3
done

#mailing-list-delete
#diff
for mailfile in "${mlfile_lst[@]}"; do
 sed -i -e "/^$var2/d" /var/qmail/alias/$mailfile
 echo "diff /var/qmail/alias/$mailfile /backup/2016/$mailfile.$date.$var3"
 diff_rst=`diff /var/qmail/alias/$mailfile /backup/2016/$mailfile.$date.$var3`
 echo $diff_rst
done

#edit ezmlm
# /usr/local/bin/ezmlm/ezmlm-list /var/qmail/ezmlm/dooga-ml > dooga-ml.$date.$var3
#/usr/local/bin/ezmlm/ezmlm-unsub /var/qmail/ezmlm/dooga-ml $var2
#/usr/local/bin/ezmlm/ezmlm-list /var/qmail/ezmlm/dooga-ml > dooga-ml.$date.$var3_2
# echo "diff dooga-ml.$date.$var3 dooga-ml.$date.$var3_2"
# diff_mlrst=`diff dooga-ml.$date.$var3 dooga-ml.$date.$var3_2`
# echo $diff_mlrst

#delete user id
 /usr/sbin/rmuser $var1
 echo "id $var1"
 user_rst=`id $var1`
 echo $user_rst
