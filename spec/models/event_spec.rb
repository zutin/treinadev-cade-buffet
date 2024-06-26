require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when event name is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: '', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:name]).to include("não pode ficar em branco")
      end

      it 'false when event description is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: '', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:description]).to include("não pode ficar em branco")
      end

      it 'false when minimum participants is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:minimum_participants]).to include("não pode ficar em branco")
      end

      it 'false when maximum participants is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:maximum_participants]).to include("não pode ficar em branco")
      end

      it 'false when event duration is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:default_duration]).to include("não pode ficar em branco")
      end

      it 'false when food menu is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: '', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:menu]).to include("não pode ficar em branco")
      end

      it 'false when buffet association is missing' do
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true)
        
        expect(event.valid?).to eq false
        expect(event.errors[:buffet]).to include("é obrigatório(a)")
      end
    end
    
    context 'inclusion' do
      it 'false when alcoholic drinks is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:alcoholic_drinks]).to include("não está incluído na lista")
      end

      it 'false when decorations is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:decorations]).to include("não está incluído na lista")
      end

      it 'false when valet service is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:valet_service]).to include("não está incluído na lista")
      end

      it 'false when information about event location is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:can_change_location]).to include("não está incluído na lista")
      end
    end

    context 'numericality' do
      it 'false when minimum participants is less than zero' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 0, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          valet_service: true, can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:minimum_participants]).to include("deve ser maior que 0")
      end

      it 'false when maximum participants is less than zero' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 0,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          valet_service: true, can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:maximum_participants]).to include("deve ser maior que 0")
      end

      it 'false when event default duration is less than zero' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 0, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          valet_service: true, can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:default_duration]).to include("deve ser maior que 0")
      end

      it 'false when maximum participants is less than minimum participants' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 9,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          valet_service: true, can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:maximum_participants]).to include("não pode ser menor que a quantidade mínima de participantes.")
      end
    end

    context 'length' do
      it 'false when name is shorter than 5 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Even', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          valet_service: true, can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:name]).to include("é muito curto (mínimo: 5 caracteres)")
      end

      it 'false when name is longer than 80 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'EventEventEventEventEventEventEventEventEventEventEventEventEventEventEventEventE', description: 'Super evento',
                          minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          valet_service: true, can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:name]).to include("é muito longo (máximo: 80 caracteres)")
      end

      it 'false when description is shorter than 5 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Supp', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          valet_service: true, can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:description]).to include("é muito curto (mínimo: 5 caracteres)")
      end

      it 'false when description is longer than 160 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'SuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperSuperr',
                          minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          valet_service: true, can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:description]).to include("é muito longo (máximo: 160 caracteres)")
      end

      it 'false when menu is shorter than 5 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arrz', alcoholic_drinks: false, decorations: true,
                          valet_service: true, can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:menu]).to include("é muito curto (mínimo: 5 caracteres)")
      end

      it 'false when menu is longer than 160 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'ArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozArrozarrozz',
                          alcoholic_drinks: false, decorations: true,
                          valet_service: true, can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
        expect(event.errors[:menu]).to include("é muito longo (máximo: 160 caracteres)")
      end
    end
  end
end
