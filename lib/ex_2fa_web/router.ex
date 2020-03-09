defmodule Ex2faWeb.Router do
  use Ex2faWeb, :router

  import Ex2faWeb.Plugs.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug(Ex2faWeb.Plugs.Auth)
  end

  pipeline :two_factor_auth do
    plug :check_two_factor_auth
  end

  scope "/login", Ex2faWeb do
    pipe_through(:browser)

    get("/", AuthController, :new)
    post("/", AuthController, :create)
  end

  scope "/two_factor_authentication", Ex2faWeb do
    pipe_through([:browser, :two_factor_auth])

    get("/", TwoFactorAuthController, :ask)
    post("/", TwoFactorAuthController, :check)
  end

  scope "/", Ex2faWeb do
    pipe_through([:browser, :auth])

    get("/", PageController, :index)
    get("/logout", AuthController, :logout)

    scope "/two_factor_authentication" do
      get("/new", TwoFactorAuthController, :new)
      post("/create", TwoFactorAuthController, :create)
    end
  end
end
