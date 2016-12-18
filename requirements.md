Write a Ruby on Rails application that informs customers of whether Litmus is up
or down along with a number of time stamped status messages.

The status and new messages will be updated from the command line using cURL, don't worry about authentication or design of the status page, but do pay attention to the structure of the status page.

There is no requirement to deploy the application beyond running it locally.

The final deliverable:
- Should have a single web page showing the current status and a history of the last 10 status messages with their timestamp.
- Should offer an API to manually update the status message and the current status.
- Should support ONLY 2 possible status options: “UP” or “DOWN”.
- Should allow updating of a status message without changing the status.
- Should allow changing of the status without leaving a status message.
- Should NOT actually monitor anything, the status will only be updated manually via cURL.
- Should be suitably tested.

You may ask as many questions as you like to clarify any of the points above.
