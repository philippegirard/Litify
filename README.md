# README

Custom route loading in rails

No longer write routes for your application.

From now on, every controller action is loaded from the url.

Url are in the form of /controller/action

Example :

You have the following controller
```
class ProfileController < ApplicationController
  def index
  end
end
```

calling `/profile/index` will execute the controller method and render the index view.

You could also call `/Profile/` and by default it will load the index action. 

The module takes care of loading the right view. It will search this view in the `views/profile` folder.

However, if you render inside the controller, the module will detect it and will not render a second time.