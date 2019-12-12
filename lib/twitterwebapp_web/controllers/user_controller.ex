defmodule TwitterwebappWeb.UserController do
  use TwitterwebappWeb, :controller

  def index(conn, _params) do
    render(conn, "newuser.html")
  end

  def create(conn, params) do
    IO.puts "Arrived here but not doing shit"
    render(conn, "landingpage.html")
  end

  def new(conn,_params) do
    IO.puts "Called here atleast"
    render(conn,"newuser.html")
  end

  def show(conn,%{"id" => id}) do
    IO.puts "Called here atleast"
    IO.inspect id
    render(conn,"tweetspage.html", userid: id)
  end
end
