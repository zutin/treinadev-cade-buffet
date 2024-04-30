require 'rails_helper'

describe 'User creates a new event for their buffet' do
  it 'should be redirected if not signed in' do
    #Arrange
    #Act
    visit(new_event_path)
    #Assert
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'can access the new event form from the buffet information page' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

    #Act
    login_as(user)
    visit root_path

    within('div#user_dropdown') do
      click_on 'Meu Buffet'
    end

    click_on 'Criar novo evento'

    #Assert
    expect(current_path).to eq new_event_path
  end

  it 'can create a new event successfully' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
    
    #Act
    login_as(user)
    visit new_event_path

    fill_in 'Nome do evento', with: 'Festa de 21 anos'
    fill_in 'Descrição do evento', with: 'Esse evento cobre som, iluminação e bebidas'
    fill_in 'Mínimo de participantes', with: 10
    fill_in 'Máximo de participantes', with: 20
    fill_in 'Duração padrão', with: 120
    fill_in 'Cardápio', with: 'Casquinha de siri, casquinha de sorvete e casquinha de bala'
    check 'Bebidas alcoólicas'
    check 'Decorações'
    check 'Serviço de estacionamento'
    check 'Localização única'
    attach_file 'Logo do evento', Rails.root.join('db/images/event-rspec.jpg')

    click_on 'Salvar'

    #Assert
    expect(page).to have_content('Evento cadastrado com sucesso!')
    expect(page).to have_content('Festa de 21 anos')
    expect(page).to have_content('Descrição do evento: Esse evento cobre som, iluminação e bebidas')
  end

  it 'shouldnt be able to create an event with missing information' do
    #Arrange
    user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
    Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
    
    #Act
    login_as(user)
    visit new_event_path

    fill_in 'Nome do evento', with: 'Festa de 21 anos'
    fill_in 'Descrição do evento', with: ''

    #Assert
    expect{click_on 'Salvar'}.to raise_error(ActiveRecord::RecordInvalid)
  end
end