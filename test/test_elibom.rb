require 'test/unit'
require 'elibom'

class ElibomTest < Test::Unit::TestCase

  def teardown
    Elibom.reset!
  end

  def test_respond_to_client_methods
    Elibom.configure(:user => 't@u.com', :api_password => 'pass')
    assert_respond_to(Elibom, :send_message)
  end

  def test_delegate_to_client
    stub_request(:post, "#{HOST_WITH_CREDENTIALS}/messages")
        .with(
          :body => "{\"to\":\"573002111111\",\"text\":\"this is a test\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
        .to_return(
          :status => 200, 
          :body => "{\"deliveryToken\": \"23345\"}", 
          :headers => {})

    Elibom.configure(:user => 't@u.com', :api_password => 'test')
    response = Elibom.send_message(:to => '573002111111', :text => 'this is a test')
    assert_equal response["deliveryToken"], "23345"
  end
  
  def test_fail_if_not_configured
    assert_raise RuntimeError do
      Elibom.account
    end
  end

end