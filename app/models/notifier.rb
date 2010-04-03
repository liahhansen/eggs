class Notifier < ActionMailer::Base
  def order_confirmation(order)
    recipients order.member.email_address_with_name
    from       "\"#{order.delivery.farm.name}\" <eggs@eggbasket.org>"
    subject    "[#{order.delivery.farm.name} CSA] #{order.location.name} #{order.delivery.pretty_date} - Order Confirmation"
    body       :order => order
  end

  def activation_instructions(user)
    subject       "Activation Instructions"
    from          "Eggbasket <noreply@eggbasket.org>"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  def activation_confirmation(user)
    subject       "Activation Complete"
    from          "Eggbasket <noreply@eggbasket.org>"
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end

  def password_reset_instructions(user)
    subject       "Eggbasket Password Reset Instructions"
    from          "Eggbasket <noreply@eggbasket.org>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

end
