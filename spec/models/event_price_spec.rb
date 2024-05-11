require 'rails_helper'

RSpec.describe EventPrice, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when base price is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                            event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:base_price]).to include("não pode ficar em branco")
      end

      it 'false when additional person price is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                            event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:additional_person_price]).to include("não pode ficar em branco")
      end

      it 'false when additional hour price is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 10, additional_person_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                            event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:additional_hour_price]).to include("não pode ficar em branco")
      end

      it 'false when weekend base price is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 10,
                            weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                            event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:weekend_base_price]).to include("não pode ficar em branco")
      end

      it 'false when weekend additional person price is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_hour_price: 20, 
                            event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:weekend_additional_person_price]).to include("não pode ficar em branco")
      end

      it 'false when weekend additional hour price is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:weekend_additional_hour_price]).to include("não pode ficar em branco")
      end

      it 'false when event association is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:event]).to include("é obrigatório(a)")
      end
    end

    context 'numericality' do
      it 'false when base price is less than zero' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 0, additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:base_price]).to include("deve ser maior que 0")
      end

      it 'false when additional person price is less than zero' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 10, additional_person_price: 0, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:additional_person_price]).to include("deve ser maior que 0")
      end

      it 'false when additional hour price is less than zero' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 0,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:additional_hour_price]).to include("deve ser maior que 0")
      end

      it 'false when weekend base price is less than zero' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 0, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:weekend_base_price]).to include("deve ser maior que 0")
      end

      it 'false when weekend additional person price is less than zero' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 0, weekend_additional_hour_price: 20, event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:weekend_additional_person_price]).to include("deve ser maior que 0")
      end

      it 'false when weekend additional hour price is less than zero' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                              default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                              can_change_location: true, valet_service: true, buffet: buffet)
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 0, event: event)
        
        expect(ep.valid?).to eq false
        expect(ep.errors[:weekend_additional_hour_price]).to include("deve ser maior que 0")
      end
    end
  end
end
