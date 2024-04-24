require 'rails_helper'

describe 'User views buffet information' do
  it 'can access the buffet information page from the navigation bar' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')

    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    #Act
    login_as(user)
    visit root_path

    within('div#user_dropdown') do
      click_on 'Meu Buffet'
    end

    #Assert
    expect(current_path).to eq user_buffets_path(user)
  end

  it 'can see their buffet information correctly' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')

    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    #Act
    login_as(user)
    visit root_path

    within('div#user_dropdown') do
      click_on 'Meu Buffet'
    end

    #Assert
    expect(page).to have_content('Fantasias & CIA')
    expect(page).to have_content('Sem razão alguma')
    expect(page).to have_content('83.757.309/0001-58')
  end

  it 'can see a buffet information from the home page' do
    #Arrange
    User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')

    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: User.first)
    
    #Act
    visit root_path
    click_on 'Fantasias & CIA'

    #Assert
    expect(current_path).to eq buffet_path(Buffet.first)
    expect(page).not_to have_content('Sem razão alguma')
    expect(page).to have_content('Fantasias & CIA')
    expect(page).to have_content('83.757.309/0001-58')
    expect(page).to have_content('buffet@contato.com')
  end
end