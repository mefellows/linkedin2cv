#!/bin/bash

find . -type f -iname '*linkedin2cv *' | grep -v '\.git' | xargs rename 's@linkedin2cv @linkedin2cv @gi' {}
find . -type d -iname '*linkedin2cv *' | grep -v '\.git' | xargs rename 's@linkedin2cv @linkedin2cv @gi' {}
find . -type f | grep -v '\.git' | xargs sed -i 's/linkedin2cv /linkedin2cv /g'
find . -type f | grep -v '\.git' | xargs sed -i 's/Linkedin2Resume/Linkedin2Resume/g'
