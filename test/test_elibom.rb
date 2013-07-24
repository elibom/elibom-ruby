require 'test/unit'
require 'elibom'

class ElibomTest < Test::Unit::TestCase
  def test_elibom_client
    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    assert elibom.kind_of? Elibom::Client
  end

  def test_missing_user
    assert_raise ArgumentError do
      Elibom::Client.new(:api_password => 'test')
    end
  end

  def test_missing_api_password
    assert_raise ArgumentError do
      Elibom::Client.new(:user => 't@u.com')
    end
  end

  def test_send_message
    stub_request(:post, "http://t%40u.com:test@www.elibom.com/messages")
        .with(
          :body => "{\"destinations\":\"573002111111\",\"text\":\"this is a test\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
        .to_return(
          :status => 200, 
          :body => "{\"deliveryToken\": \"23345\"}", 
          :headers => {})

    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    response = elibom.send_message(:destinations => '573002111111', :text => 'this is a test')
    assert_equal response["deliveryToken"], "23345"
  end

  def test_send_message_missing_destinations
    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    assert_raise ArgumentError do
      response = elibom.send_message(:text => 'this is a test')
    end
  end

  def test_send_message_missing_text
    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    assert_raise ArgumentError do
      response = elibom.send_message(:destinations => '573002111111')
    end
  end
end