defmodule ProjectR0719212Web.ProfileController do
    use ProjectR0719212Web, :controller
  
      alias ProjectR0719212.ApiKeyContext
      alias ProjectR0719212.ApiKeyContext.ApiKey
      alias ProjectR0719212.UserContext
      alias ProjectR0719212.UserContext.User
      alias ProjectR0719212Web.Guardian
  
      def show_user_profile(conn, _) do
        user = Guardian.Plug.current_resource(conn)
        load = ApiKeyContext.load_api_keys(user)
        changeset = ApiKeyContext.change_api_key(%ApiKey{})
        render(conn, "profile.html", user: user, apikeys: load.apikeys, changeset: changeset)
      end

      def showkey(conn, %{"id" => id}) do
        user = Guardian.Plug.current_resource(conn)
        api_key = 
        case ApiKeyContext.key_mathcing_with_user!(id, user) do
        {:ok, api_key} ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.send_resp(200, api_key.key)

        {:unauthorized} ->
        conn
        |> put_flash(:error, gettext("Unauthorized access"))
        |> redirect(to: Routes.profile_path(conn, :show_user_profile))
        end
    end
  
      def change_user(conn, _params) do
          user = Guardian.Plug.current_resource(conn)
          changeset = UserContext.change_user(user)
          render(conn, "changeusername.html", user: user, changeset: changeset, action: Routes.profile_path(conn, :change_user_post))
      end
  
      def change_user_post(conn, %{"user" => user_params}) do
          user = Guardian.Plug.current_resource(conn)
          case UserContext.update_user_username(user, user_params) do
              {:ok, user} ->
              conn
                  |> put_flash(:info, gettext("Username changed successfully."))
                  |> redirect(to: Routes.profile_path(conn, :show_user_profile))
  
              {:error, %Ecto.Changeset{} = changeset} ->
                  render(conn, "changeusername.html", user: user, changeset: changeset, action: Routes.profile_path(conn, :change_user_post))
          end
      end
  
      def change_password(conn, _params) do
          user = Guardian.Plug.current_resource(conn)
          changeset = UserContext.change_user(user)
          render(conn, "resetpassword.html", user: user, changeset: changeset, action: Routes.profile_path(conn, :change_password_post))
      end
  
      def change_password_post(conn, %{"user" => user_params}) do
          user = Guardian.Plug.current_resource(conn)
          case UserContext.update_user_password(user, user_params) do
              {:ok, user} ->
              conn
                  |> put_flash(:info, gettext("Password changed successfully."))
                  |> redirect(to: Routes.profile_path(conn, :show_user_profile))
  
              {:error, %Ecto.Changeset{} = changeset} ->
                  render(conn, "resetpassword.html", user: user, changeset: changeset, action: Routes.profile_path(conn, :change_password_post))
          end
      end
  
      def update_password(conn, %{"user" => user_params}) do
        user = Guardian.Plug.current_resource(conn)
        case UserContext.update_password(user, user_params) do
            {:ok, user}->
            conn
                |> put_flash(:info, gettext("Password updated successfully."))
                |> redirect(to: Routes.user_path(conn, :show_user_profile))

            {:error, %Ecto.Changeset{} = changeset, error_msg} ->
                render(conn, "change_password.html", user: user, changeset: changeset, error_msg: error_msg)
          end
      end

      def create_api_key(conn, %{"api_key" => api_key_params}) do
        user = Guardian.Plug.current_resource(conn)
        case ApiKeyContext.create_api_key(api_key_params, user) do
            {:ok, %ApiKey{} = api_key }  ->
            conn
                |> put_flash(:info, gettext("Key created succesfully"))
                |> redirect(to: Routes.profile_path(conn, :show_user_profile))

            {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "profile.html", changeset: changeset, user: user)
            end
        end        
    
        def deletekey(conn, %{"id" => id}) do
            user = Guardian.Plug.current_resource(conn)
            api_key = ApiKeyContext.get_api_key!(id,user)
    
            case ApiKeyContext.delete_api_key(api_key,user) do
            {:ok, _api_key} -> 
            conn
            |> put_flash(:info, "Key deleted successfully.")
            |> redirect(to: Routes.profile_path(conn, :show_user_profile))
    
            {:unauthorized} ->
            conn
            |> put_flash(:error, "You can only delete your own keys.")
            |> redirect(to: Routes.profile_path(conn, :show_user_profile))
            end
    end   
end
  