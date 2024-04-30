require 'rails_helper'

describe 'User views their buffet events' do
  it 'can access the buffet events from the view buffet page' do
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

    click_on 'Eventos do buffet'

    #Assert
    expect(current_path).to eq events_path
  end

  it 'can see their buffet events correctly' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')

    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    event1 = Event.create!(name: 'Festa de 21 anos', description: 'Super eventinho', minimum_participants: 10, maximum_participants: 20,
    default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
    can_change_location: false, valet_service: true, buffet: user.buffet)
    event1.event_logo.attach(File.open(Rails.root.join("db/images/event-rspec.jpg")))

    event2 = Event.create!(name: 'Quermesse', description: 'Pra todos os publicos', minimum_participants: 200, maximum_participants: 400,
    default_duration: 300, menu: 'Milho, pipoca, hotdog', alcoholic_drinks: false, decorations: true,
    can_change_location: false, valet_service: false, buffet: user.buffet)
    
    #Act
    login_as(user)
    visit events_path

    #Assert
    expect(page).to have_css('img[src*="event-rspec.jpg"]')
    expect(page).to have_content('Festa de 21 anos')
    expect(page).to have_content('Super eventinho')
    expect(page).to have_content('De 10 a 20 pessoas')
    expect(page).to have_content('120 minutos')
    expect(page).to have_link('Ver mais', href: event_path(event1))

    expect(page).to have_css('img[src*="default-event"]')
    expect(page).to have_content('Quermesse')
    expect(page).to have_content('Pra todos os publicos')
    expect(page).to have_content('De 200 a 400 pessoas')
    expect(page).to have_content('300 minutos')
    expect(page).to have_link('Ver mais', href: event_path(event2))
  end

  it 'can see more information about an event from the buffet events page' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')

    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
    default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
    can_change_location: false, valet_service: true, buffet: user.buffet)
    
    #Act
    login_as(user)
    visit events_path
    click_on 'Ver mais'

    #Arrange
    expect(page).to have_content('Festa de 21 anos')
    expect(page).to have_content('Descrição do evento: Esse evento cobre som, iluminação e bebidas')
    expect(page).to have_content('Mínimo de participantes: 10')
    expect(page).to have_content('Duração padrão: 120 minutos')
    expect(page).to have_content('Esse evento não possui bebidas alcoólicas.')
    expect(page).to have_content('Esse evento só pode ser realizado nos espaços do buffet.')
  end
end