#!/bin/bash
set -e

# Run this in your Hugo blog repo directory

# These are mine. They won't work for you :)
DISTRIBUTION_ID=E1J7ZV6LIKLO6N
BUCKET_NAME=youngandpowerful.sg
PROFILE=default # or `default` if you don't use profiles

hugo -v

# Empty bucket
# aws s3 rm s3://bucket-name --recursive
# Copy over pages
aws s3 sync --acl "public-read" --sse "AES256" public/ s3://$BUCKET_NAME/ --exclude '.git' --exclude '.gitattributes' --exclude '.DS_Store' --exclude 'CNAME'

# Ensure static files are set to cache forever - cache for a month --cache-control "max-age=2592000"
aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/img/ s3://${BUCKET_NAME}/img/
aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/css/ s3://${BUCKET_NAME}/css/
aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/js/ s3://${BUCKET_NAME}/js/

# Invalidate landing page so everything sees new post - warning, first 1K/mo free, then 1/2 cent each
aws cloudfront create-invalidation --profile ${PROFILE} --distribution-id ${DISTRIBUTION_ID} --paths /index.html /
