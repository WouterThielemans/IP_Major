defmodule ProjectR0719212Web.AnimalView do
  use ProjectR0719212Web, :view
  alias ProjectR0719212Web.AnimalView

  def render("index.json", %{animals: animals}) do
    %{data: render_many(animals, AnimalView, "animal.json")}
  end

  def render("show.json", %{animal: animal}) do
    %{data: render_one(animal, AnimalView, "animal_one.json")}
  end

  def render("animal.json", %{animal: animal}) do
    %{id: animal.id,
      name: animal.name,
      dob: animal.dob,
      cat_or_dog: animal.cat_or_dog}
  end
end

defmodule ProjectR0719212Web.AnimalView do
  use ProjectR0719212Web, :view
  alias ProjectR0719212Web.AnimalView

  def render("index.json", %{animals: animals}) do
    %{data: render_many(animals, AnimalView, "animal_many.json")}
  end

  def render("show.json", %{animal: animal}) do
    %{data: render_one(animal, AnimalView, "animal_one.json")}
  end

  def render("animal_one.json", %{animal: animal}) do
    %{id: animal.id,
    name: animal.name,
    dob: animal.dob,
    cat_or_dog: animal.cat_or_dog}
  end

  def render("animal_many.json", %{animal: animal}) do
    %{id: animal.id,
    name: animal.name}
  end
end

