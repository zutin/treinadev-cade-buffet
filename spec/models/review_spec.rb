require 'rails_helper'

RSpec.describe Review, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when rating is missing' do
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
        order = Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer, status: 'confirmed')
        Proposal.create!(total_value: 1000, expire_date: '2024-12-30', description: '', discount: '', tax: '', payment_method: 'Pix', order: order)
        review = Review.new(rating: '', comment: 'Muito bom buffet', order: order, reviewer: customer)

        expect(review.valid?).to eq false
        expect(review.errors[:rating]).to include("não pode ficar em branco")
      end

      it 'false when comment is missing' do
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
        order = Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer, status: 'confirmed')
        Proposal.create!(total_value: 1000, expire_date: '2024-12-30', description: '', discount: '', tax: '', payment_method: 'Pix', order: order)
        review = Review.new(rating: 1, comment: '', order: order, reviewer: customer)

        expect(review.valid?).to eq false
        expect(review.errors[:comment]).to include("não pode ficar em branco")
      end

      it 'false when order association is missing' do
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
        order = Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer, status: 'confirmed')
        Proposal.create!(total_value: 1000, expire_date: '2024-12-30', description: '', discount: '', tax: '', payment_method: 'Pix', order: order)
        review = Review.new(rating: 3, comment: 'Muito bom buffet', reviewer: customer)

        expect(review.valid?).to eq false
        expect(review.errors[:order]).to include("é obrigatório(a)")
      end

      it 'false when reviewer association is missing' do
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
        order = Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer, status: 'confirmed')
        Proposal.create!(total_value: 1000, expire_date: '2024-12-30', description: '', discount: '', tax: '', payment_method: 'Pix', order: order)
        review = Review.new(rating: '', comment: 'Muito bom buffet', order: order)

        expect(review.valid?).to eq false
        expect(review.errors[:reviewer]).to include("é obrigatório(a)")
      end
    end

    context 'numericality' do
      it 'false when rating is not between 0 and 5' do
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
        order = Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer, status: 'confirmed')
        Proposal.create!(total_value: 1000, expire_date: '2024-12-30', description: '', discount: '', tax: '', payment_method: 'Pix', order: order)
        review = Review.new(rating: 10, comment: 'Muito bom buffet', order: order, reviewer: customer)

        expect(review.valid?).to eq false
        expect(review.errors[:rating]).to include("deve estar em 0..5")
      end
    end

    context 'length' do
      it 'false when comment is shorter than 1 character' do
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
        order = Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer, status: 'confirmed')
        Proposal.create!(total_value: 1000, expire_date: '2024-12-30', description: '', discount: '', tax: '', payment_method: 'Pix', order: order)
        review = Review.new(rating: 3, comment: '', order: order, reviewer: customer)

        expect(review.valid?).to eq false
        expect(review.errors[:comment]).to include("é muito curto (mínimo: 1 caracter)")
      end

      it 'false when comment is longer than 150 characters' do
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
        order = Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: '',
                          desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer, status: 'confirmed')
        Proposal.create!(total_value: 1000, expire_date: '2024-12-30', description: '', discount: '', tax: '', payment_method: 'Pix', order: order)
        review = Review.new(rating: 3, comment: 'Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1Teste1', order: order, reviewer: customer)

        expect(review.valid?).to eq false
        expect(review.errors[:comment]).to include("é muito longo (máximo: 150 caracteres)")
      end
    end
  end
end
