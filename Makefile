#!/usr/bin/env bash

BUCKET_NAME="core.matrix.test"

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
	echo "\
	AWS_ACCESS_KEY_ID='$(AWS_ACCESS_KEY_ID)' \n\
	AWS_SECRET_ACCESS_KEY='$(AWS_SECRET_ACCESS_KEY)' \n\
	AWS_DEFAULT_REGION='$(AWS_DEFAULT_REGION)' \n\
	BUCKET_NAME='$(BUCKET_NAME)' \n" >user-data.tmp

	cat bootstrap.template >>user-data.tmp
	chmod 755 user-data.tmp
	aws ec2 run-instances \
	    --image-id ami-47a23a30 \
	    --count 1 \
	    --instance-type 't2.micro' \
	    --key-name 'toshi-key-pair' \
	    --instance-initiated-shutdown-behavior 'terminate' \
	    --user-data file://user-data.tmp
	rm user-data.tmp 

# Setups a bucket with the right permisions and stuff
# The bucket is not public by default, but you can easily change that in the s3 console
configure:
	./create_bucket $(BUCKET_NAME)
