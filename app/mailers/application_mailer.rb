class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def send_notices
      mail(to: ["silvio@relli.it", "mttmanzo@gmail.com", "eppedema@gmail.com", "polloni.carolina@gmail.com", "blackice1983@gmail.com"],
          subject: "Alert black hour eprice")
  end
end
