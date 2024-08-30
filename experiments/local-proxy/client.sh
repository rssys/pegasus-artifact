#!/bin/bash
HOST=$1
DIR=$2
mkdir -p $DIR
for N in {1..10}
do
	for R in {0..100..10}
	do
cat > script.lua << EOF
math.randomseed(0)
math.random(); math.random(); math.random()

request = function()
    if math.random() < $R/100 then
        return wrk.format("GET", "http://$HOST/test_file")
    else
        return wrk.format("GET", "http://$HOST/test_file2")
    end
end
EOF
		D=30
		./wrk -t 1 -c 50 -s script.lua -d $D -L http://$HOST | tee $DIR/$N-$R.txt
	done
done
