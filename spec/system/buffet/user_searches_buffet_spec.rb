require 'rails_helper'

describe 'User searches a buffet' do
  it 'can see the search bar in the navigation bar correctly' do
    #Arrange
    #Act
    visit root_path
    #Assert
    within('div#search') do
      expect(page).to have_field('Procurar um buffet')
      expect(page).to have_button('Buscar')
    end
  end

  it 'can search for a buffet name and find one result' do
    #Arrange
    User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686',
                email: 'gian@lucca.com', password: 'password', role: 'owner')
    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: User.first)
    Buffet.first.buffet_logo.attach(File.open(Rails.root.join("db/images/buffet-rspec.jpg")))
    #Act
    visit root_path
    fill_in 'Procurar um buffet', with: 'Fantasias & CIA'
    click_on 'Buscar'

    #Assert
    expect(page).to have_content("Resultados da busca 'Fantasias & CIA'")
    expect(page).to have_content("1 buffet encontrado")
    expect(page).to have_css('img[src*="buffet-rspec.jpg"]')
    expect(page).to have_link('Fantasias & CIA', href: buffet_path(Buffet.first))
  end

  it 'can search for a buffet name and find multiple results' do
    #Arrange
    user1 = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686',
                email: 'gian@lucca.com', password: 'password', role: 'owner')
    buffet1 = Buffet.create!(trading_name: 'Buffet dos Anjos', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user1)
    buffet1.buffet_logo.attach(File.open(Rails.root.join("db/images/buffet-rspec.jpg")))

    user2 = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', social_security_number: CPF.generate, contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password', role: 'owner')
    buffet2 = Buffet.create!(trading_name: 'Buffet dos Anjos', company_name: 'Razões muito especificas', registration_number: CNPJ.generate, contact_number: '(12) 91234-5678',
                  email: 'diversao@buffet2.com', address: 'Rua das Flores, 1', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                  zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: user2)
    buffet2.buffet_logo.attach(File.open(Rails.root.join("db/images/buffet0.jpg")))

    user3 = User.create!(username: 'lucas', full_name: 'Lucas Felipe', social_security_number: CPF.generate, contact_number: '(12) 94545-4545', email: 'lucas@felipe.com', password: 'password', role: 'owner')
    buffet3 = Buffet.create!(trading_name: 'Vegas Buffet', company_name: 'Razões confidenciais', registration_number: CNPJ.generate, contact_number: '(11) 94356-9418',
                            email: 'animado@buffet3.com', address: 'Rua da Alegria, 2', district: 'Jardim Primavera', city: 'Belo Horizonte', state: 'MG',
                            zipcode: '45678901', description: 'Buffet super animado e único', payment_methods: 'Cartão de Débito, Cartão de Crédito', user: user3)

    #Act
    visit root_path
    fill_in 'Procurar um buffet', with: 'Buffet dos Anjos'
    click_on 'Buscar'

    #Assert
    expect(page).to have_content("Resultados da busca 'Buffet dos Anjos'")
    expect(page).to have_content("2 buffets encontrados")
    expect(page).to have_css('img[src*="buffet-rspec.jpg"]')
    expect(page).to have_link('Buffet dos Anjos', href: buffet_path(buffet1))
    expect(page).to have_css('img[src*="buffet0.jpg"]')
    expect(page).to have_link('Buffet dos Anjos', href: buffet_path(buffet2))
    expect(page).not_to have_css('img[src*="default-buffet"]')
    expect(page).not_to have_link('Vegas Buffet', href: buffet_path(buffet3))
  end

  it 'can search for an event name and find the event buffet' do
    #Arrange
    User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686',
                email: 'gian@lucca.com', password: 'password', role: 'owner')
    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: User.first)
    Event.create!(name: 'Festa de 21 anos', description: 'Super eventinho', minimum_participants: 10, maximum_participants: 20,
                  default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                  can_change_location: false, valet_service: true, buffet: Buffet.first)
    #Act
    visit root_path
    fill_in 'Procurar um buffet', with: 'Festa de 21 anos'
    click_on 'Buscar'

    #Assert
    expect(page).to have_content("Resultados da busca 'Festa de 21 anos'")
    expect(page).to have_content("1 buffet encontrado")
    expect(page).to have_css('img[src*="default-buffet"]')
    expect(page).to have_link('Fantasias & CIA', href: buffet_path(Buffet.first))
  end

  it 'should receive an alert when no buffet was found' do
    #Arrange#Act
    visit root_path
    fill_in 'Procurar um buffet', with: 'Buffet dos Anjos'
    click_on 'Buscar'

    #Assert
    expect(page).to have_content("Nenhum resultado encontrado")
  end
end