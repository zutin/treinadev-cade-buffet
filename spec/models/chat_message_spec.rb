require 'rails_helper'

RSpec.describe ChatMessage, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when message text is missing' do
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
        chat_message = ChatMessage.new(order: order, sender: user2)

        expect(chat_message.valid?).to eq false
        expect(chat_message.errors[:text]).to include("não pode ficar em branco")
      end
    end

    context 'length' do
      it 'false when message text is shorter than 1 character' do
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
        chat_message = ChatMessage.new(text: '', order: order, sender: user2)

        expect(chat_message.valid?).to eq false
        expect(chat_message.errors[:text]).to include("não pode ficar em branco")
      end

      it 'false when message text is longer than 200 character' do
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
        chat_message = ChatMessage.new(text: 'cincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocincocinco1',
                                      order: order, sender: user2)

        expect(chat_message.valid?).to eq false
        expect(chat_message.errors[:text]).to include("é muito longo (máximo: 200 caracteres)")
      end
    end
  end

end
