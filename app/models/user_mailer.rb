class UserMailer < ActionMailer::Base

  def welcome_email(user, account, password = nil)
    recipients  user.email
    from        "Folio <notifications@folio.cl>"
    subject     "Bienvenido a Folio"
    sent_on     Time.now
    body        :name => user.name, :user => user, :password => password, :url => "http://#{account.subdomain}.folio.cl"
  end

  def welcome_guest_email(user, account, admin_user ,password = nil)
    recipients  user.email
    from        "#{admin_user.name} <notifications@folio.cl>"
    subject     "Invitación para unirte a nuestra cuenta en Folio"
    sent_on     Time.now
    body        :name => user.name, :user => user, :password => password,
      :account_admin_name => admin_user.name, :account_name => account.name, :url => "http://#{account.subdomain}.folio.cl"
  end

  def password_reset_instructions(user)
    subdomain = user.subdomain
    url = "http://#{subdomain}.folio.cl"
    default_url_options[:host] = "#{subdomain}.folio.cl"

    recipients  user.email
    from        "Folio <ayuda@folio.cl>"
    subject     "Instrucciones para actualizar contraseña"
    sent_on     Time.now
    body        :edit_password_reset_url => edit_password_reset_url(user.perishable_token), :name => user.name
  end

  def comment_notification(recipient, comment, users_subscribed)
    comment_user = comment.user
    subdomain = comment_user.subdomain
    url = "http://#{subdomain}.folio.cl"
    default_url_options[:host] = "#{subdomain}.folio.cl"
    invoice = Invoice.find(comment.invoice_id)
    customer = Customer.find(invoice.customer_id)
    users = users_subscribed.map {|u| u.name}.join(", ")

    recipients  recipient.email
    from        "Folio <notifications@folio.cl>"
    subject     "[Nuevo Comentario] Factura #{invoice.number} - #{invoice.subject}"
    sent_on     Time.now
    body        :comment => comment, :users => users, :user => comment_user, :url => url,
      :invoice => invoice, :customer => customer
  end

end
