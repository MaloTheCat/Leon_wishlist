require "test_helper"

class WishlistMailerTest < ActionMailer::TestCase
  test "share_wishlist" do
    mail = WishlistMailer.share_wishlist
    assert_equal "Share wishlist", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
