// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()




// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("room:registrations", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

if (document.querySelector("#new_user_reg") !== null)
{
console.log(" The Elemt new_user_reg exists ")
document.querySelector("#new_user_reg").addEventListener('submit', (e) => {
    e.preventDefault()
    let username = document.querySelector("#username")
    console.log(" Username is "+username.value)
  //  let password = document.querySelector("#password").value;
    //let messageInput = e.target.querySelector('#message-content')

    channel.push('user:add', { message: username.value })

    //window.location.href = "http://localhost:4000/"

    //messageInput.value = ""
  });
}

if (document.querySelector("#post_tweet") !== null)
{
document.querySelector("#post_tweet").addEventListener('click', (e) => {
    e.preventDefault()
    console.log("Post tweet button was clicked")
    let msg = document.querySelector("#tweet_msg")
    console.log(" Message to be posted is "+msg.value)

    let channelRoomId = window.channelRoomId
    console.log(" Room ID is "+channelRoomId)
    channel.push("post_tweet", {tweet_msg: msg.value,username: channelRoomId})
    //let messageInput = e.target.querySelector('#message-content')

  //  channel.push('user:add', { message: username.value })

    //window.location.href = "http://localhost:4000/"

    //messageInput.value = ""
  });
}

if (document.querySelector("#get_tweets") !== null)
{

document.querySelector("#get_tweets").addEventListener('click', (e) => {
    e.preventDefault()
    console.log("Get All Tweets button was clicked")
    let channelRoomId = window.channelRoomId
    console.log(" Room ID is "+channelRoomId)
    channel.push("get_tweet", {username: channelRoomId})
  });
}

if (document.querySelector("#search_tweets") !== null)
{

document.querySelector("#search_tweets").addEventListener('click', (e) => {
    e.preventDefault()
    console.log("Search Tweets button was clicked")
    let msg = document.querySelector("#search_msg")
    console.log(" We need to search for tweet "+msg.value)
  });
}

if (document.querySelector("#search_hashtags") !== null)
{

document.querySelector("#search_hashtags").addEventListener('click', (e) => {
    e.preventDefault()
    console.log("Search hashtags button was clicked")
    let msg = document.querySelector("#search_hashtag")
    console.log(" We need to search for hashtag "+msg.value)
  });
}

if (document.querySelector("#search_mentions") !== null)
{

document.querySelector("#search_mentions").addEventListener('click', (e) => {
    e.preventDefault()
    console.log("Search mention button was clicked")
    let msg = document.querySelector("#search_mention")
    let channelRoomId = window.channelRoomId
    console.log(" We need to search for the mentions of user "+channelRoomId)
  });
}

channel.on("room:registrations:new_user", (message) => {
    console.log("message", message.content)

    let messageTemplate = `
      <li class="list-group-item">${message.content}</li>
    `
    document.querySelector("#messageslist").innerHTML += messageTemplate
  });

  channel.on("render_response", (message) => {
      console.log("message", message)
      document.querySelector("#maindiv").innerHTML = message.html

      let messageTemplate = `
        <li class="list-group-item">${message.content}</li>
      `
      document.querySelector("#messageslist").innerHTML += messageTemplate

    });

channel.on("listen_to_tweets", (message) => {
    console.log("message", message)
    

    let messageTemplate = `
      <li class="list-group-item">${message.content}</li>
    `
    document.querySelector("#tweetslist").innerHTML += messageTemplate

  });



export default socket
