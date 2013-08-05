Elibom Ruby API Client
===========

A ruby client of the Elibom REST API. [The full API reference is here](http://www.elibom.com/developers/reference).


## Getting Started

1\. Install the gem

```ruby
gem install elibom
```

2\. Create an `Elibom::Client` object passing your credentials.

```ruby
require 'elibom'

elibom = Elibom::Client.new(
  :user => 'your@user.com', 
  :api_password => 'your_api_password'
)
```
*Note*: You can find your api password at http://www.elibom.com/api-password (make sure you are logged in).

You are now ready to start calling the API methods!

## API methods

* [Send SMS](#send-sms)
* [Schedule SMS](#schedule-sms)
* [List SMS Messages](#list-sms-message)
* [List Scheduled SMS Messages](#list-scheduled-sms-messages)
* [Show Scheduled SMS Message](#show-scheduled-sms-message)
* [Cancel Scheduled SMS Message](#cancel-scheduled-sms-message)
* [List Users](#list-users)
* [Show User](#show-user)
* [Show Account](#show-account)

### Send SMS
```ruby
response = elibom.send_message(
  :to => '51965876567, 573002111111', 
  :text => 'this is a test'
)
puts response["deliveryToken"] # all methods return a hash (or nil if there is no response)
```

### Schedule SMS 
```ruby
response = elibom.schedule_message(
  :to => '51965876567, 573002111111', 
  :text => 'this is a test',
  :schedule_date => Time.now + 3600 # in an hour
)
puts response["scheduleId"]
```

### List SMS Messages
```ruby
response = elibom.messages('<delivery_token>')
puts response
```

### List Scheduled SMS Messages
```ruby
response = elibom.schedules
puts response
```

### Show Scheduled SMS Message
```ruby
response = elibom.schedule(<schedule_id>)
puts response
```

### Cancel Scheduled SMS Message
```ruby
elibom.unschedule(<schedule_id>)
```

### List Users
```ruby
response = elibom.users
puts response
```

### Show User
```ruby
response = elibom.user(<user_id>)
puts response
```

### Show Account
```ruby
response = elibom.account
puts response
```
