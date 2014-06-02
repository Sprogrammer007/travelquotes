require "spec_helper"

describe QuoteMailer do
  describe "email_quote_id" do
    let(:mail) { QuoteMailer.email_quote_id }

    it "renders the headers" do
      mail.subject.should eq("Email quote")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
