require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when username is missing' do
        user = User.new(username: '', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        expect(user.valid?).to eq false
      end

      it 'false when full name is missing' do
        user = User.new(username: 'usertest', full_name: '', social_security_number: "01234567890", contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        expect(user.valid?).to eq false
      end

      it 'false when contact number is missing' do
        user = User.new(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '', email: 'user@test.com', password: 'password')
        expect(user.valid?).to eq false
      end

      it 'false when email is missing' do
        user = User.new(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432', email: '', password: 'password')
        expect(user.valid?).to eq false
      end

      it 'false when password is missing' do
        user = User.new(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432', email: 'user@test.com', password: '')
        expect(user.valid?).to eq false
      end

      it 'false when social security number is missing' do
        user = User.new(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        expect(user.valid?).to eq false
      end
    end

    context 'uniqueness' do
      it 'false when username is already in use' do
        User.create!(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        user = User.new(username: 'usertest', full_name: 'Non-Unique User', social_security_number: "3312321313", contact_number: '(12) 92345-6789', email: 'nonunique@user.com', password: 'uniquepassword')
        expect(user.valid?).to eq false
      end

      it 'false when email is already in use' do
        User.create!(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        user = User.new(username: 'unique', full_name: 'Non-Unique User', social_security_number: "3312321313", contact_number: '(12) 92345-6789', email: 'user@test.com', password: 'uniquepassword')
        expect(user.valid?).to eq false
      end
    end

    context 'length' do
      it 'false when username is shorter than 5 characters' do
        user = User.new(username: 'user', full_name: 'Non-Unique User', contact_number: '(12) 92345-6789', email: 'nonunique@user.com', password: 'uniquepassword')
        expect(user.valid?).to eq false
      end

      it 'false when password is shorter than 6 characters' do
        user = User.new(username: 'usertest', full_name: 'Non-Unique User', contact_number: '(12) 92345-6789', email: 'nonunique@user.com', password: 'passw')
        expect(user.valid?).to eq false
      end
    end
  end
end
