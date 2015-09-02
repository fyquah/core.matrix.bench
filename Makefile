#!/usr/bin/env bash

SHELL := /bin/bash
.DEFAULT_GOAL := run

ifndef BUCKET_NAME
    BUCKET_NAME=core.matrix.bench
endif

ifndef AWS_ACCESS_KEY_ID
    $(error AWS_ACCESS_KEY_ID is not set)
endif

ifndef AWS_SECRET_ACCESS_KEY
    $(error AWS_SECRET_ACCESS_KEY is not set)
endif

ifndef AWS_DEFAULT_REGION
    $(error AWS_DEFAULT_REGION is not set)
endif

# *********************
# Tasks
# *********************

# Setups a bucket with the right permisions and stuff
# The bucket is not public by default, but you can easily change that in the s3 console
configure: bucket.txt instance_type.txt key_pair.txt

run: bucket.txt instance_type.txt key_pair.txt
	printf "\
	#!/bin/bash \n\
	AWS_ACCESS_KEY_ID='$(AWS_ACCESS_KEY_ID)' \n\
	AWS_SECRET_ACCESS_KEY='$(AWS_SECRET_ACCESS_KEY)' \n\
	AWS_DEFAULT_REGION='$(AWS_DEFAULT_REGION)' \n\
	BUCKET_NAME='`cat $<`' \n" >user-data.tmp

	cat bootstrap.template >>user-data.tmp
	chmod 755 user-data.tmp
	aws ec2 run-instances \
	    --image-id ami-47a23a30 \
	    --count 1 \
	    --instance-type $$(cat $(word 2, $^)) \
	    $$(KEY_NAME=`cat $(word 3, $^)`; \
		if [[ -n "$$INSTANCE_TYPE" ]]; then \
		    echo -n "--key-name $$KEY_NAME"; \
		fi \
	    ) \
	    --instance-initiated-shutdown-behavior 'terminate' \
	    --user-data file://user-data.tmp
	rm user-data.tmp

clean:
	rm -rf bucket.txt instance_type.txt key_pair.txt

# *********************
# File / Configurations Dependencies
# *********************

bucket.txt:
	./create_bucket $(BUCKET_NAME)
	echo -n '$(BUCKET_NAME)' >$@

instance_type.txt:
	./configure_instance_type $@

key_pair.txt:
	./configure_key_pair $@

