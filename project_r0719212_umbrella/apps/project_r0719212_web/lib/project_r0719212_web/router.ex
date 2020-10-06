defmodule ProjectR0719212Web.Router do
  use ProjectR0719212Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ProjectR0719212Web.Plugs.Locale
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug ProjectR0719212Web.Plugs.Plug
  end

  pipeline :allowed_for_users do
    plug ProjectR0719212Web.Plugs.AuthorizationPlug, ["Admin", "User"]
  end
  
  pipeline :allowed_for_admins do
    plug ProjectR0719212Web.Plugs.AuthorizationPlug, ["Admin"]
  end

  pipeline :project_r0719212 do
    plug ProjectR0719212Web.Pipeline
  end

  scope "/admin", ProjectR0719212Web do
    pipe_through [:browser, :project_r0719212, :ensure_auth, :allowed_for_admins]

   resources "/users", UserController
    get "/", UserController, :index
    get "/apikeys/overview", UserController, :getKeys
  end  

  scope "/api", ProjectR0719212Web do
    pipe_through :api
    resources "/users", UserController, only: [] do
    resources "/animals", AnimalController
  end
end

  scope "/", ProjectR0719212Web do
    pipe_through [:browser, :project_r0719212]

    get "/", SessionController, :new
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/signup_page", SessionController, :signup_page
    post "/signup", SessionController, :signup
  end

  scope "/", ProjectR0719212Web do
    pipe_through [:browser, :project_r0719212, :ensure_auth, :allowed_for_users]
    get "/home", AnimalController, :load_animals
    #profile nest
    get "/profile", ProfileController, :show_user_profile
    get "/changeusername", ProfileController, :change_user
    post "/changeusername", ProfileController, :change_user_post
    put "/changeusername", ProfileController, :change_user_post
    get "/resetpassword", ProfileController, :change_password
    post "/resetpassword", ProfileController, :change_password_post
    put "/resetpassword", ProfileController, :change_password_post
    get "/showkey/:id", ProfileController, :showkey
    delete "/deletekey/:id", ProfileController, :deletekey
    post "/createkey", ProfileController, :create_api_key

    post "/:id", ApiKeyController, :new 
    get "/logout", SessionController, :logout
  end
end