require 'rails_helper'

describe 'User access a profile page' do
  it 'can access its own profile page' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')

    #Act
    visit root_path
    
    within('nav#navbar') do
      click_on 'Login'
    end

    fill_in 'E-mail', with: 'gian@lucca.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'

    visit users_path

    #Assert
    expect(page).to have_content('Gian Lucca')
    expect(page).to have_content('@lucca')
    expect(page).to have_content('(12) 98686-8686')
    expect(page).to have_content('gian@lucca.com')
  end

  it 'can access another user profile page' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')
    second_user = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password')

    #Act
    visit root_path
    
    within('nav#navbar') do
      click_on 'Login'
    end

    fill_in 'E-mail', with: 'gian@lucca.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'

    visit user_path(second_user)

    #Assert
    expect(page).to have_content('Visualizando o usuário @wladimir')
    expect(page).to have_content('Nome: Wladimir Souza')
  end

  it 'will receive an alert when accessing profile page without signing in' do
    #Arrange
    #Act
    visit users_path

    #Assert
    expect(page).to have_content('Você não está autenticado!')
  end
end