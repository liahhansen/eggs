class Notifier < ActionMailer::Base
  def order_confirmation(order)
    recipients order.member.email_address_with_name
    from       "\"#{order.delivery.farm.name}\" <eggs@eggbasket.org>"
    subject    "[#{order.delivery.farm.name} CSA] #{order.location.name} #{order.delivery.pretty_date} - Order Confirmation"
    body       :order => order
  end

  def welcome_and_activation(user)
    subject       "Introducing Soul Food Farm's new CSA system!"
    from          "EggBasket <noreply@eggbasket.org>"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token), :user => user
    
  end

  def activation_instructions(user)
    subject       "Activation Instructions"
    from          "EggBasket <noreply@eggbasket.org>"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  def activation_confirmation(user)
    subject       "Thanks for joining us!"
    from          "EggBasket <noreply@eggbasket.org>"
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url, :user => user
  end

  def password_reset_instructions(user)
    subject       "EggBasket Password Reset Instructions"
    from          "EggBasket <noreply@eggbasket.org>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

end
