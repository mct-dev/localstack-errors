aws lambda invoke --endpoint http://localhost:4566 \
--function-name arn:aws:lambda:us-west-1:000000000000:function:test \
--payload `echo '{"test": "thing"}' | base64` \
outfile.txt

cat outfile.txt|jq