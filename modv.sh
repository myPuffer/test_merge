echo 'digraph {
rankdir=LR
node [shape=box];'

for x in $(go mod graph|sed "s/ /\n/g"|sort|uniq); do
	a=$(echo $x|sha1sum|cut -c1-6 )
	num=$((0x$a))
	echo  "$num [label=\"$x\"]"
done

for x in $(go mod graph|sed 's/ /^/g'); do
	# echo $x
	a=$((0x$(echo $x|cut -f1 -d '^'|sha1sum|cut -c1-6 )))
	b=$((0x$(echo $x|cut -f2 -d '^'|sha1sum|cut -c1-6 )))
	echo "$a -> $b"	
done

echo '}'
