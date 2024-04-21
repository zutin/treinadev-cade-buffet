require 'rails_helper'

RSpec.describe EventPrice, type: :model do
  describe '#valid?' do
    before :each do
      @user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
      @buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: @user)
      @event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: @buffet)
    end

    context 'presence' do
      it 'false when base price is missing' do
        ep = EventPrice.new(additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                            event: @event)
        
        expect(ep.valid?).to eq false
      end

      it 'false when additional person price is missing' do
        ep = EventPrice.new(base_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                            event: @event)
        
        expect(ep.valid?).to eq false
      end

      it 'false when additional hour price is missing' do
        ep = EventPrice.new(base_price: 10, additional_person_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                            event: @event)
        
        expect(ep.valid?).to eq false
      end

      it 'false when weekend base price is missing' do
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 10,
                            weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                            event: @event)
        
        expect(ep.valid?).to eq false
      end

      it 'false when weekend additional person price is missing' do
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_hour_price: 20, 
                            event: @event)
        
        expect(ep.valid?).to eq false
      end

      it 'false when weekend additional hour price is missing' do
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, event: @event)
        
        expect(ep.valid?).to eq false
      end

      it 'false when event association is missing' do
        ep = EventPrice.new(base_price: 10, additional_person_price: 10, additional_hour_price: 10,
                            weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20)
        
        expect(ep.valid?).to eq false
      end
    end
  end
end
