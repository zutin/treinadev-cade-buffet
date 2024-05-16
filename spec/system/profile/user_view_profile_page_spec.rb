require 'rails_helper'

describe 'User access a profile page' do
  context 'as a guest' do
    it 'should be redirected if not signed in' do
      #Arrange
      #Act
      visit(user_index_path)
      #Assert
      expect(page).to have_content('Para continuar, faça login ou registre-se.')
    end
  end

  context 'as a buffet owner' do
    it 'can see their buffet information along with the account information correctly' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
  
      buffet = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
  
      #Act
      login_as(user)
      visit user_index_path
  
      #Assert
      expect(page).to have_content('Fantasias & CIA')
      expect(page).to have_content('Sem razão alguma')
      expect(page).to have_content(CNPJ.new(buffet.registration_number).formatted)
      expect(page).to have_content('(11) 99876-5432')
      expect(page).to have_content('buffet@contato.com')
    end
  end

  it 'can access the profile page from the user dropdown menu' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')

    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
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
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')

    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    #Act
    login_as(user)
    visit user_index_path

    #Assert
    expect(page).to have_content('Gian Lucca')
    expect(page).to have_content('@lucca')
    expect(page).to have_content('(12) 98686-8686')
    expect(page).to have_content('gian@lucca.com')
  end

  it 'can access another user profile page' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
    second_user = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', social_security_number: CPF.generate, contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password', role: 'owner')

    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
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