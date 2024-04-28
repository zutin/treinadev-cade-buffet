require 'rails_helper'

describe 'User access a profile page' do
  it 'should be redirected if not signed in' do
    #Arrange
    #Act
    visit(user_index_path)
    #Assert
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'can access the the profile page from the navigation bar' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: "01234567890", contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')

    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    #Act
    login_as(user)
    visit root_path

    within('div#user_dropdown') do
      click_on 'Perfil'
    end

    #Assert
    expect(current_path).to eq user_index_path
  end

  it 'can see their own account information correctly' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: "01234567890", contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')

    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    #Act
    login_as(user)
    visit user_index_path

    #Assert
    expect(page).to have_content('Gian Lucca')
    expect(page).to have_content('@lucca')
    expect(page).to have_field('Número para contato:', with: '(12) 98686-8686', disabled: true)
    expect(page).to have_field('E-mail:', with: 'gian@lucca.com', disabled: true)
  end

  it 'can access another user profile page' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: "01234567890", contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
    second_user = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', social_security_number: "14355855007", contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password', role: 'owner')

    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    #Act
    login_as(user)
    visit user_path(second_user)

    #Assert
    expect(page).to have_content('Wladimir Souza')
    expect(page).to have_content('@wladimir')
  end
end