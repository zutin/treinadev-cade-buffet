require 'rails_helper'

describe 'User signs in using email and password' do
  it 'can sign in successfully' do
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

    #Assert
    expect(page).to have_content('Login efetuado com sucesso.')
    expect(page).to have_content('Gian Lucca')
    expect(page).to have_button('Logout')
  end

  it 'can sign out successfully' do
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

    within('nav#navbar') do
      click_on 'Logout'
    end

    #Assert
    expect(page).to have_content('Logout efetuado com sucesso.')
    expect(page).to have_content('Convidado')
    expect(page).not_to have_button('Logout')
  end
end