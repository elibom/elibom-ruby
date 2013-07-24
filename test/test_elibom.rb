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

  def test_messages
    delivery = {
      "deliveryId"=>"12345",
      "status"=>"finished",
      "numSent"=>1,
      "numFailed"=>0,
      "messages"=>[{
        "id"=>171851,
        "user"=>{"id"=>2, "url"=>"http://localhost:9090/users/2"},
        "to"=>"573002175604",
        "operator"=>"Tigo (Colombia)",
        "text"=>"this is a test",
        "status"=>"sent",
        "statusDetail"=>"sent",
        "credits"=>1,
        "from"=>"3542",
        "createdAt"=>"2013-07-24 15:05:34",
        "sentAt"=>"2013-07-24 15:05:34"}]
    }

    stub_request(:get, "http://t%40u.com:test@www.elibom.com/messages/12345")
        .with(
          :headers => {'Accept'=>'application/json'})
        .to_return(
          :status => 200,
          :body => delivery.to_json,
          :headers => {})

    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    response = elibom.messages('12345')
    assert_equal response["deliveryId"], "12345"
    assert_equal response["status"], "finished"
    assert_equal response["numSent"], 1
    assert_equal response["numFailed"], 0
    assert_equal response["messages"].length, 1

    message = response["messages"][0]
    assert_equal message["id"], 171851
    assert_equal message["user"]["id"], 2
    assert_equal message["operator"], "Tigo (Colombia)"
    assert_equal message["text"], "this is a test"
    assert_equal message["status"], "sent"
    assert_equal message["statusDetail"], "sent"
    assert_equal message["credits"], 1
    assert_equal message["from"], "3542"
    assert_equal message["createdAt"], "2013-07-24 15:05:34"
    assert_equal message["sentAt"], "2013-07-24 15:05:34"
  end

  def test_messages_nil_delivery_id
    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    assert_raise ArgumentError do
      elibom.messages(nil)
    end
  end

  def test_messages_empty_delivery_id
    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    assert_raise ArgumentError do
      elibom.messages('')
    end
  end

  # TODO - tests for user and account
end