# Status Application
Requirements can be found [here](requirements.md)

A walk through of the approach taken can be followed through the commits and in this [document](approach.md)

The application can be found up and running at [http://jiggypete-status.herokuapp.com/](http://jiggypete-status.herokuapp.com/)🏃

#Setup
Start by cloning this repo:
`git clone git@github.com:JiggyPete/status.git`

Install all the dependencies:
`bundle install`

Create the database
`bundle exec rake db:create`

Migrate the database
`bundle exec rake db:migrate`

Run the tests:
`bundle exec rspec`

Start the server:
`bundle exec rails s`

Visit the site in your browser:
`http:/localhost:3000`


**Create a status message:**

`curl --data "state=UP&message=All systems are running." http://jiggypete-status.herokuapp.com/status.json`

**Update a status message:**

`curl -X PUT --data "id=28&state=DOWN&message=We are experiencing issues with the flux capacitor." http://jiggypete-status.herokuapp.com/status.json`

**Remember to edit the id value to be the id returned from the create request.**
