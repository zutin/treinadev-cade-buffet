require 'rails_helper'

describe 'User views the home page' do
  it 'should be redirected to login page if not signed in and trying to navigate' do
    #Arrange
    #Act
    visit(user_index_path)
    #Assert
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'can see the home page content and navigation bar' do
    #Arrange
    #Act
    visit root_path

    #Assert
    within('div#carousel') do
      expect(page).to have_content('Cadê Buffet')
    end
    
    within('div#user_dropdown') do
      expect(page).to have_content('Login')
    end
  end

  it 'can see buffet list in home page without signing in' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')
    user2 = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password')
    user3 = User.create!(username: 'lucas', full_name: 'Lucas Felipe', contact_number: '(12) 94545-4545', email: 'lucas@felipe.com', password: 'password')

    buffet1 = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    buffet2 = Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: '43.521.735/0001-79', contact_number: '(12) 91234-5678',
                  email: 'diversao@buffet2.com', address: 'Rua das Flores, 1', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                  zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: user2)

    buffet3 = Buffet.create!(trading_name: 'Vegas Buffet', company_name: 'Razões confidenciais', registration_number: '71.123.456/0001-32', contact_number: '(11) 94356-9418',
                  email: 'animado@buffet3.com', address: 'Rua da Alegria, 2', district: 'Jardim Primavera', city: 'Belo Horizonte', state: 'MG',
                  zipcode: '45678901', description: 'Buffet super animado e único', payment_methods: 'Cartão de Débito, Cartão de Crédito', user: user3)

    #Act
    visit root_path

    #Assert
    expect(page).to have_link('Fantasias & CIA', href: buffet_path(buffet1))
    expect(page).to have_link('Alegria para o mundo', href: buffet_path(buffet2))
    expect(page).to have_link('Vegas Buffet', href: buffet_path(buffet3))
  end
end