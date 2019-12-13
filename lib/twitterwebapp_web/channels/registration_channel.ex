defmodule TwitterwebappWeb.RegistrationChannel do
  use TwitterwebappWeb, :channel
  alias TwitterwebappWeb.Router.Helpers, as: Routes

  def join("room:registrations", _params, socket) do
  #  {:ok, %{channel: channel_name}, socket}

     {:ok,socket}
  end

  def join("room:simulate",_params,socket) do
    {:ok,socket}


     {:ok,socket}

  end

  def join("room:" <> _username, _params, socket) do
  #  {:ok, %{channel: channel_name}, socket}
     {:ok,socket}
  end


  def handle_in("post_tweet",mapresult, socket) do
    IO.puts "Called Here"
    IO.inspect mapresult
    {username,_} = Integer.parse(Map.get(mapresult,"username"))

    IO.puts " Username is "
    IO.inspect username

    msg = Map.get(mapresult,"tweet_msg")
    IO.puts "Message to be posted is"
    IO.inspect msg

    {:ok,clientpid} = Client.start_link(username)
    IO.puts "Pid is"
    IO.inspect clientpid
    Client.addNewTweetForWebClient(clientpid,msg)
    #TwitterEngine.storeTweet(5,msg)

    {:noreply,socket}
  end

  def handle_in("get_tweet",mapresult, socket) do
    IO.puts "Called Here inside get tweets"
    IO.inspect mapresult
    {username,_} = Integer.parse(Map.get(mapresult,"username"))

    IO.puts " Username is "
    IO.inspect username

    result = TwitterEngine.getTweets(username)
    IO.puts "Got the messages as follows "
    IO.inspect result
  #  [{400, ["Janwdwde Doe", [], [], {{2019, 12, 12}, {18, 15, 59}}, 0, 400]}]
    msg_list = Enum.map(result, fn(item)->
                  {_,msg} = item
                  Enum.at(msg,0)
                end)
    IO.puts "Message list "
    IO.inspect msg_list
    push(socket,"listen_to_tweets", %{content: msg_list})
    #TwitterEngine.storeTweet(5,msg)

    {:noreply,socket}
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
