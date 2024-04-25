require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when event name is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        event = Event.new(name: '', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
      end

      it 'false when event description is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        event = Event.new(name: 'Evento', description: '', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
      end

      it 'false when minimum participants is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        event = Event.new(name: 'Evento', description: 'Super evento', maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
      end

      it 'false when maximum participants is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
      end

      it 'false when event duration is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
      end

      it 'false when food menu is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: '', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
      end

      it 'false when alcoholic drinks is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', decorations: true,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
      end

      it 'false when decorations is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false,
                          can_change_location: true, valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
      end

      it 'false when valet service is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, buffet: buffet)
        
        expect(event.valid?).to eq false
      end

      it 'false when information about event location is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
        buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          valet_service: true, buffet: buffet)
        
        expect(event.valid?).to eq false
      end

      it 'false when buffet association is missing' do
        event = Event.new(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                          default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                          can_change_location: true, valet_service: true)
        
        expect(event.valid?).to eq false
      end
    end
  end
end
