require 'rails_helper'

describe 'User edits their buffet' do
  context 'as a guest' do
    it 'should be redirected if not signed in' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
      email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
      zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

      #Act
      visit edit_buffet_path(buffet)
      #Assert
      expect(page).to have_content('Para continuar, faça login ou registre-se.')
    end
  end

  context 'as a customer' do
    it 'should be redirected when trying to access edit buffet page as a customer' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'customer')
      second_user = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', social_security_number: CPF.generate, contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                  email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                  zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: second_user)
      #Act
      login_as(user)
      visit edit_buffet_path(buffet)
  
      #Assert
      expect(current_path).to eq root_path
      expect(page).to have_content('Você não tem acesso à essa página.')
    end
  end

  context 'as a buffet owner' do
    it 'should be redirected if trying to edit another user buffet' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      second_user = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', social_security_number: CPF.generate, contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password', role: 'owner')
  
      Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
  
      buffet2 = Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: CNPJ.generate, contact_number: '(12) 91234-5678',
                    email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                    zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: second_user)
  
      #Act
      login_as(user)
      visit edit_buffet_path(buffet2)
  
      #Assert
      expect(current_path).to eq buffets_path
      expect(page).to have_content('Você não pode editar o buffet de outro usuário.')
    end
  
    it 'can access the edit buffet form from the view buffet info page' do
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
  
      click_on 'Editar informações'
  
      #Assert
      expect(current_path).to eq edit_buffet_path(user.buffet)
      expect(page).to have_field('Nome fantasia', with: 'Fantasias & CIA')
      expect(page).to have_field('Razão social', with: 'Sem razão alguma')
      expect(page).to have_field('CNPJ', with: Buffet.first.registration_number)
    end
  
    it 'can edit buffet successfully' do
      #Arrange
      cnpj = CNPJ.generate
      new_cnpj = CNPJ.generate
  
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
  
      Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: cnpj, contact_number: '(11) 99876-5432',
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
      fill_in 'CNPJ', with: new_cnpj
  
      click_on 'Salvar'
  
      #Assert
      expect(page).to have_content('Você editou seu buffet com sucesso.')
      expect(page).to have_content('Fantasioso super nome')
      expect(page).to have_content('Socialmente temos razão')
      expect(page).to have_content(CNPJ.new(new_cnpj).formatted)
      expect(page).not_to have_content('Fantasias & CIA')
      expect(page).not_to have_content(cnpj)
    end
  
    it 'shouldnt be able to edit buffet with missing information' do
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
  
      click_on 'Editar informações'
  
      fill_in 'Nome fantasia', with: ''
      fill_in 'Razão social', with: 'Socialmente temos razão'
      fill_in 'CNPJ', with: CNPJ.generate
  
      #Assert
      expect{click_on 'Salvar'}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end