NodeNock - A Call-to-Get-In System Powered by Twilio and Foursquare
===================================================================

NodeNock is a web application that lets people inside a locked location receive
phone calls from people outside. Here's how it works:

One-Time Setup
--------------
* Users go through a one-time registration process by logging in with their 
Foursquare account and confirming their phone number.
* The phone number for NodeNock is posted outside.

Regular Use
-----------
* Users check in via [Foursquare](http://foursquare.com/) whenever they are
inside.
* Folks who are outside call the phone number and are connected to one of the
people who are checked in.

---

Deploying NodeNock
==================

NodeNock was built in a few afternoon sprints, and was intended for only one
deployment, at the [Baltimore Node](http://baltimorenode.org/). That being said,
customizing and deploying your own version of NodeNock is pretty simple via
[Heroku](http://heroku.com/).

Config Vars
-----------

* `FOURSQUARE_CONSUMER_KEY` - You'll need to register an app with Foursquare to
get this.
* `FOURSQUARE_CONSUMER_SECRET`
* `TWILIO_ACCOUNT_SID` - You'll need to register with 
[Twilio](http://twilio.org) to get this.
* `TWILIO_AUTH_TOKEN`
* `NODENOCK_PHONE` - You'll need to purchase an incoming phone number from
Twilio to get this.
* `NODENOCK_VENUE_ID` - The Foursquare ID for this venue. You can find it with
the [Foursquare API explorer](http://developer.foursquare.com/docs/explore.html)
* `NODENOCK_VENUE_USER_ID` - You'll need to create a new Foursquare account for
the location. Users will need to friend this account in order to be seen.
* `NODENOCK_VENUE_USER_TOKEN` - Use your location account in the explorer to get
this?
  * TODO: Make this easier. :)
* `NODENOCK_VENUE_USER_SECRET`
