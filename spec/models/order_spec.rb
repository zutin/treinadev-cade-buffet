require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'generates a random order code' do
    it 'when creating a new order' do
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
      user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: "14355855007", contact_number: '(12) 99205-1023',
                          email: 'user2@customer.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                          email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                          zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                        default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                        can_change_location: true, valet_service: true, buffet: buffet)

      order = Order.create!(desired_date: '2024-05-16', estimated_invitees: 15, observation: '',
                        desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: user2)

      expect(order.code).not_to be_empty
      expect(order.code.length).to eq 8
    end

    it 'generates an unique code' do
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
      user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: "14355855007", contact_number: '(12) 99205-1023',
                          email: 'user2@customer.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                          email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                          zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                        default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                        can_change_location: true, valet_service: true, buffet: buffet)

      order1 = Order.create!(desired_date: '2024-05-16', estimated_invitees: 15, observation: '',
                        desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: user2)
      order2 = Order.create!(desired_date: '2024-06-21', estimated_invitees: 11, observation: '',
                        desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: user2)

      expect(order2.code).not_to eq order1.code
    end
  end
  describe '#valid?' do
    context 'presence' do
      it 'false when desired date is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: "14355855007", contact_number: '(12) 99205-1023',
                            email: 'user2@customer.com', password: 'password', role: 'customer')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)

        order = Order.new(desired_date: '', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: user2)

        expect(order.valid?).to eq false
      end

      it 'false when estimated invitees is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: "14355855007", contact_number: '(12) 99205-1023',
                            email: 'user2@customer.com', password: 'password', role: 'customer')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)

        order = Order.new(desired_date: '2024-05-16', observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: user2)

        expect(order.valid?).to eq false
      end

      it 'false when desired address is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: "14355855007", contact_number: '(12) 99205-1023',
                            email: 'user2@customer.com', password: 'password', role: 'customer')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)

        order = Order.new(desired_date: '2024-05-16', estimated_invitees: 15, observation: '',
                          desired_address: '', buffet: buffet, event: event, user: user2)

        expect(order.valid?).to eq false
      end

      it 'false when buffet association is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: "14355855007", contact_number: '(12) 99205-1023',
                            email: 'user2@customer.com', password: 'password', role: 'customer')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)

        order = Order.new(desired_date: '2024-05-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', event: event, user: user2)

        expect(order.valid?).to eq false
      end

      it 'false when event association is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: "14355855007", contact_number: '(12) 99205-1023',
                            email: 'user2@customer.com', password: 'password', role: 'customer')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        order = Order.new(desired_date: '2024-05-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, user: user2)

        expect(order.valid?).to eq false
      end

      it 'false when user association is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: "01234567890", contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)

        order = Order.new(desired_date: '2024-05-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event)

        expect(order.valid?).to eq false
      end
    end
  end
end
