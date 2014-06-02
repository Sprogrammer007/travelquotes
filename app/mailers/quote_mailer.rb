class QuoteMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.quote_mailer.email_quote_id.subject
  #
  def email_quote_id(quote)
    @quote = quote

    mail to: quote.email, subject: "Your Recent Quote At TravelQuoteSys"
  end
end
