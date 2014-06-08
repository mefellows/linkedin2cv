#!/bin/bash

find . -type f -iname '*linkedin2resume*' | grep -v '\.git' | xargs rename 's@linkedin2resume@linkedin2resume@gi' {}
find . -type d -iname '*linkedin2resume*' | grep -v '\.git' | xargs rename 's@linkedin2resume@linkedin2resume@gi' {}
find . -type f | grep -v '\.git' | xargs sed -i 's/linkedin2resume/linkedin2resume/g'
find . -type f | grep -v '\.git' | xargs sed -i 's/Linkedin2Resume/Linkedin2Resume/g'
