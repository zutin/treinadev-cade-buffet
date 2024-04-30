require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when username is missing' do
        user = User.new(username: '', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        expect(user.valid?).to eq false
      end

      it 'false when full name is missing' do
        user = User.new(username: 'usertest', full_name: '', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        expect(user.valid?).to eq false
      end

      it 'false when contact number is missing' do
        user = User.new(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '', email: 'user@test.com', password: 'password')
        expect(user.valid?).to eq false
      end

      it 'false when email is missing' do
        user = User.new(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: '', password: 'password')
        expect(user.valid?).to eq false
      end

      it 'false when password is missing' do
        user = User.new(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: '')
        expect(user.valid?).to eq false
      end

      it 'false when social security number is missing' do
        user = User.new(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        expect(user.valid?).to eq false
      end
    end

    context 'uniqueness' do
      it 'false when username is already in use' do
        User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        user = User.new(username: 'usertest', full_name: 'Non-Unique User', social_security_number: CPF.generate, contact_number: '(12) 92345-6789', email: 'nonunique@user.com', password: 'uniquepassword')
        expect(user.valid?).to eq false
      end

      it 'false when email is already in use' do
        User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        user = User.new(username: 'unique', full_name: 'Non-Unique User', social_security_number: CPF.generate, contact_number: '(12) 92345-6789', email: 'user@test.com', password: 'uniquepassword')
        expect(user.valid?).to eq false
      end

      it 'false when social securiy number is already in use' do
        User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        user = User.new(username: 'unique', full_name: 'Non-Unique User', social_security_number: User.first.social_security_number, contact_number: '(12) 92345-6789', email: 'nonunique@test.com', password: 'uniquepassword')
        expect(user.valid?).to eq false
      end
    end

    context 'length' do
      it 'false when username is shorter than 5 characters' do
        user = User.new(username: 'user', full_name: 'Non-Unique User', contact_number: '(12) 92345-6789', social_security_number: CPF.generate, email: 'nonunique@user.com', password: 'uniquepassword')
        expect(user.valid?).to eq false
      end

      it 'false when username is longer than 20 characters' do
        user = User.new(username: 'useruseruseruseruseruser', full_name: 'Non-Unique User', contact_number: '(12) 92345-6789', social_security_number: CPF.generate, email: 'nonunique@user.com', password: 'uniquepassword')
        expect(user.valid?).to eq false
      end

      it 'false when password is shorter than 6 characters' do
        user = User.new(username: 'usertest', full_name: 'Non-Unique User', contact_number: '(12) 92345-6789', social_security_number: CPF.generate, email: 'nonunique@user.com', password: 'passw')
        expect(user.valid?).to eq false
      end

      it 'false when contact number is shorter than 14 characters' do
        user = User.new(username: 'usertest', full_name: 'Non-Unique User', contact_number: '(12) 345-6789', social_security_number: CPF.generate, email: 'nonunique@user.com', password: 'password')
        expect(user.valid?).to eq false
      end

      it 'false when contact number is longer than 15 characters' do
        user = User.new(username: 'usertest', full_name: 'Non-Unique User', contact_number: '(12) 92345-67891', social_security_number: CPF.generate, email: 'nonunique@user.com', password: 'password')
        expect(user.valid?).to eq false
      end

      it 'false when social security number is shorter than 11 characters long' do
        user = User.new(username: 'usertest', full_name: 'Non-Unique User', contact_number: '(12) 92345-6789', social_security_number: "123456789", email: 'nonunique@user.com', password: 'password')
        expect(user.valid?).to eq false
      end

      it 'false when social security number is longer than 11 characters long' do
        user = User.new(username: 'usertest', full_name: 'Non-Unique User', contact_number: '(12) 92345-6789', social_security_number: "012345678901", email: 'nonunique@user.com', password: 'password')
        expect(user.valid?).to eq false
      end
    end

    context 'social security number' do
      it 'false when social security number value is invalid' do
        user = User.new(username: 'usertest', full_name: 'Non-Unique User', contact_number: '(12) 92345-6789', social_security_number: "11122233344", email: 'nonunique@user.com', password: 'password')
        expect(user.valid?).to eq false
      end
    end

    context 'enum' do
      it 'false when role is invalid' do
        expect{User.create!(username: 'usertest', full_name: 'Non-Unique User', contact_number: '(12) 92345-6789',
        social_security_number: CPF.generate, email: 'nonunique@user.com', password: 'password', role: 'admin')}.to raise_error(ArgumentError)
      end
    end
  end
end
