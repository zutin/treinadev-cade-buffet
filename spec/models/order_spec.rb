require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'has multiple orders for desired date' do
    it 'returns true when multiple orders' do
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: CPF.generate, contact_number: '(12) 99205-1023',
                          email: 'user2@customer.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                          email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                          zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                        default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                        can_change_location: true, valet_service: true, buffet: buffet)
      Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: 'Evento 1',
                    desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer)
      order = Order.create!(desired_date: '2024-12-16', estimated_invitees: 20, observation: 'Evento 2',
                    desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer)

      expect(order.has_multiple_orders_for_desired_date?).to eq true
    end

    it 'returns false when no multiple orders' do
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: CPF.generate, contact_number: '(12) 99205-1023',
                          email: 'user2@customer.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                          email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                          zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                        default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                        can_change_location: true, valet_service: true, buffet: buffet)
      Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: 'Evento 1',
                    desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer)
      order = Order.create!(desired_date: '2024-12-30', estimated_invitees: 20, observation: 'Evento 2',
                    desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer)

      expect(order.has_multiple_orders_for_desired_date?).to eq false
    end
  end
  describe 'generates a random order code' do
    it 'when creating a new order' do
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
      user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: CPF.generate, contact_number: '(12) 99205-1023',
                          email: 'user2@customer.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                          email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                          zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                        default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                        can_change_location: true, valet_service: true, buffet: buffet)

      order = Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                        desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: user2)

      expect(order.code).not_to be_empty
      expect(order.code.length).to eq 8
    end

    it 'generates an unique code' do
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
      user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: CPF.generate, contact_number: '(12) 99205-1023',
                          email: 'user2@customer.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                          email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                          zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                        default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                        can_change_location: true, valet_service: true, buffet: buffet)

      order1 = Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                        desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: user2)
      order2 = Order.create!(desired_date: '2024-12-21', estimated_invitees: 11, observation: '',
                        desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: user2)

      expect(order2.code).not_to eq order1.code
    end
  end
  describe '#valid?' do
    context 'presence' do
      it 'false when desired date is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: CPF.generate, contact_number: '(12) 99205-1023',
                            email: 'user2@customer.com', password: 'password', role: 'customer')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        order = Order.new(desired_date: '', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: user2)

        expect(order.valid?).to eq false
        expect(order.errors[:desired_date]).to include("não pode ficar em branco")
      end

      it 'false when estimated invitees is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: CPF.generate, contact_number: '(12) 99205-1023',
                            email: 'user2@customer.com', password: 'password', role: 'customer')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        order = Order.new(desired_date: '2024-12-16', observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: user2)

        expect(order.valid?).to eq false
        expect(order.errors[:estimated_invitees]).to include("não pode ficar em branco")
      end

      it 'false when desired address is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: CPF.generate, contact_number: '(12) 99205-1023',
                            email: 'user2@customer.com', password: 'password', role: 'customer')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        order = Order.new(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: '', buffet: buffet, event: event, user: user2)

        expect(order.valid?).to eq false
        expect(order.errors[:desired_address]).to include("não pode ficar em branco")
      end

      it 'false when buffet association is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: CPF.generate, contact_number: '(12) 99205-1023',
                            email: 'user2@customer.com', password: 'password', role: 'customer')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        order = Order.new(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', event: event, user: user2)

        expect(order.valid?).to eq false
        expect(order.errors[:buffet]).to include("é obrigatório(a)")
      end

      it 'false when event association is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        user2 = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: CPF.generate, contact_number: '(12) 99205-1023',
                            email: 'user2@customer.com', password: 'password', role: 'customer')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        order = Order.new(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, user: user2)

        expect(order.valid?).to eq false
        expect(order.errors[:event]).to include("é obrigatório(a)")
      end

      it 'false when user association is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                            email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Drift na praça', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        order = Order.new(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event)

        expect(order.valid?).to eq false
        expect(order.errors[:user]).to include("é obrigatório(a)")
      end
    end
  end
end
