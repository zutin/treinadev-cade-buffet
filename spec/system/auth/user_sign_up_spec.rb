require 'rails_helper'

describe 'User signs up' do
  it 'should be redirected to new buffet page after signing up' do
    #Arrange
    #Act
    visit new_user_registration_path

    choose(option: 'owner')
    fill_in 'Usuário', with: 'lucca'
    fill_in 'Nome completo', with: 'Gian Lucca'
    fill_in 'Telefone para contato', with: '(12) 98765-4321'
    fill_in 'E-mail', with: 'gian@lucca.com'
    fill_in 'CPF', with: '01234567890'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Cadastrar'

    #Assert
    expect(page).to have_content('Você precisa registrar um buffet antes de continuar.')
    expect(current_path).to eq new_user_buffet_path(User.first)
  end

  it 'can sign up as a customer successfully' do
    #Arrange
    #Act
    visit root_path
    within('div#user_dropdown') do
      click_on 'Conta'
      click_on 'Login'
    end
    click_on 'Cadastrar-se'

    choose(option: 'customer')
    fill_in 'Usuário', with: 'lucca'
    fill_in 'Nome completo', with: 'Gian Lucca'
    fill_in 'CPF', with: '01234567890'
    fill_in 'Telefone para contato', with: '(12) 98765-4321'
    fill_in 'E-mail', with: 'gian@lucca.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Cadastrar'

    #Assert
    expect(page).to have_content('Você realizou seu registro com sucesso.')
    within('div#user_dropdown') do
      expect(page).to have_content('Gian Lucca')
    end
  end

  it 'can sign up as a buffet owner successfully' do
    #Arrange
    #Act
    visit root_path
    within('div#user_dropdown') do
      click_on 'Conta'
      click_on 'Login'
    end
    click_on 'Cadastrar-se'

    choose(option: 'owner')
    fill_in 'Usuário', with: 'lucca'
    fill_in 'Nome completo', with: 'Gian Lucca'
    fill_in 'CPF', with: '01234567890'
    fill_in 'Telefone para contato', with: '(12) 98765-4321'
    fill_in 'E-mail', with: 'gian@lucca.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Cadastrar'

    #Assert
    expect(page).to have_content('Você precisa registrar um buffet antes de continuar.')
    within('div#user_dropdown') do
      expect(page).to have_content('Gian Lucca')
    end
  end

  it 'shouldnt be able to sign up with an already in use parameter' do
    #Arrange
    User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: "01234567890", contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')

    #Act
    visit new_user_registration_path

    fill_in 'Usuário', with: 'lucca'
    fill_in 'Nome completo', with: 'Wladimir Souza'
    fill_in 'Telefone para contato', with: '(11) 91234-5678'
    fill_in 'E-mail', with: 'gian@lucca.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Cadastrar'

    #Assert
    expect(page).to have_content('Não foi possível salvar usuário:')
    expect(page).to have_content('já está em uso')
  end

  it 'shouldnt be able to sign up with a missing parameter' do
    #Arrange
    #Act
    visit new_user_registration_path

    fill_in 'Usuário', with: 'lucca'
    fill_in 'Nome completo', with: ''
    fill_in 'Telefone para contato', with: '(12) 98765-4321'
    fill_in 'E-mail', with: 'gian@lucca.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Cadastrar'

    #Assert
    expect(page).to have_content('Não foi possível salvar usuário:')
    expect(page).to have_content('não pode ficar em branco')
  end
end