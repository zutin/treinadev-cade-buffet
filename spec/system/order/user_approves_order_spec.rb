require 'rails_helper'

describe 'User approves an order' do
  context 'as a customer' do
    it 'shouldnt be able to see the approve and refuse buttons' do
      #Arrange
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-07-08', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 11, buffet: buffet, event: event, user: customer)

      #Act
      login_as(owner)
      order_path(order)

      #Assert
      expect(page).not_to have_link('Aprovar pedido')
      expect(page).not_to have_link('Recusar')
    end

    it 'should be able to see an order proposal information correctly' do
      #Arrange
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-07-08', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer)
      proposal = Proposal.create!(total_value: 60, expire_date: '2024-05-16', discount: 50, tax: 10, description: 'Oferta', payment_method: 'Crédito', order: order)

      #Act
      login_as(customer)
      visit order_path(order)

      #Assert
      expect(page).to have_content('Proposta enviada pelo buffet')
      expect(page).to have_content('Valor final proposto: 60')
      expect(page).to have_content('Desconto oferecido: 50')
      expect(page).to have_content('Taxa extra: 10')
      expect(page).to have_content('Descrição: Oferta')
      expect(page).to have_content('Forma de pagamento: Crédito')
    end

    it 'should be redirected when trying to access the order proposal page' do
      #Arrange
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-07-07', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer)

      #Act
      login_as(customer)
      visit new_order_proposal_path(order)

      #Assert
      expect(current_path).to eq root_path
      expect(page).to have_content('Você não tem acesso à essa página.')
    end
  end

  context 'as a buffet owner' do
    it 'should be able to see the approve and refuse buttons correctly' do
      #Arrange
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-07-08', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 11, buffet: buffet, event: event, user: customer)

      #Act
      login_as(owner)
      visit order_path(order)

      #Assert
      expect(page).to have_link('Aprovar pedido', href: new_order_proposal_path(order))
      expect(page).to have_link('Recusar', href: order_refuse_path(order))
    end

    it 'can see the order approval page successfully' do
      #Arrange
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-07-07', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer)

      #Act
      login_as(owner)
      visit order_path(order)
      click_on 'Aprovar pedido'

      #Assert
      expect(current_path).to eq new_order_proposal_path(order)
    end

    it 'should be able to see the order approval fields correctly' do
      #Arrange
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-07-08', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer)

      #Act
      login_as(owner)
      visit new_order_proposal_path(order)

      #Assert
      expect(page).to have_content('Valor total (baseado no número de convidados informado): 100')
      expect(page).to have_field('Data de validade')
      expect(page).to have_field('Desconto')
      expect(page).to have_field('Taxa extra')
      expect(page).to have_field('Método de pagamento')
    end

    it 'can approve an order successfully' do
      #Arrange
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-07-08', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer)

      #Act
      login_as(owner)
      visit new_order_proposal_path(order)
      fill_in 'Data de validade', with: '2024-05-16'
      fill_in 'Desconto', with: '50'
      fill_in 'Descrição', with: 'Oferta numero 1'
      fill_in 'Método de pagamento', with: 'Pix'
      click_on 'Salvar'

      #Assert
      expect(page).to have_content('Você aprovou o pedido e enviou uma proposta para o usuário.')
      expect(page).to have_content('Valor final proposto: 50')
      expect(page).to have_content('Desconto oferecido: 50')
      expect(page).not_to have_content('Taxa extra:')
      expect(page).to have_content('Descrição: Oferta numero 1')
      expect(page).to have_content('Forma de pagamento: Pix')
    end

    it 'can refuse an order successfully' do
      puts '#todo'
    end

    it 'shouldnt be able to approve an order with missing information' do
      #Arrange
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-07-08', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer)

      #Act
      login_as(owner)
      visit new_order_proposal_path(order)
      fill_in 'Descrição', with: 'Nao tenho outras informações'

      #Assert
      expect{click_on 'Salvar'}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end