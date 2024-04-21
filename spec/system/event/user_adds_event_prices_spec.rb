require 'rails_helper'

describe 'User adds prices to their event' do
  it 'should be redirected to buffet events page when trying to edit another user event' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')
    second_user = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password')

    buffet = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
    buffet2 = Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: '43.521.735/0001-79', contact_number: '(12) 91234-5678',
                  email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                  zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: second_user)

    event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                  default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                  can_change_location: false, valet_service: true, buffet: second_user.buffet)
    
    #Act
    login_as(user)
    visit new_event_event_price_path(event)

    #Assert
    expect(current_path).to eq events_path
    expect(page).to have_content('Você não pode editar eventos de outro usuário')
  end

  it "should see an alert if event has no prices set" do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')
    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
    event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                  default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                  can_change_location: false, valet_service: true, buffet: user.buffet)
    
    #Act
    login_as(user)
    visit events_path

    #Assert
    expect(page).to have_content('Festa de 21 anos')
    expect(page).to have_content('Evento sem preços!')
    expect(page).to have_link('Adicionar preços', href: new_event_event_price_path(event))
  end

  it "can access the add event prices page from the events list" do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')
    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
    event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                  default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                  can_change_location: false, valet_service: true, buffet: user.buffet)
    
    #Act
    login_as(user)
    visit events_path
    click_on 'Adicionar preços'

    #Assert
    expect(page).to have_field('Preço base')
    expect(page).to have_field('Hora adicional')
    expect(page).to have_field('Pessoa adicional')
    within('div#weekend_prices') do
      expect(page).to have_field('Preço base')
      expect(page).to have_field('Hora adicional')
      expect(page).to have_field('Pessoa adicional')
    end
  end

  it 'can add prices to their event successfully' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')
    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
    event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                  default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                  can_change_location: false, valet_service: true, buffet: user.buffet)
    
    #Act
    login_as(user)
    visit new_event_event_price_path(event)

    within('div#prices') do
      fill_in 'Preço base', with: 1000
      fill_in 'Hora adicional', with: 250
      fill_in 'Pessoa adicional', with: 200
    end

    within('div#weekend_prices') do
      fill_in 'Preço base', with: 2000
      fill_in 'Hora adicional', with: 500
      fill_in 'Pessoa adicional', with: 400
    end

    click_on 'Salvar'

    #Assert
    expect(page).to have_content('Preços foram salvos com sucesso!')
    expect(page).to have_content('Preço base (20 participantes): 1000')
    expect(page).not_to have_content('Evento sem preços!')
  end

  it 'shouldnt be able to save event prices if there is missing information' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')
    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
    event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                  default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                  can_change_location: false, valet_service: true, buffet: user.buffet)
    
    #Act
    login_as(user)
    visit new_event_event_price_path(event)

    within('div#prices') do
      fill_in 'Preço base', with: 2000
    end

    #Assert
    expect{click_on 'Salvar'}.to raise_error(ActiveRecord::RecordInvalid)
  end
end