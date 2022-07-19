require "spec_helper"

describe "LoginPages" do
  subject { page }

  describe "SignIn page" do
    before { visit "/logins/new" }

    it { should have_content("Sign In") }

    describe "with invalid account information" do
      before { click_button "Log In" }

      it { should have_selector(".ALERT-danger", text: "Invalid") }

      describe "with bad password" do
        let (:user) { FactoryBot.create(:user) }

        before do
          fill_in "Username", with: user.name
          fill_in "Password", with: "garbage"
          click_button "Log In"
        end

        it { should have_selector(".ALERT-danger", text: "Invalid") }
      end
    end

    describe "with valid account information" do
      let(:user) { FactoryBot.create(:user) }

      before do
        fill_in "Username", with: user.name
        fill_in "Password", with: user.password
        click_button "Log In"
      end

      it { should have_link("Log Out", href: "/logins/#{user.id}") }

      it { should_not have_link("Log In", href: "/logins/new") }

      it { should have_selector(".ALERT-success") }

      describe "followed by logout" do
        before { click_link "Log Out" }

        it { should have_link("Log In", href: "/logins/new") }
        it { should_not have_link("Log Out", href: "/logins/#{user.id}") }
        it { should have_selector(".ALERT-info") }
      end
    end
  end
end
