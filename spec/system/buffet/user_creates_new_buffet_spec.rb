require 'rails_helper'

describe 'User creates a new buffet' do
  it 'should be redirected if signed in and user has no buffet registered' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')

    #Act
    login_as(user)
    visit root_path

    #Assert
    expect(current_path).to eq new_buffet_path
    expect(page).to have_content('Você precisa registrar um buffet antes de continuar.')
  end
  
  it 'can create a new buffet successfully' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password')
    
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

    click_on 'Salvar'

    #Assert
    expect(page).to have_content('Buffet registrado com sucesso.')
    expect(page).to have_content('Fantasias & CIA')
    expect(page).to have_content('Sem razão alguma')
    expect(page).to have_content('83.757.309/0001-58')
    expect(page).to have_content('Aqui no Fantasias & CIA realizamos festas juninas, quermesses e festas rave.')
  end
end
