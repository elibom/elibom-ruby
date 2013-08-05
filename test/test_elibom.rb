require 'test/unit'
require 'elibom'

class ElibomTest < Test::Unit::TestCase
  HOST_WITH_CREDENTIALS = "https://t%40u.com:test@www.elibom.com"

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
    stub_request(:post, "#{HOST_WITH_CREDENTIALS}/messages")
        .with(
          :body => "{\"to\":\"573002111111\",\"text\":\"this is a test\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
        .to_return(
          :status => 200, 
          :body => "{\"deliveryToken\": \"23345\"}", 
          :headers => {})

    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    response = elibom.send_message(:to => '573002111111', :text => 'this is a test')
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

  def test_schedule_message
    stub_request(:post, "#{HOST_WITH_CREDENTIALS}/messages")
        .with(
          :body => "{\"to\":\"573002111111\",\"text\":\"this is a test\",\"scheduleDate\":\"2014-02-18 20:30\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
        .to_return(
          :status => 200, 
          :body => "{\"scheduleId\": \"23345\"}", 
          :headers => {})

    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    response = elibom.schedule_message(:to => '573002111111', :text => 'this is a test', :schedule_date => DateTime.parse('2014-02-18 20:30'))
    assert_equal response["scheduleId"], "23345"
  end

  def test_messages
    delivery = {
      "deliveryId"=>"12345",
      "status"=>"finished",
      "numSent"=>1,
      "numFailed"=>0,
      "messages"=>[{
        "id"=>171851,
        "user"=>{"id"=>2, "url"=>"https://www.elibom.com:9090/users/2"},
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

    stub_request(:get, "#{HOST_WITH_CREDENTIALS}/messages/12345")
        .with(
          :headers => {'Accept'=>'application/json'})
        .to_return(
          :status => 200,
          :body => delivery.to_json,
          :headers => {})

    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    response = elibom.messages('12345')
    assert_equal response, delivery
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

  def test_schedules
    schedules = [{
      "id" => 32,
      "user" => {
        "id" => 45,
        "url" => "https://www.elibom.com/users/45"
      },
      "scheduledTime" => "2014-05-23 10:23:00",
      "creationTime" => "2012-09-23 22:00:00",
      "status" => "scheduled",
      "isFile" => true,
      "fileName" => "test.xls",
      "fileHasText" => false,
      "text" => "Prueba"
    }]

    stub_request(:get, "#{HOST_WITH_CREDENTIALS}/schedules/scheduled")
        .with(
          :headers => {'Accept'=>'application/json'})
        .to_return(
          :status => 200,
          :body => schedules.to_json,
          :headers => {})

    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    response = elibom.schedules
    assert_equal response, schedules
  end

  def test_show_schedule
    schedule = {
      "id" => 32,
      "user" => {
        "id" => 45,
        "url" => "https://www.elibom.com/users/45"
      },
      "scheduledTime" => "2014-05-23 10:23:00",
      "creationTime" => "2012-09-23 22:00:00",
      "status" => "scheduled",
      "isFile" => true,
      "fileName" => "test.xls",
      "fileHasText" => false,
      "text" => "Prueba"
    }

    stub_request(:get, "#{HOST_WITH_CREDENTIALS}/schedules/32")
        .with(
          :headers => {'Accept'=>'application/json'})
        .to_return(
          :status => 200,
          :body => schedule.to_json,
          :headers => {})

    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    response = elibom.show_schedule(32)
    assert_equal response, schedule
  end

  def test_show_schedule_nil_id
    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    assert_raise ArgumentError do
      elibom.show_schedule(nil)
    end
  end

  def test_cancel_schedule
    stub_request(:delete, "#{HOST_WITH_CREDENTIALS}/schedules/32")
        .to_return(
          :status => 200,
          :body => "",
          :headers => {})

    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    elibom.unschedule(32)
  end

  def test_users
    users = [{
      "id" => "1",
      "name" => "Usuario 1",
      "email" => "usuario1@tudominio.com",
      "status" => "active" 
    }]

    stub_request(:get, "#{HOST_WITH_CREDENTIALS}/users")
        .with(
          :headers => {'Accept'=>'application/json'})
        .to_return(
          :status => 200,
          :body => users.to_json,
          :headers => {})

    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    response = elibom.users

    assert_equal response, users
  end

  def test_show_user
    user = {
      "id" => "1",
      "name" => "Usuario 1",
      "email" => "usuario1@tudominio.com",
      "status" => "active" 
    }

    stub_request(:get, "#{HOST_WITH_CREDENTIALS}/users/1")
        .with(
          :headers => {'Accept'=>'application/json'})
        .to_return(
          :status => 200,
          :body => user.to_json,
          :headers => {})

    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    response = elibom.show_user(1)

    assert_equal response, user
  end

  def test_show_user_nil_user_id
    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    assert_raise ArgumentError do
      elibom.user(nil)
    end
  end

  def test_show_account
    account = {
      "name" => "Nombre",
      "credits" => 10.0,
      "owner" => {
        "id" => 1,
        "url" => "https://www.elibom.com/users/1"
      }
    }

    stub_request(:get, "#{HOST_WITH_CREDENTIALS}/account")
        .with(
          :headers => {'Accept'=>'application/json'})
        .to_return(
          :status => 200,
          :body => account.to_json,
          :headers => {})

    elibom = Elibom::Client.new(:user => 't@u.com', :api_password => 'test')
    response = elibom.show_account

    assert_equal response, account
  end
end