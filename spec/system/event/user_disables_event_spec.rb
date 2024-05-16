require 'rails_helper'

describe 'User disables an event' do
  it 'shouldnt be able to see disabled events on buffet events page list' do
    #Arrange
    owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate,
                        contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
    buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
    Event.create!(name: 'Eventinho', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                  default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                  can_change_location: true, valet_service: true, buffet: buffet, is_enabled: false, deleted_at: DateTime.current)
    Event.create!(name: 'Festa de 23 anos', description: 'Mais novo evento da app', minimum_participants: 30, maximum_participants: 50,
                  default_duration: 360, menu: 'Bolo doce brigadeiro', alcoholic_drinks: true, decorations: true,
                  can_change_location: false, valet_service: false, buffet: buffet)
    
    #Act
    visit root_path
    click_on 'Nome fantasia'

    #Assert
    expect(page).not_to have_content('Eventinho')
    expect(page).to have_content('Festa de 23 anos')
  end
  
  it 'shouldnt be able to see a buffet when searching a disabled event' do
    #Arrange
    owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate,
                        contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
    buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
    Event.create!(name: 'Eventinho', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                  default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                  can_change_location: true, valet_service: true, buffet: buffet, is_enabled: false, deleted_at: DateTime.current)

    #Act
    visit root_path
    fill_in 'Procurar um buffet', with: 'Eventinho'
    click_on 'Buscar'

    #Assert
    expect(page).not_to have_link('Nome fantasia', href: buffet_path(buffet))
    expect(page).to have_content('Nenhum resultado encontrado')
  end

  context 'as a customer' do
    it 'shouldnt be able to access a disabled event' do
      #Arrange
      owner = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: CNPJ.generate, contact_number: '(12) 91234-5678',
                              email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                              zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: owner)
      event = Event.create!(name: 'Eventinho', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                    default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                    can_change_location: true, valet_service: true, buffet: buffet, is_enabled: false, deleted_at: DateTime.current)
  
      #Act
      login_as(customer)
      visit event_path(event)
  
      #Assert
      expect(current_path).to eq root_path
      expect(page).to have_content('Esse evento foi desativado pelo dono.')
    end
  end

  context 'as a buffet owner' do
    it 'can disable an event successfully' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      event = Event.create!(name: 'Eventinho', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                    default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                    can_change_location: true, valet_service: true, buffet: buffet)

      #Act
      login_as(user)
      visit event_path(event)
      click_on 'Desativar evento'

      #Assert
      expect(page).to have_content('Você desativou seu evento com sucesso.')
      expect(page).to have_content('Desativado em ')
      expect(Event.first.is_enabled).to eq false
    end

    it 'can re-enable an event successfully' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      event = Event.create!(name: 'Eventinho', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                    default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                    can_change_location: true, valet_service: true, buffet: buffet, is_enabled: false, deleted_at: DateTime.current)

      #Act
      login_as(user)
      visit event_path(event)
      click_on 'Reativar evento'

      #Assert
      expect(page).to have_content('Você ativou seu evento com sucesso.')
      expect(page).not_to have_content('ATENÇÃO - Esse evento foi desativado em')
      expect(Event.first.is_enabled).to eq true
    end
  end
end