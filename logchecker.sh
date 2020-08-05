#!/usr/bin/zsh

gitlogs=$(git log --stat|head -n 1000)

LineLog=$(echo $gitlogs|grep -Pzoa 'commit [a-z0-9]+(\n)Merge: [a-z0-9]+ [a-z0-9]+'|awk '{if(NR%2!=0)ORS=" ";else ORS="\n"}1')

let n=1
array=(${(s:commit :)LineLog})


logList=""
for i in $array; do
	result=$(echo $i|cut -f1 -d ' ' )
	p1=$(echo $i|cut -f3 -d ' ' ) 
	p2=$(echo $i|cut -f4 -d ' ' )
	logList="$logList\n\n----------------------\n==>($n)\n\n\
	$(git log -1 --stat $result)\n\
>>>>DIFF $p1\n\n \
	$(git diff --compact-summary $p1 $result)\n\n \
>>>>DIFF $p2\n\n \
	$(git diff --compact-summary $p2 $result)\n\n \

	"
	let n+=1
done


opt=''

while ; do
	echo "1. 查看日志"
	echo "2. 查看指定提交的更改"
	echo "q. 退出"
	echo "输入数字选项或者q退出 :"
	read opt

	if [[ $opt -eq 'q' ]] ; then
		break
	fi

	if  [[ $opt -eq '1' ]] ; then
		echo $logList|less
	fi

	if  [[ $opt -eq '2' ]] ; then
		echo "选择提交的id："
		read idx
		echo "idx = $idx"
		record=$array[$idx]

		result=$(echo $record|cut -f1 -d ' ' ) 
		p1=$(echo $record|cut -f3 -d ' ' ) 
		p2=$(echo $record|cut -f4 -d ' ' ) 


		while ; do			
			git log --stat -1 $result
			echo "\n\n"
			echo "1. diff $p1"
			echo "2. diff $p2"
			echo "q. quit"
			echo "输入数字选项或者q退出 :"
			read opt
			if [[ opt -eq '1' ]] ; then
				git diff $p1 $result
			elif [[ opt -eq '2' ]]; then
				git diff $p2 $result
			elif [[ opt -eq 'q' ]]; then
				break
			fi
		done
	fi	
done