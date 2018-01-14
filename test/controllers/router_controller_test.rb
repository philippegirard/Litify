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

  # controller and action parsing tests

  test "#route handles not existing controller" do
    get '/notExisting'
    
    assert_response :success
    assert response.body.include?("Error : could not route http://www.example.com/notExisting")
  end

  test "#route handles not existing action on existing controller" do
    get '/TestRoute/NotExistingAction'
    
    assert_response :success
    assert response.body.include?("Error : could not route http://www.example.com/TestRoute/NotExistingAction")
  end

  test "#route uses index method when not specified" do
    get '/TestRoute'

    assert_response :success
    assert_match /index4646/, response.body
  end

  test "#route handles controller starting with lowercase" do
    get '/testRoute/index'

    assert_response :success
    assert_match /index4646/, response.body
  end

  test "#route handles a camel case action" do
    get '/TestRoute/LongMethodName'

    assert_response :success
    assert_match /long_method_name8786/, response.body
  end

  test "#route handles snake case action" do
    get '/TestRoute/long_method_name'

    assert_response :success
    assert_match /long_method_name8786/, response.body
  end

  # Rendering tests

  test "#route does not render when the called controller renders explicitely" do
    get '/TestRoute/explicit'

    assert_response :success
    assert_match /Explicit6859/, response.body
  end

  test "#route renders implicitely when the called controller does not render" do
    get '/TestRoute/implicit'

    assert_response :success
    assert_match /Implicit3423/, response.body
  end

  private

  def escape(str)
    /#{Regexp.escape(str)}/ 
  end
end
