defmodule ProjectR0719212Web.LayoutView do
  use ProjectR0719212Web, :view

  def new_locale(conn, locale, language_title) do
    "<a href=\"#{Routes.session_path(conn, :new, locale: locale)}\">#{language_title}</a>" |> raw
  end

end
