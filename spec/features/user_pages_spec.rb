require "spec_helper"

describe "User Pages" do
  subject { page }

  describe "show users" do
    describe "individually" do
      let (:user) { FactoryBot.create(:user) }

      before { visit "/users/#{user.id}" }

      it { should have_content(user.name) }
      it { should have_content(user.email) }
      it { should_not have_content(user.password) }
    end

    describe "non-existant", type: :request do
      before { get "/users/-1" }

      specify { expect(response).to redirect_to("/users") }

      describe "follow redirect" do
        before { visit "/users/-1" }

        it { should have_selector(".ALERT-danger", text: "Unable") }
      end
    end

    describe "all" do
      before do
        25.times do |i|
          User.create(name: "Person #{i}", email: "person.#{i}@example.com", password: "password")
        end
        visit "/users"
      end
      it { should have_content("List of users") }
      it { should have_content("25 users") }

      it "should show all users" do
        User.all.each do |user|
          should have_selector("li", text: user.name)
          should have_selector("li", text: user.email)
        end
      end
    end
  end

  describe "creating user" do
    before { visit "users/new" }

    it "hides password text" do
      should have_field "user_password", type: "password"
    end

    describe "with invalid information" do
      it "does not add the user to the system" do
        expect { click_button "Submit" }.not_to change(User, :count)
      end

      it "produces an error message" do
        click_button "Submit"
        should have_selector(".ALERT-danger")
      end
    end

    describe "non-existant", type: :request do
      before { get "/users/-1/edit" }

      specify { expect(response).to redirect_to("/users") }

      describe "follow redirect" do
        before { visit "/users/-1/edit" }

        it { should have_selector(".ALERT-danger", text: "Unable") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Username", with: "Janysa Doe"
        fill_in "Email", with: "jokesa.doe@example.com"
        fill_in "Password", with: "password"
      end

      it "does add the user to the system" do
        expect { click_button "Submit" }.to change(User, :count).by(1)
      end

      it "allows the user to fill in the fields" do
        click_button "Submit"
      end

      describe "produces a welcome message" do
        before { click_button("Submit") }

        it { should have_selector("p.ALERT-success", text: "Welcome") }
      end

      describe "redirects to profile page", type: :request do
        before { post "/users", params: { user: { name: "John Doe", email: "jokesa.doe@example.com", password: "password" } } }

        specify { expect(response).to redirect_to "/users/#{assigns(:user).id}" }
      end
    end
  end

  describe "editing users" do
    let(:user) { FactoryBot.create(:user) }
    let!(:original_name) { user.name }
    let (:submit) { "Update user profile" }

    before do
      visit "users/#{user.id}/edit"
    end

    it { should have_field("Username", with: user.name) }
    it { should have_field("Email", with: user.email) }
    it { should have_field("Password") }

    describe "with invalid information" do
      before do
        fill_in "Username", with: ""
        fill_in "Email", with: ""
        fill_in "Password", with: ""
      end

      describe "does not change data" do
        before { click_button submit }

        specify { expect(user.reload.name).not_to eq("") }
        specify { expect(user.reload.name).to eq(original_name) }
      end
    end
  end

  describe "delete users" do
    let! (:user) { FactoryBot.create(:user) }

    before { visit "/users" }

    it { should have_link("delete", href: "/users/#{user.id}") }

    describe "redirects properly", type: :request do
      before { delete "/users/#{user.id}" }

      specify { expect(response).to redirect_to "/users" }
    end

    it "produces a delete message" do
      click_link("delete", match: :first)
      should have_selector(".ALERT-success")
    end

    it "removes a user from the system" do
      expect do
        click_link("delete", match: :first)
      end.to change(User, :count).by(-1)
    end
  end
end
