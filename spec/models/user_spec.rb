require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:password) }

    it { should validate_length_of(:password).is_at_least(10).is_at_most(16) }

    it "should validate password strength" do
      user = User.new(name: "Test User")

      # Test password too short
      user.password = "weak"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, one digit, and cannot have three repeating characters in a row")

      # Test password missing lowercase
      user.password = "UPPER123456"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, one digit, and cannot have three repeating characters in a row")

      # Test password missing uppercase
      user.password = "lower123456"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, one digit, and cannot have three repeating characters in a row")

      # Test password missing digit
      user.password = "LowercaseUPPERCASE"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, one digit, and cannot have three repeating characters in a row")

      # Test password with repeating characters
      user.password = "ValidPass123AAA"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, one digit, and cannot have three repeating characters in a row")

      # Test valid password
      user.password = "ValidPass123"
      expect(user).to be_valid
    end
  end
end

