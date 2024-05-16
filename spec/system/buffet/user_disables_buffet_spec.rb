require 'rails_helper'

describe 'User disables their buffet' do
  it 'shouldnt be able to see disabled buffets on home page list' do
    #Arrange
    owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate,
                        contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
    owner2 = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', social_security_number: CPF.generate,
                        contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password', role: 'owner')
    Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner, is_enabled: false, deleted_at: DateTime.current)
    Buffet.create!(trading_name: 'Buffeteria', company_name: 'Buffet festas e cia', registration_number: CNPJ.generate, contact_number: '(11) 91234-5678',
                  email: 'email@buffeteria.com', address: 'Rua das festas, 22', district: 'Bairro Central', city: 'Rio de Janeiro', state: 'RJ',
                  zipcode: '11622091', description: 'Buffet pra festas e atrações', payment_methods: 'Pix', user: owner2)
    
    #Act
    visit root_path

    #Assert
    expect(page).not_to have_content('Nome fantasia')
    expect(page).to have_content('Buffeteria')
  end
  
  it 'shouldnt be able to see disabled buffets when searching a buffet' do
    #Arrange
    owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate,
                        contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
    owner2 = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', social_security_number: CPF.generate,
                        contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password', role: 'owner')
    buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner, is_enabled: false, deleted_at: DateTime.current)
    Buffet.create!(trading_name: 'Buffeteria', company_name: 'Buffet festas e cia', registration_number: CNPJ.generate, contact_number: '(11) 91234-5678',
                  email: 'email@buffeteria.com', address: 'Rua das festas, 22', district: 'Bairro Central', city: 'Rio de Janeiro', state: 'RJ',
                  zipcode: '11622091', description: 'Buffet pra festas e atrações', payment_methods: 'Pix', user: owner2)
    
    #Act
    visit root_path
    fill_in 'Procurar um buffet', with: 'Nome fantasia'
    click_on 'Buscar'

    #Assert
    expect(page).not_to have_link('Nome fantasia', href: buffet_path(buffet))
    expect(page).to have_content('Nenhum resultado encontrado')
  end

  context 'as a customer' do
    it 'shouldnt be able to access a disabled buffet' do
      #Arrange
      owner = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: CNPJ.generate, contact_number: '(12) 91234-5678',
                              email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                              zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: owner, is_enabled: false, deleted_at: DateTime.current)
  
      #Act
      login_as(customer)
      visit buffet_path(buffet)
  
      #Assert
      expect(current_path).to eq root_path
      expect(page).to have_content('Esse buffet foi desativado pelo dono.')
    end
  end

  context 'as a buffet owner' do
    it 'can disable buffet successfully' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      #Act
      login_as(user)
      visit buffets_path(buffet)
      click_on 'Desativar buffet'

      #Assert
      expect(page).to have_content('Você desativou seu buffet com sucesso.')
      expect(page).to have_content('ATENÇÃO - Esse buffet foi desativado em')
      expect(Buffet.first.is_enabled).to eq false
    end

    it 'can re-enable buffet successfully' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user, is_enabled: false, deleted_at: DateTime.current)
      #Act
      login_as(user)
      visit buffets_path(buffet)
      click_on 'Reativar buffet'

      #Assert
      expect(page).to have_content('Você ativou seu buffet com sucesso.')
      expect(page).not_to have_content('ATENÇÃO - Esse buffet foi desativado em')
      expect(Buffet.first.is_enabled).to eq true
    end
  end
end