require 'rails_helper'

describe 'User creates a new buffet' do
  it 'shouldnt be able to access new buffet page if user already has a buffet' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: "01234567890", contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    #Act
    login_as(user)
    visit new_user_buffet_path(user)

    #Assert
    expect(current_path).to eq user_buffets_path(user)
    expect(page).to have_content('Você já tem um buffet registrado.')
  end

  it 'can create a new buffet successfully' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: "01234567890", contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
    
    #Act
    login_as(user)
    visit root_path

    fill_in 'Nome fantasia', with: 'Fantasias & CIA'
    fill_in 'Razão social', with: 'Sem razão alguma'
    fill_in 'CNPJ', with: '83.757.309/0001-58'
    fill_in 'Telefone para contato', with: '(11) 98765-4321'
    fill_in 'E-mail da empresa', with: 'contato@buffet.com'
    fill_in 'Endereço da empresa', with: 'Rua dos Bobos, 0'
    fill_in 'Bairro', with: 'Bairro de Barro'
    fill_in 'Cidade', with: 'São Paulo'
    fill_in 'Estado', with: 'SP'
    fill_in 'CEP', with: '09280880'
    fill_in 'Descrição do buffet', with: 'Aqui no Fantasias & CIA realizamos festas juninas, quermesses e festas rave.'
    fill_in 'Métodos de pagamento', with: 'Pix, Cartão de Crédito'
    attach_file 'Logo do buffet', Rails.root.join('db/images/buffet-rspec.jpg')

    click_on 'Salvar'

    #Assert
    expect(page).to have_content('Buffet registrado com sucesso.')
    expect(page).to have_css('img[src*="buffet-rspec.jpg"]')
    expect(page).to have_content('Fantasias & CIA')
    expect(page).to have_content('Sem razão alguma')
    expect(page).to have_content('83.757.309/0001-58')
    expect(page).to have_content('Aqui no Fantasias & CIA realizamos festas juninas, quermesses e festas rave.')
  end

  it 'shouldnt be able to create a buffet with missing information' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: "01234567890", contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
    
    #Act
    login_as(user)
    visit root_path

    fill_in 'Nome fantasia', with: 'Fantasias & CIA'
    fill_in 'Razão social', with: 'Sem razão alguma'
    fill_in 'CNPJ', with: ''

    #Assert
    expect{click_on 'Salvar'}.to raise_error(ActiveRecord::RecordInvalid)
  end
end
