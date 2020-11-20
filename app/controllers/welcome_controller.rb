class WelcomeController < ApplicationController
  def index
    cookies[:curso] = "Curso de Ruby on Rails - Lucas Holdefer [Cookie]"
    session[:curso] = "Curso de Ruby on Rails - Lucas Holdefer [Session]"
    @nome = params[:nome]
    @curso = params[:curso]
  end
end
