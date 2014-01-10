The Pinboard Ruby Gem
=====================
A Ruby wrapper for the [Pinboard API](http://pinboard.in/api/).

Installation
------------
    gem install pinboard

Examples
--------

I'm currently exploring two API interfaces:

```ruby
    pinboard = Pinboard::Client.new(:username => 'foo', :password => 'bar')
    posts = pinboard.posts
```
or:

```ruby
    posts = Pinboard::Post.all(:username => 'foo', :password => 'bar')
```
Both examples work.

Passing arguments: (works only for the Client API Interface)

```ruby
	pinboard.posts(:tag => 'ruby') #all posts tagged 'ruby'
	pinboard.posts(:tag => 'ruby,pinboard') #all posts tagged 'ruby' and 'pinboard'
    pinboard.posts(:start => 20) #starting on the 20th post
    pinboard.posts(:results => 20) #return only first 20 matching posts
    pinboard.posts(:fromdt => 4.days.ago) #all posts in past 4 days
    pinboard.posts(:todt => 4.days.ago) #all posts up to 4 days ago
```

Adding new posts:

```ruby
  pinboard.add(:url => "http://example.com/", :description => 'Example post')
```


Future Examples (I don't need them, so I haven't written them)
--------------------------------------------------------------

    pinboard.posts(:meta => true) #include meta data in post models

Ruby Support & Continuous Integration
-------------------------------------
I am using [travis-ci.org](http://travis-ci.org) for continuous
integration and support of the following rubies in rvm:

 * 1.9.3
 * 2.0.0
 * jruby
 * ruby-head

[![Build Status](https://secure.travis-ci.org/ryw/pinboard.png)](http://travis-ci.org/ryw/pinboard)

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/ryw/pinboard)

Links
-----
  * [Pinboard API Documentation](http://pinboard.in/api/)

How to Contribute
-----------------
If you find what looks like a bug:

  * Check the [GitHub issue tracker](http://github.com/ryw/pinboard/issues/)
    to see if anyone else has had the same issue.
  * If you don’t see anything, create an issue with information on how to reproduce it.

If you want to contribute an enhancement or a fix:

  * Fork the [project on github](http://github.com/ryw/pinboard).
  * Make your changes with specs.
  * Commit the changes without messing with the Rakefile, VERSION, or history.
  * Send me a pull request.

TODO
----

* Throttle requests to one per second:
  http://datagraph.rubyforge.org/rack-throttle/
* If get 503 response, double the throttle to two seconds

Copyright
---------
Copyright (c) 2011 Ryan Walker. See MIT-LICENSE for details.
Copyright (c) 2013-2014 Jan-Erik Rediger.
