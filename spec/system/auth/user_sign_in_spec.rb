require 'rails_helper'

describe 'User signs in using email and password' do
  it 'should see errors when login information is wrong' do
    #Arrange
    User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: "01234567890", contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')

    #Act
    visit root_path
    
    within('div#user_dropdown') do
      click_on 'Conta'
      click_on 'Login'
    end

    fill_in 'E-mail', with: 'gian@lucca.com'
    fill_in 'Senha', with: 'fakepassword'
    click_on 'Entrar'

    #Assert
    expect(page).to have_content('E-mail ou senha inválidos.')
    within('div#user_dropdown') do
      expect(page).not_to have_content('Gian Lucca')
    end
  end

  it 'should be redirected after signing in if there is no buffet registered' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: "01234567890", contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')

    #Act
    login_as(user)
    visit root_path

    #Assert
    expect(current_path).to eq new_user_buffet_path(user)
    expect(page).to have_content('Você precisa registrar um buffet antes de continuar.')
  end

  it 'can sign in successfully' do
    #Arrange
    User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: "01234567890", contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')

    #Act
    visit root_path
    
    within('div#user_dropdown') do
      click_on 'Conta'
      click_on 'Login'
    end

    fill_in 'E-mail', with: 'gian@lucca.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'

    #Assert
    expect(page).to have_content('Login efetuado com sucesso.')
    within('div#user_dropdown') do
      expect(page).not_to have_content('Convidado')
      expect(page).to have_content('Gian Lucca')
      expect(page).to have_button('Sair')
    end
  end

  it 'can sign out successfully' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: "01234567890", contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')

    #Act
    login_as(user)
    visit root_path

    within('div#user_dropdown') do
      click_on 'Sair'
    end

    #Assert
    expect(page).to have_content('Logout efetuado com sucesso.')
    within('div#user_dropdown') do
      expect(page).not_to have_content('Gian Lucca')
      expect(page).to have_content('Convidado')
      expect(page).to have_content('Login')
    end
  end
end