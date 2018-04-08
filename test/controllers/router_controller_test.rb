require 'test_helper'

class RouterControllerTest < ActionDispatch::IntegrationTest
  
  # path test

  test "#route controller is called" do
    assert_routing '/controller/action', controller: "router", action: "route", path: "controller/action"
  end

  test "#route handle empty path" do
    get '/'

    assert_response :success
    assert response.body.include?("Error : could not route http://www.example.com")
  end

  [:get, :post].each do |http_method|
    

    # controller and action parsing tests

    test "#{http_method}#route handles not existing controller" do
      send(http_method, '/notExisting')
      
      assert_response :success
      assert response.body.include?("Error : could not route http://www.example.com/notExisting")
    end

    test "#{http_method}#route handles not existing action on existing controller" do
      send(http_method, '/TestRoute/NotExistingAction')
      
      assert_response :success
      assert response.body.include?("Error : could not route http://www.example.com/TestRoute/NotExistingAction")
    end

    test "#{http_method}#route uses index method when not specified" do
      send(http_method, '/TestRoute')

      assert_response :success
      assert_match /index4646/, response.body
    end

    test "#{http_method}#route handles controller starting with lowercase" do
      send(http_method, '/testRoute/index')

      assert_response :success
      assert_match /index4646/, response.body
    end

    test "#{http_method}#route handles a camel case action" do
      send(http_method, '/TestRoute/LongMethodName')

      assert_response :success
      assert_match /long_method_name8786/, response.body
    end

    test "#{http_method}#route handles snake case action" do
      send(http_method, '/TestRoute/long_method_name')

      assert_response :success
      assert_match /long_method_name8786/, response.body
    end

    # Rendering tests

    test "#{http_method}#route does not render when the called controller renders explicitely" do
      send(http_method, '/TestRoute/explicit')

      assert_response :success
      assert_match /Explicit6859/, response.body
    end

    test "#{http_method}#route renders implicitely when the called controller does not render" do
      send(http_method, '/TestRoute/implicit')

      assert_response :success
      assert_match /Implicit3423/, response.body
    end
  end

  private

  def escape(str)
    /#{Regexp.escape(str)}/ 
  end
end
