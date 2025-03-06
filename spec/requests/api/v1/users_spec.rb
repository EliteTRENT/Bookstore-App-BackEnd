require 'rails_helper'

RSpec.describe UserService, type: :service do
  describe ".signup" do
    context "with valid attributes" do
      let(:valid_attributes) do
        {
          name: "John Doe",
          email: "john.doe@gmail.com",
          password: "Password@123",
          mobile_number: "9876543210"
        }
      end

      it "creates a user successfully" do
        result = UserService.signup(valid_attributes)
        expect(result[:success]).to be_truthy
        expect(result[:message]).to eq("User created successfully")
        expect(result[:user]).to be_a(User)
        expect(result[:user].persisted?).to be_truthy
      end
    end

    context "with invalid attributes" do
      it "returns an error when name is missing" do
        invalid_attributes = {
          name: "",
          email: "john.doe@gmail.com",
          password: "Password@123",
          mobile_number: "9876543210"
        }
        result = UserService.signup(invalid_attributes)
        expect(result[:error]).to include("Name can't be blank")
      end

      it "returns an error when name format is invalid" do
        invalid_attributes = {
          name: "jd",
          email: "john.doe@gmail.com",
          password: "Password@123",
          mobile_number: "9876543210"
        }
        result = UserService.signup(invalid_attributes)
        expect(result[:error]).to include("Name must start with a capital letter, be at least 3 characters long, and contain only alphabets with spaces allowed between words")
      end

      it "returns an error when email is missing" do
        invalid_attributes = {
          name: "John Doe",
          email: "",
          password: "Password@123",
          mobile_number: "9876543210"
        }
        result = UserService.signup(invalid_attributes)
        expect(result[:error]).to include("Email can't be blank")
      end

      it "returns an error when email is already taken" do
        User.create!(name: "John Doe", email: "john.doe@gmail.com", password: "Password@123", mobile_number: "9876543210")
        invalid_attributes = {
          name: "John Doe",
          email: "john.doe@gmail.com",
          password: "Password@123",
          mobile_number: "9876543211"
        }
        result = UserService.signup(invalid_attributes)
        expect(result[:error]).to include("Email has already been taken")
      end

      it "returns an error when email format is invalid" do
        invalid_attributes = {
          name: "John Doe",
          email: "john.doe@invalid.com",
          password: "Password@123",
          mobile_number: "9876543210"
        }
        result = UserService.signup(invalid_attributes)
        expect(result[:error]).to include("Email must be a valid email with @gmail, @yahoo, or @ask and a valid domain (.com, .in, etc.)")
      end

      it "returns an error when password is missing" do
        invalid_attributes = {
          name: "John Doe",
          email: "john.doe@gmail.com",
          password: "",
          mobile_number: "9876543210"
        }
        result = UserService.signup(invalid_attributes)
        expect(result[:error]).to include("Password can't be blank")
      end

      it "returns an error when password is weak" do
        invalid_attributes = {
          name: "John Doe",
          email: "john.doe@gmail.com",
          password: "weakpass",
          mobile_number: "9876543210"
        }
        result = UserService.signup(invalid_attributes)
        expect(result[:error]).to include("Password must be at least 8 characters long, include one uppercase letter, one lowercase letter, one digit, and one special character")
      end

      it "returns an error when mobile number is missing" do
        invalid_attributes = {
          name: "John Doe",
          email: "john.doe@gmail.com",
          password: "Password@123",
          mobile_number: ""
        }
        result = UserService.signup(invalid_attributes)
        expect(result[:error]).to include("Mobile number can't be blank")
      end

      it "returns an error when mobile number is invalid" do
        invalid_attributes = {
          name: "John Doe",
          email: "john.doe@gmail.com",
          password: "Password@123",
          mobile_number: "12345"
        }
        result = UserService.signup(invalid_attributes)
        expect(result[:error]).to include("Mobile number must be a 10-digit number starting with 6-9, optionally prefixed with +91")
      end

      it "returns an error when mobile number is already taken" do
        User.create!(name: "John Doe", email: "john.doe@gmail.com", password: "Password@123", mobile_number: "9876543210")
        invalid_attributes = {
          name: "Jane Doe",
          email: "jane.doe@gmail.com",
          password: "Password@123",
          mobile_number: "9876543210"
        }
        result = UserService.signup(invalid_attributes)
        expect(result[:error]).to include("Mobile number has already been taken")
      end
    end
  end
end