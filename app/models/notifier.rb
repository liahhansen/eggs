class Notifier < ActionMailer::Base
  def order_confirmation(order)
    recipients order.member.email_address_with_name
    from       "\"#{order.pickup.farm.name}\" <eggs@eggbasket.org>"
    subject    "[#{order.pickup.farm.name}] #{order.pickup.name} - Order Confirmation"
    body       :order => order
  end

  def activation_instructions(user)
    subject       "Activation Instructions"
    from          "Eggbasket Notifier <noreply@eggbasket.org>"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  def activation_confirmation(user)
    subject       "Activation Complete"
    from          "Eggbasket Notifier <noreply@eggbasket.org>"
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end

end
