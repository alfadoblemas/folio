class UserMailer < ActionMailer::Base
  
  def welcome_email(user, account)
    recipients  user.email
    from        "Folio <notifications@folio.cl>"
    subject     "Bienvenido a Folio"
    sent_on     Time.now
    body        :name => user.name, :user => user, :url => "http://#{account.subdomain}.folio.cl" 
  end
  
  def password_reset_instructions(user)
    subdomain = user.account.subdomain
    url = "http://#{subdomain}.folio.cl"
    default_url_options[:host] = "#{subdomain}.folio.cl"
    
    recipients  user.email
    from        "Folio <ayuda@folio.cl>"
    subject     "Instrucciones para actualizar contraseña"
    sent_on     Time.now
    body        :edit_password_reset_url => edit_password_reset_url(user.perishable_token), :name => user.name
  end

end
