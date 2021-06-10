defmodule ElixirSearchExtractorWeb.Router do
  use ElixirSearchExtractorWeb, :router

  import ElixirSearchExtractorWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  # coveralls-ignore-start
  pipeline :api do
    plug :accepts, ["json"]
  end

  # coveralls-ignore-stop

  # Other scopes may use custom stacks.
  # scope "/api", ElixirSearchExtractorWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      # coveralls-ignore-start
      live_dashboard "/dashboard", metrics: ElixirSearchExtractorWeb.Telemetry
      # coveralls-ignore-stop
    end
  end

  ## Authentication routes

  scope "/", ElixirSearchExtractorWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", PageController, :index
    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
  end

  scope "/", ElixirSearchExtractorWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
  end

  scope "/", ElixirSearchExtractorWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
  end
end
