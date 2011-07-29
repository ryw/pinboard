The Pinboard Ruby Gem
=====================
A Ruby wrapper for the [Pinboard API](http://pinboard.in/api/).

Installation
------------
    gem install pinboard

Continuous Integration
----------------------
[![Build Status](https://secure.travis-ci.org/ryw/pinboard.png)](http://travis-ci.org/ryw/pinboard)

TODO
----

* Implement posts/update and posts/all
* Throttle requests to one per second:
  http://datagraph.rubyforge.org/rack-throttle/
* If get 503 response, double the throttle to two seconds
