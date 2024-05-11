require 'rails_helper'

RSpec.describe Proposal, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when total value is missing' do
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
        proposal = Proposal.new(total_value: '', expire_date: '2024-12-30', description: '', discount: '', tax: '', payment_method: 'Pix', order: order)

        expect(proposal.valid?).to eq false
        expect(proposal.errors[:total_value]).to include("não pode ficar em branco")
      end

      it 'false when expire date is missing' do
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
        proposal = Proposal.new(total_value: 1000, expire_date: '', description: '', discount: '', tax: '', payment_method: 'Pix', order: order)

        expect(proposal.valid?).to eq false
        expect(proposal.errors[:expire_date]).to include("não pode ficar em branco")
      end

      it 'false when payment method is missing' do
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
        proposal = Proposal.new(total_value: 1000, expire_date: '2024-12-30', description: '', discount: '', tax: '', payment_method: '', order: order)

        expect(proposal.valid?).to eq false
        expect(proposal.errors[:payment_method]).to include("não pode ficar em branco")
      end

      it 'false when order association is missing' do
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
        Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: user2)
        proposal = Proposal.new(total_value: 1000, expire_date: '2024-12-30', description: '', discount: '', tax: '', payment_method: 'Pix')

        expect(proposal.valid?).to eq false
        expect(proposal.errors[:order]).to include("é obrigatório(a)")
      end

      it 'false when expire date is in the past' do
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
        proposal = Proposal.new(total_value: 1000, expire_date: '2023-01-01', description: '', discount: '', tax: '', payment_method: 'Pix', order: order)
  
        expect(proposal.valid?).to eq false
        expect(proposal.errors[:expire_date]).to include("não pode ser no passado.")
      end
    end

    context 'numericality' do
      it 'false when total value is less than zero' do
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
        proposal = Proposal.new(total_value: 0, expire_date: '2024-12-16', description: '', discount: '', tax: '', payment_method: 'Pix', order: order)
  
        expect(proposal.valid?).to eq false
        expect(proposal.errors[:total_value]).to include("deve ser maior que 0")
      end
    end
  end
end
