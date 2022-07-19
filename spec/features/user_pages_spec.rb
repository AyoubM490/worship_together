require "spec_helper"

describe "User Pages" do
  subject { page }

  describe "show users" do
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
    end
  end
end
