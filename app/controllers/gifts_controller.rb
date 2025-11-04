class GiftsController < ApplicationController
  before_action :set_wishlist
  before_action :set_gift, only: [:edit, :update, :destroy, :reserve, :unreserve]
  before_action :authorize_owner, only: [:new, :create, :edit, :update, :destroy]

  def new
    @gift = @wishlist.gifts.build
  end

  def create
    @gift = @wishlist.gifts.build(gift_params)

    if @gift.save
      current_user.update(has_filled_list: true) if @wishlist.gifts.count >= 1
      
      redirect_to @wishlist, notice: "Cadeau ajouté avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @gift.update(gift_params)
      redirect_to @wishlist, notice: "Cadeau mis à jour avec succès"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gift.destroy
    redirect_to @wishlist, notice: "Cadeau supprimé avec succès"
  end

  def reserve
    if @wishlist.user == current_user
      redirect_to @wishlist, alert: "Vous ne pouvez pas réserver vos propres cadeaux !"
      return
    end

    if @gift.reserved?
      redirect_to @wishlist, alert: "Ce cadeau est déjà réservé"
      return
    end

    @gift.update(reserved_by: current_user)
    redirect_to @wishlist, notice: "Cadeau réservé avec succès"
  end

  def unreserve
    if @gift.reserved_by != current_user
      redirect_to @wishlist, alert: "Vous ne pouvez annuler que vos propres réservations"
      return
    end

    @gift.update(reserved_by: nil)
    redirect_to @wishlist, notice: "Réservation annulée"
  end

  private

  def set_wishlist
    @wishlist = Wishlist.find(params[:wishlist_id])
  end

  def set_gift
    @gift = @wishlist.gifts.find(params[:id])
  end

  def authorize_owner
    unless @wishlist.user == current_user
      redirect_to wishlists_path, alert: "Vous ne pouvez modifier que vos propres cadeaux"
    end
  end

  def gift_params
    params.require(:gift).permit(:name, :price, :link)
  end
end
