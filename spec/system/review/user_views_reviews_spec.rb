require 'rails_helper'

describe 'User views a buffet review' do
  it 'can see a buffet review successfully' do
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
    order = Order.create!(desired_date: '2024-12-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer, status: 'confirmed')
    Proposal.create!(total_value: 60, expire_date: '2024-12-16', discount: 50, tax: 10, description: 'Oferta', payment_method: 'Crédito', order: order)
    Review.create!(rating: 5, comment: 'Muito bom serviço!', order: order, reviewer: customer)

    #Act
    visit root_path
    click_on 'Nome fantasia'
    
    #Assert
    expect(page).to have_content('Avaliações do buffet')
    expect(page).to have_content('Nota 5')
    expect(page).to have_content('Muito bom serviço!')
  end

  it 'can see all buffet reviews when there is more than 3 reviews' do
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

    order = Order.create!(desired_date: '2024-12-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer, status: 'confirmed')
    Proposal.create!(total_value: 60, expire_date: '2024-12-16', discount: 50, tax: 10, description: 'Oferta', payment_method: 'Crédito', order: order)
    Review.create!(rating: 5, comment: 'Muito bom serviço!', order: order, reviewer: customer)

    order2 = Order.create!(desired_date: '2024-11-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 15, buffet: buffet, event: event, user: customer, status: 'confirmed')
    Proposal.create!(total_value: 60, expire_date: '2024-12-16', discount: 50, tax: 10, description: 'Oferta', payment_method: 'Crédito', order: order2)
    Review.create!(rating: 4, comment: 'Excelente serviço!', order: order2, reviewer: customer)

    order3 = Order.create!(desired_date: '2024-10-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 25, buffet: buffet, event: event, user: customer, status: 'confirmed')
    Proposal.create!(total_value: 60, expire_date: '2024-12-16', discount: 50, tax: 10, description: 'Oferta', payment_method: 'Crédito', order: order3)
    Review.create!(rating: 3, comment: 'Incrível serviço!', order: order3, reviewer: customer)

    order4 = Order.create!(desired_date: '2024-09-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 30, buffet: buffet, event: event, user: customer, status: 'confirmed')
    Proposal.create!(total_value: 60, expire_date: '2024-12-16', discount: 50, tax: 10, description: 'Oferta', payment_method: 'Crédito', order: order4)
    Review.create!(rating: 2, comment: 'Amei o serviço!', order: order4, reviewer: customer)

    #Act
    visit buffet_path(buffet)
    click_on 'Ver todas avaliações'
    
    #Assert
    expect(page).to have_content('Nota 5')
    expect(page).to have_content('Muito bom serviço!')
    expect(page).to have_content('Nota 4')
    expect(page).to have_content('Excelente serviço!')
    expect(page).to have_content('Nota 3')
    expect(page).to have_content('Incrível serviço!')
    expect(page).to have_content('Nota 2')
    expect(page).to have_content('Amei o serviço!')
  end

  it 'can see a buffet average rating successfuly' do
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
    order = Order.create!(desired_date: '2024-12-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer, status: 'confirmed')
    order2 = Order.create!(desired_date: '2024-12-29', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 25, buffet: buffet, event: event, user: customer, status: 'confirmed')
    Proposal.create!(total_value: 60, expire_date: '2024-12-16', discount: 50, tax: 10, description: 'Oferta', payment_method: 'Crédito', order: order)
    Review.create!(rating: 5, comment: 'Muito bom serviço!', order: order, reviewer: customer)
    Review.create!(rating: 0, comment: 'Serviço foi péssimo!', order: order2, reviewer: customer)

    #Act
    visit root_path
    click_on 'Nome fantasia'
    
    #Assert
    expect(page).to have_content('2.5 Nota média')
  end
end