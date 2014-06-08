# Sinatra + Angular Seed

Get started hacking Sinatra and Angular on Heroku ASAP.

Out of the box, you get:

* Opinionated default setup of a Sinatra Web Application
* API with CORS, Sockets and JSON Support
* CLI Support
* Heroku configuration
* Unit Tests
* Standard Gem setup

# Getting started

## Pull down the seed and start the app

    git clone https://github.com/mefellows/sinatra-angular-seed.git
    cd sinatra-angular-cd
    echo 'PORT=8080' > .env && bundle install
    foreman start

Test that we're up:

    curl  "http://localhost:8080/status"

All going to plan, you should see ```alive``` indicating the app is running.

Setup the UI

    cd public
    npm install && bower install && grunt
    grunt serve
    
View your Web front end by visiting ```http://localhost:8080/``` in your favourite web browser.

You will want to change the name of files/folders from 'linkedin2resume' to the name of your app. If you have the 'rename' command, this is the quickest way forward (```brew install rename``` if you don't have it and are running Mac OSX). Create and run this little helper:

vi rename.sh

    #!/bin/bash
    
    find . -type f -iname '*linkedin2resume*' | grep -v '\.git' | xargs rename 's@haveaguess@<your app>@gi' {}
    find . -type d -iname '*linkedin2resume*' | grep -v '\.git' | xargs rename 's@haveaguess@<your app>@gi' {}
    find . -type f | grep -v '\.git' | xargs sed -i 's/linkedin2resume/<your app>/g'
    find . -type f | grep -v '\.git' | xargs sed -i 's/Linkedin2Resume/<your app in UpperCamelCase>/g'

Add execute perms

    chmod +x rename.sh
    ./rename.sh
    
Alternatively, you can change them manually yourself.

## Testing

    rake

## Deploying to Heroku

You will of course need to create an app in Heroku before deployment, a typical setup would look like:

    heroku app:create <my awesome app>
    heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
    heroku labs:enable websockets
    git push heroku master

## Logging

By default, we log to the stdout stream (as per Heroku's guide: ). If you'd like to change this behaviour, set the ```LOG_OUTPUT_FILENAME``` environment variable:


    $ bin/linkedin2resume  magic http://www.onegeek.com.au/
     INFO linkedin2resume.linkedin2resumecommand: Magic happens!
    $ export LOG_OUTPUT_FILENAME='linkedin2resume.log'
    $ bin/linkedin2resume  magic http://www.onegeek.com.au/
    $ cat linkedin2resume.log
     INFO linkedin2resume.linkedin2resumecommand: Magic happens!

# TODO

* Yeoman Generator: This might eventually turn into a Yeoman generator, meaning an interactive CLI will guide you through a setup instead of a static clone.
* Docker/Puppetize: For deployment to a non-Heroku environment, Puppet and Docker are popular alternatives.

# Acknowledgements

* Sinatra
* Eventmachine
* Foreman
* Angular
