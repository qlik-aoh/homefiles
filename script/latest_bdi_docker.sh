#!/usr/bin/env sh

aws ecr describe-images --repository-name bdiproduct --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]'

