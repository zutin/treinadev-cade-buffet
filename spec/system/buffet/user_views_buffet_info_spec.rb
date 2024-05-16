require 'rails_helper'

describe 'User views buffet information' do
  context 'as a buffet owner' do
    it 'can access the buffet information page from the user dropdown menu' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
  
      Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
  
      #Act
      login_as(user)
      visit root_path
  
      within('div#user_dropdown') do
        click_on 'Meu Buffet'
      end
  
      #Assert
      expect(current_path).to eq buffets_path
    end

    it 'can access the buffet information page from the navigation bar' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
  
      Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
  
      #Act
      login_as(user)
      visit root_path
  
      within('div#hotbar') do
        click_on 'Meu Buffet'
      end
  
      #Assert
      expect(current_path).to eq buffets_path
    end

    it 'can see their buffet full information from the navigation bar' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
  
      buffet = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      buffet.buffet_logo.attach(File.open(Rails.root.join("db/images/buffet-rspec.jpg")))
  
      #Act
      login_as(user)
      visit root_path
  
      within('div#user_dropdown') do
        click_on 'Meu Buffet'
      end
  
      #Assert
      expect(page).to have_css('img[src*="buffet-rspec.jpg"]')
      expect(page).to have_content('Fantasias & CIA')
      expect(page).to have_content('Sem razão alguma')
      expect(page).to have_content(CNPJ.new(buffet.registration_number).formatted)
    end
  end

  it 'can see a buffet public information and its events from the home page' do
    #Arrange
    User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')

    buffet = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: User.first)
    
    event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                  default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                  can_change_location: true, valet_service: true, buffet: buffet)
    event.event_logo.attach(File.open(Rails.root.join("db/images/event-rspec.jpg")))

    EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
                  weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                  event: event)

    #Act
    visit root_path
    click_on 'Fantasias & CIA'

    #Assert
    expect(current_path).to eq buffet_path(buffet)
    expect(page).not_to have_content('Sem razão alguma')
    expect(page).to have_css('img[src*="event-rspec.jpg"]')
    expect(page).to have_content('Fantasias & CIA')
    expect(page).to have_content('Festa de 21 anos')
    within("div#event_#{event.id}_prices") do
      expect(page).to have_content('Preço base: R$ 100')
      expect(page).to have_content('Pessoa adicional: R$ 10')
      expect(page).to have_content('Hora adicional: R$ 10')
    end
    within("div#event_#{event.id}_weekend_prices") do
      expect(page).to have_content('Preço base: R$ 200')
      expect(page).to have_content('Pessoa adicional: R$ 20')
      expect(page).to have_content('Hora adicional: R$ 20')
    end
  end
end