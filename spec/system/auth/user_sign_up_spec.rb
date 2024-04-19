require 'rails_helper'

describe 'User signs up' do
  it 'should be redirected to new buffet page after signing up' do
    #Arrange
    #Act
    visit root_path
    within('nav#navbar') do
      click_on 'Login'
    end
    click_on 'Cadastrar-se'

    fill_in 'Usuário', with: 'lucca'
    fill_in 'Nome completo', with: 'Gian Lucca'
    fill_in 'Telefone para contato', with: '(12) 98765-4321'
    fill_in 'E-mail', with: 'gian@lucca.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Cadastrar'

    #Assert
    expect(current_path).to eq new_buffet_path
  end

  it 'can sign up successfully' do
    #Arrange
    #Act
    visit root_path
    within('nav#navbar') do
      click_on 'Login'
    end
    click_on 'Cadastrar-se'

    fill_in 'Usuário', with: 'lucca'
    fill_in 'Nome completo', with: 'Gian Lucca'
    fill_in 'Telefone para contato', with: '(12) 98765-4321'
    fill_in 'E-mail', with: 'gian@lucca.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Cadastrar'

    #Assert
    expect(page).to have_content('Você realizou seu registro com sucesso.')
    expect(page).to have_content('Gian Lucca')
  end

  it 'shouldnt be able to sign up with an already in use parameter' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')

    #Act
    visit root_path
    within('nav#navbar') do
      click_on 'Login'
    end
    click_on 'Cadastrar-se'

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
    visit root_path
    within('nav#navbar') do
      click_on 'Login'
    end
    click_on 'Cadastrar-se'

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