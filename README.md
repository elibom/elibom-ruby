Elibom Ruby API Client
===========

A ruby client of the Elibom REST API. [The full API documentation is here](http://www.elibom.com/developers/reference).


## Getting Started

1\. Install the gem

```ruby
gem install elibom
```

2\. Create an Elibom client object passing your credentials.

```ruby
elibom = Elibom::Client.new(
  :user => 'your@user.com', 
  :api_password => 'your_api_password'
)
```
*Note*: You can find your api password at http://www.elibom.com/api-password (make sure you are logged in).

You are now ready to start calling the API methods!

## API methods

### Send a message

```ruby
response = elibom.send_message(
  :destinations => '51965876567, 573002111111', 
  :text => 'this is a test'
)
puts response["deliveryToken"]
```

### Query messages

```ruby
response = elibom.messages('<delivery_token>')
puts response
```

### Query your account

```ruby
response = elibom.account
puts response
```
