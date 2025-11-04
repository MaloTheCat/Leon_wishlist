# Preview all emails at http://localhost:3000/rails/mailers/wishlist_mailer
class WishlistMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/wishlist_mailer/share_wishlist
  def share_wishlist
    WishlistMailer.share_wishlist
  end

end
