class FamiliesController < ApplicationController
  def show
    @family = current_user.family
    @members = @family.users.order(:first_name, :last_name)
  end

  def join
    # Afficher le formulaire pour rejoindre une famille avec un code
  end

  def join_with_code
    family = Family.find_by(invite_code: params[:invite_code].upcase)
    
    if family
      current_user.update(family: family)
      redirect_to family_path, notice: "Vous avez rejoint la famille #{family.name}"
    else
      flash.now[:alert] = "Code d'invitation invalide"
      render :join, status: :unprocessable_entity
    end
  end
end
