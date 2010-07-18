class Notifier < ActionMailer::Base
  def order_confirmation(order, update = false)
    recipients order.member.email_address_with_name
    from       "\"#{order.delivery.farm.name}\" <eggs@eggbasket.org>"
    subject    "[#{order.delivery.farm.name} CSA] #{order.location.name} #{order.delivery.pretty_date} - Order Confirmation #{' - Update' if update}"
    body       :order => order, :update => update
  end

  def welcome_and_activation(user)
    subject       "Introducing Soul Food Farm's new CSA system!"
    from          "EggBasket <noreply@eggbasket.org>"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token), :user => user
    
  end

  def new_member_notification(user, farm)
    subject       "New member: #{user.member.last_name}, #{user.member.first_name} - #{user.email}"
    from          "#{farm.name} EggBasket <noreply@eggbasket.org>"
    recipients    farm.contact_email
    sent_on       Time.now
    body          :user => user, :farm => farm
  end

  def mailing_list_subscription_request(user,farm)
    subject       "Subscribe"
    from          user.email
    recipients    farm.mailing_list_subscribe_address
    sent_on       Time.now
    body          :user => user
  end

  def password_reset_instructions(user)
    subject       "EggBasket Password Reset Instructions"
    from          "EggBasket <noreply@eggbasket.org>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def finalized_order_confirmation(order)
    subject       "Your #{order.delivery.farm.name} - #{order.location.name} order has been finalized!"
    from          "#{order.delivery.farm.name} EggBasket <noreply@eggbasket.org>"
    recipients    order.member.email_address
    sent_on       Time.now
    body          :order => order
  end

  def order_notes_notification(order)
    subject       "A recent order has special notes: #{order.member.last_name}, #{order.delivery.name}"
    from          "EggBasket <noreply@eggbasket.org>"
    recipients    order.delivery.farm.contact_email
    sent_on       Time.now
    body          :order => order
  end

  def admin_notification(notice, farm=nil)
    subject       "EggBasket Notice: #{notice[:subject]}"
    from          "EggBasket <noreply@eggbasket.org>"
    recipients    farm ? farm.contact_email : "eggbasket@kathrynaaker.com"
    sent_on       Time.now
    body          :body => notice[:body]
  end

end
