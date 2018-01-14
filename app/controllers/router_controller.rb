class RouterController < ApplicationController
  def route
    halt "No path specified" and return unless path
    extract_route_from_path

    # instanciate the controller class if it exists. Otherwise, halt and return
    begin
      controller = Kernel.const_get(controller_class_base_name).new
      controller.request = request
      controller.response = response
    rescue NameError => e
      # puts "ERROR : " + e.message
      halt "Error in controller class name" and return
    end

    # execute the action on the controller if it exists. Otherwise, halt and return
    begin
      controller.send action_snake_name
    rescue NoMethodError => e
      # puts "ERROR : " + e.message
      halt "Error in the action name" and return
    end

    render template: template_path unless performed?
  end

  private

  def halt(msg = "")
    render body: "Error : could not route " + request.url + "\n" + msg
  end

  def extract_route_from_path
    @routes = path.split('/')
  end

  def controller_base_name
    routes(0)
  end

  def controller_base_snake_name
    controller_base_name.underscore
  end

  def controller_class_base_name
    controller_base_name.upcase_first + "Controller"
  end

  def controller_class_snake_name
    controller_class_camel_case.underscore
  end

  def action_base_name
    routes(1) || 'index'
  end

  def action_snake_name
    action_base_name.underscore
  end

  def path
    params.permit(:path)[:path]
  end

  def routes(n)
    @routes[n] if @routes
  end

  def template_path
    controller_base_snake_name + '/' + action_snake_name
  end
end
