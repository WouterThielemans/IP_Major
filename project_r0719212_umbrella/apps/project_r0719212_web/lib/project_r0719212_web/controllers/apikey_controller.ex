defmodule ProjectR0719212Web.ApiKeyController do
    use ProjectR0719212Web, :controller
  
    alias ProjectR0719212Web.Guardian
    alias ProjectR0719212.ApiKeyContext
    alias ProjectR0719212.ApiKeyContext.ApiKey

    def list_keys(conn, %{}) do
        user = Guardian.Plug.current_resource(conn)
        if user do
            user_with_keys = ApiKeyContext.load_api_keys(user)
            user_with_keys.apikeys
        end
    end
  
    def new(conn, %{"name" => name}) do
        user = Guardian.Plug.current_resource(conn)
        api_key = Phoenix.Token.sign(ProjectR0719212Web.Endpoint, "salt", user.id)

        case ApiKeyContext.create_api_key(%{name: name, api_key: api_key}, user) do
            {:ok, _key} -> 
              conn
              |> put_status(:created)
              |> redirect(to: Routes.user_path(conn, :show))
          
            {:error, _cs} ->
              conn
              |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")  
          end
    end

    

end