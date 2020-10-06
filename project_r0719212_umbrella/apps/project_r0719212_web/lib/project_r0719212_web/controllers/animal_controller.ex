defmodule ProjectR0719212Web.AnimalController do
  use ProjectR0719212Web, :controller

  alias ProjectR0719212.AnimalContext
  alias ProjectR0719212.AnimalContext.Animal
  alias ProjectR0719212.UserContext

  action_fallback ProjectR0719212Web.FallbackController
#HTML
  def load_animals(conn,%{}) do
    user = Guardian.Plug.current_resource(conn)
    user_with_animals = AnimalContext.load_animals(user)

    render(conn, "index.html", animals: user_with_animals.animals)
  end
#JSON Postman
  def index(conn, %{"user_id" => user_id}) do
    user = UserContext.get_user!(user_id)
    user_with_animals = AnimalContext.load_animals(user)

    render(conn, "index.json", animals: user_with_animals.animals)
  end

  def create(conn, %{"user_id" => user_id, "animal" => animal_params}) do
    user = UserContext.get_user!(user_id)

    case AnimalContext.create_animal(animal_params, user) do
      {:ok, %Animal{} = animal} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_animal_path(conn, :show, user_id, animal))
        |> render("show.json", animal: animal)
    
      {:error, _cs} ->
        conn
        |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")  
    end
  end

  def delete(conn, %{"id" => id}) do
    animal = AnimalContext.get_animal!(id)

    with {:ok, %Animal{}} <- AnimalContext.delete_animal(animal) do
      send_resp(conn, :no_content, "")
    end
  end

  def show(conn, %{"id" => id}) do
    animal = AnimalContext.get_animal!(id)
    render(conn, "show.json", animal: animal)
  end

  def update(conn, %{"id" => id, "animal" => animal_params}) do
    animal = AnimalContext.get_animal!(id)

    case AnimalContext.update_animal(animal, animal_params) do
      {:ok, %Animal{} = animal} ->
        render(conn, "show.json", animal: animal)

      {:error, _cs} ->
        conn
        |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
    end
  end
end