class WishlistsController < ApplicationController
  before_action :set_wishlist, only: [:show, :edit, :update, :destroy, :share]

  def index
    @my_wishlists = current_user.wishlists.order(year: :desc)
    
    if current_user.has_filled_list
      @family_wishlists = current_user.family.wishlists
                                     .where.not(user_id: current_user.id)
                                     .where(is_public: true)
                                     .includes(:user, :gifts)
                                     .order(year: :desc)
    else
      @family_wishlists = []
    end
  end

  def show
    if @wishlist.user != current_user && !current_user.has_filled_list
      redirect_to wishlists_path, alert: "Vous devez d'abord remplir votre liste pour voir celles des autres"
      return
    end

    @gifts = @wishlist.gifts.includes(:reserved_by)
  end

  def new
    @wishlist = current_user.wishlists.build
    @wishlist.year = Time.current.year
  end

  def create
    @wishlist = current_user.wishlists.build(wishlist_params)
    @wishlist.family = current_user.family

    if @wishlist.save
      redirect_to @wishlist, notice: "Liste créée avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless @wishlist.user == current_user
      redirect_to wishlists_path, alert: "Vous ne pouvez modifier que vos propres listes"
    end
  end

  def update
    unless @wishlist.user == current_user
      redirect_to wishlists_path, alert: "Vous ne pouvez modifier que vos propres listes"
      return
    end

    if @wishlist.update(wishlist_params)
      if @wishlist.is_public && @wishlist.gifts.any?
        current_user.update(has_filled_list: true)
      end
      
      redirect_to @wishlist, notice: "Liste mise à jour avec succès"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @wishlist.user == current_user
      redirect_to wishlists_path, alert: "Vous ne pouvez supprimer que vos propres listes"
      return
    end

    @wishlist.destroy
    redirect_to wishlists_path, notice: "Liste supprimée avec succès"
  end

  def share
    WishlistMailer.share_wishlist(@wishlist, params[:email]).deliver_later
    redirect_to @wishlist, notice: "Liste partagée par email à #{params[:email]}"
  end

  private

  def set_wishlist
    @wishlist = Wishlist.find(params[:id])
  end

  def wishlist_params
    params.require(:wishlist).permit(:title, :description, :year, :is_public)
  end
end
