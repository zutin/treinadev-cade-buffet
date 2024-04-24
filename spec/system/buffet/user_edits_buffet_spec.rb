require 'rails_helper'

describe 'User edits their buffet' do
  it 'should be redirected if trying to edit another user buffet' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')
    second_user = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password')

    buffet = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    buffet2 = Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: '43.521.735/0001-79', contact_number: '(12) 91234-5678',
                  email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                  zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: second_user)

    #Act
    login_as(user)
    visit edit_user_buffet_path(second_user, buffet2)

    #Assert
    expect(current_path).to eq user_buffets_path(user)
    expect(page).to have_content('Você não pode editar o buffet de outro usuário.')
  end

  it 'can access the edit buffet form from the view buffet info page' do
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

    click_on 'Editar informações'

    #Assert
    expect(current_path).to eq edit_user_buffet_path(user, user.buffet)
    expect(page).to have_field('Nome fantasia', with: 'Fantasias & CIA')
    expect(page).to have_field('Razão social', with: 'Sem razão alguma')
    expect(page).to have_field('CNPJ', with: '83.757.309/0001-58')
  end

  it 'can edit buffet successfully' do
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

    click_on 'Editar informações'

    fill_in 'Nome fantasia', with: 'Fantasioso super nome'
    fill_in 'Razão social', with: 'Socialmente temos razão'
    fill_in 'CNPJ', with: '11.222.333/0001-44'

    click_on 'Salvar'

    #Assert
    expect(page).to have_content('Você editou seu buffet com sucesso.')
    expect(page).to have_content('Fantasioso super nome')
    expect(page).to have_content('Socialmente temos razão')
    expect(page).to have_content('11.222.333/0001-44')
  end

  it 'shouldnt be able to edit buffet with missing information' do
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

    click_on 'Editar informações'

    fill_in 'Nome fantasia', with: ''
    fill_in 'Razão social', with: 'Socialmente temos razão'
    fill_in 'CNPJ', with: '11.222.333/0001-44'

    #Assert
    expect{click_on 'Salvar'}.to raise_error(ActiveRecord::RecordInvalid)
  end
end