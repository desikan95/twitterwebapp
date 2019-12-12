defmodule TwitterwebappWeb.RegistrationChannel do
  use TwitterwebappWeb, :channel
  alias TwitterwebappWeb.Router.Helpers, as: Routes

  def join("room:registrations", _params, socket) do
  #  {:ok, %{channel: channel_name}, socket}
     {:ok,socket}
  end

  def join("room:" <> _username, _params, socket) do
  #  {:ok, %{channel: channel_name}, socket}
     {:ok,socket}
  end

  def handle_in("user:add", %{"message" => content}, socket) do
    IO.puts "Content is"
    IO.inspect content

    TwitterEngine.start_link(1)
    ClientSupervisor.simulate(50,10)


    response1 = TwitterwebappWeb.UserView.render("landingpage.html", %{content: content})
    response = Phoenix.View.render_to_string(TwitterwebappWeb.UserView,"landingpage.html", %{content: content})
    #response = TwitterwebappWeb.UserView.render( "sample.json", %{name: :desi})
    IO.puts "Response"
    IO.inspect response
    broadcast!(socket, "room:registrations:new_user", %{html: response,content: content})
    push(socket,"render_response", %{html: response, content: content})
#    response = socket
#               |>
#               Phoenix.View.render_one(TwitterwebappWeb.UserView, "sample.json", name: :desikan)

  #  socket
  #  |> Phoenix.Controller.redirect(to: Routes.user_path(TwitterwebappWeb, TwitterwebappWeb.UserView, content) )
  #  html = Phoenix.LiveView.render(TwitterwebappWeb.UserView,"landingpage.html",content)
  #  IO.puts "Landing page is"
  #  IO.inspect html
    {:reply, {:ok,%{}}, socket}
  end

  def handle_in("simulation",msg, socket) do
    IO.puts "Response value from genserver is"
    IO.inspect msg
    IO.puts "Done"

  #  response = Phoenix.View.render_to_string(TwitterwebappWeb.UserView,"landingpage.html", %{content: :random})
  #  push(socket,"render_response", %{html: response, content: msg})

    {:noreply, socket}
  end
end
