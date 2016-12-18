Hi Folks!

The idea here is to give you more of an insight into what was the thinking while implementing this solution.

- Create a github repo.
- Create a basic rails app.
- Pull in our favourite unit testing library.
- Deploy to heroku. (I appreciate the requirements says not to, the reason for doing this is it would be how I treat a production project.)
- Need to go through the requirements and potentially create a todo list.
- Investigate other status pages. ([Litmus](https://status.litmus.com/), [GitHub](https://status.github.com/))

- take it from there.


OK, first off, we need to get a page served up from rails and get all the pieces into the UI that are necessary.
My intention at this point is to hardcode status messages in the UI taking an outside-in approach.

Later as we go we'll move the status messages back into rails.


OK, we've now got all the necessary info for the view coming from the status_controller. At this point the controller is assigning @current_status and @previous_statuses. These are making use of a handy Struct prior to worrying about Active Record or migrations.


Next up we need to replace the Status Struct with an ActiveRecord model, StatusItem.
Interestingly Status is already a module in Rails and we can't use that name.

Now I'm going to try and finish up the front half of the logic for the application.
Being able to retrieve the most recent (current) StatusItem from the databse, and the previous 10.


Spotted a edgecase in the view. There was no code to handle the situation where the @current_status is nil.

Next we need to be able to curl and :create and :update a status item.
Example curl commands are available on the UI.

The last thing to do is validate the input that arrives in the controller from curl.
