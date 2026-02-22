The Pinboard Ruby Gem
=====================
A Ruby wrapper for the [Pinboard API](https://pinboard.in/api/).

[![CI](https://github.com/ryw/pinboard/actions/workflows/ci.yml/badge.svg)](https://github.com/ryw/pinboard/actions/workflows/ci.yml)

Installation
------------

`gem install pinboard`

Examples
--------

I'm currently exploring two API interfaces:

```ruby
pinboard = Pinboard::Client.new(:token => 'your_api_token')
posts = pinboard.posts
```

Your [API token](https://blog.pinboard.in/2012/07/api_authentication_tokens/) can be found on your
[settings/password](https://pinboard.in/settings/password) page.

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

`pinboard.posts(:meta => true) #include meta data in post models`

Ruby Support & Continuous Integration
-------------------------------------
Tested on Ruby 3.0, 3.1, 3.2, and 3.3 via GitHub Actions.

Links
-----

* [Pinboard API Documentation](https://pinboard.in/api/)

How to Contribute
-----------------
If you find what looks like a bug:

* Check the [GitHub issue tracker](https://github.com/ryw/pinboard/issues/)
  to see if anyone else has had the same issue.
* If you don't see anything, create an issue with information on how to reproduce it.

If you want to contribute an enhancement or a fix:

* Fork the [project on github](https://github.com/ryw/pinboard).
* Make your changes with specs.
* Commit the changes without messing with the Rakefile, VERSION, or history.
* Send me a pull request.

TODO
----

* Throttle requests to one per second:
  http://datagraph.rubyforge.org/rack-throttle/
* If get 503 response, double the throttle to two seconds

License
-------

See [MIT-LICENSE](MIT-LICENSE) for details.

Copyright (c) 2011-2026 Ryan Walker.
Copyright (c) 2013-2016 Jan-Erik Rediger.
