#!/usr/bin/env bash

ifndef AWS_ACCESS_KEY_ID
    $(error AWS_ACCESS_KEY_ID is not set)
endif

ifndef AWS_SECRET_ACCESS_KEY
    $(error AWS_SECRET_ACCESS_KEY is not set)
endif

ifndef AWS_DEFAULT_REGION
    $(error AWS_DEFAULT_REGION is not set)
endif

all:
	echo "#!/usr/bin/env bash \nAWS_ACCESS_KEY_ID='$$AWS_ACCESS_KEY_ID' \nAWS_SECRET_ACCESS_KEY='$$AWS_SECRET_ACCESS_KEY' \nAWS_DEFAULT_REGION='$$AWS_DEFAULT_REGION' \n" \
	    >user-data.tmp
	cat bootstrap.template >>user-data.tmp
	chmod 755 user-data.tmp
	aws ec2 run-instances \
	    --image-id ami-47a23a30 \
	    --count 1 \
	    --instance-type 't2.micro' \
	    --key-name 'toshi-key-pair' \
	    --instance-initiated-shutdown-behavior 'terminate'
	    # --user-data $(cat user-data.tmp | base64)
	# rm user-data.tmp 

