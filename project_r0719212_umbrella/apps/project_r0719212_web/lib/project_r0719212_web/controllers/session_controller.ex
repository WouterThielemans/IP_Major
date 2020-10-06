defmodule ProjectR0719212Web.SessionController do
    use ProjectR0719212Web, :controller
  
    alias ProjectR0719212Web.Guardian
    alias ProjectR0719212.UserContext
    alias ProjectR0719212.UserContext.User
  
    def new(conn, _) do
      changeset = UserContext.change_user(%User{})
      user = Guardian.Plug.current_resource(conn)
  
      if user do
        redirect(conn, to: "/home")
      else
        render(conn, "login.html", changeset: changeset, action: Routes.session_path(conn, :login))
      end
    end
  
    def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
      UserContext.authenticate(username, password)
      |> login_reply(conn)
    end
  
    def logout(conn, _) do
      conn
      |> Guardian.Plug.sign_out()
      |> redirect(to: "/login")
    end
  
    defp login_reply({:ok, user}, conn) do
      conn
      |> put_flash(:info, "Welcome back!")
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: "/home")
    end
  
    defp login_reply({:error, reason}, conn) do
      conn
      |> put_flash(:error, to_string(reason))
      |> new(%{})
    end

    def signup_page(conn, _)do
        changeset = UserContext.change_user_no_role(%User{})
        user = Guardian.Plug.current_resource(conn)
        if user do
          redirect(conn, to: "/home")
        else
          render(conn, "signup.html", changeset: changeset, action: Routes.session_path(conn, :signup))
        end
      end
  
      def signup(conn, %{"user" => user_params}) do
        case UserContext.create_user_no_role(user_params) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User created successfully.")
            |> redirect(to: "/login")
    
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "signup.html", changeset: changeset, action: Routes.session_path(conn, :signup))
        end
      end
  end