require "rails_helper"
require "spec_helper"

describe User do
  let(:user) { FactoryBot.create(:user) }
  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }

  it { should be_valid }

  describe "empty name" do
    before { user.name = " " }

    it { should_not be_valid }
  end

  describe "blank name" do
    before { user.name = " " }

    it { should_not be_valid }
  end

  describe "empty email" do
    before { user.email = " " }

    it { should_not be_valid }
  end

  describe "blank email" do
    before { user.email = " " }

    it { should_not be_valid }
  end

  describe "empty password" do
    before { user.password = " " }

    it { should_not be_valid }
  end

  describe "blank password" do
    before { user.password = " " }

    it { should_not be_valid }
  end
  describe "acceptable long name" do
    before { user.name = "b" * 50 }

    it { should be_valid }
  end

  describe "too long name" do
    before { user.name = "a" * 51 }

    it { should_not be_valid }
  end

  describe "duplicate name" do
    let(:duplicate) do
      d = user.dup
      d.email = "duplicate@example.com"
      d.password = "new_password"
      d
    end

    it "is not allowed" do
      expect(duplicate).not_to be_valid
    end
  end

  describe "duplicate email" do
    let(:duplicate) do
      d = user.dup
      d.name = "Jane Doe"
      d.password = "new_password"
      d
    end

    it "is not allowed" do
      expect(duplicate).not_to be_valid
    end
  end
end
