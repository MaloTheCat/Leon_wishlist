class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    # Formulaire de connexion
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to wishlists_path, notice: "Bienvenue #{user.full_name} !"
    else
      flash.now[:alert] = "Email ou mot de passe incorrect"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Vous êtes déconnecté"
  end
end
