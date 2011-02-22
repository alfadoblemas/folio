class UserMailer < ActionMailer::Base
  
  def  welcome_email(user, account)
    recipients  user.email
    from        "Folio <notifications@folio.cl>"
    subject     "Bienvenido a Folio"
    sent_on     Time.now
    body        :name => user.name, :user => user, :url => "http://#{account.subdomain}.folio.cl" 
  end

end
