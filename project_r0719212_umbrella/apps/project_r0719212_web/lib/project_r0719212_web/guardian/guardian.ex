defmodule ProjectR0719212Web.Guardian do
    use Guardian, otp_app: :project_r0719212_web
  
    alias ProjectR0719212.UserContext
    alias ProjectR0719212.UserContext.User
  
    def subject_for_token(user, _claims) do
      {:ok, to_string(user.id)}
    end
  
    def resource_from_claims(%{"sub" => id}) do
      case UserContext.get_user(id) do
        %User{} = u -> {:ok, u}
        nil -> {:error, :resource_not_found}
      end
    end
  end