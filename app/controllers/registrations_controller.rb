class RegistrationsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
    @family = Family.new
  end

  def create
    @user = User.new(user_params)
    
    if params[:family_id].present?
      # Rejoindre une famille existante
      @family = Family.find_by(id: params[:family_id])
    elsif params[:invite_code].present?
      # Rejoindre avec un code d'invitation
      @family = Family.find_by(invite_code: params[:invite_code].upcase)
    else
      # Créer une nouvelle famille
      @family = Family.new(name: params[:family_name])
    end

    if @family&.valid? || @family&.persisted?
      @family.save unless @family.persisted?
      @user.family = @family
      
      if @user.save
        session[:user_id] = @user.id
        redirect_to wishlists_path, notice: "Compte créé avec succès !"
      else
        render :new, status: :unprocessable_entity
      end
    else
      @user.valid? # Pour afficher les erreurs de l'utilisateur
      flash.now[:alert] = "Erreur lors de la création de la famille"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
