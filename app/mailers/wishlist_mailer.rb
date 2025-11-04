class WishlistMailer < ApplicationMailer
  def share_wishlist(wishlist, recipient_email)
    @wishlist = wishlist
    @user = wishlist.user
    @gifts = wishlist.gifts

    mail(
      to: recipient_email,
      subject: "#{@user.full_name} partage sa liste de cadeaux avec vous !"
    )
  end
end
