#!/bin/bash

find . -type f -iname '*linkedin-to-resume*' | grep -v '\.git' | xargs rename 's@linkedin-to-resume@linkedin-to-resume@gi' {}
find . -type d -iname '*linkedin-to-resume*' | grep -v '\.git' | xargs rename 's@linkedin-to-resume@linkedin-to-resume@gi' {}
find . -type f | grep -v '\.git' | xargs sed -i 's/linkedin-to-resume/linkedin-to-resume/g'
find . -type f | grep -v '\.git' | xargs sed -i 's/LinkedinToResume/LinkedinToResume/g'
