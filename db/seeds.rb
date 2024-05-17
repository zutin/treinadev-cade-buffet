# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

  3.times do |i|
    owner = User.create!(username: "user_#{i}", full_name: "User #{i}", contact_number: "(11) 91111-000#{i}",
                email: "user#{i}@test.com", social_security_number: CPF.generate, password: 'password', role: 'owner')

    buffet = Buffet.create!(trading_name: "Buffet Nº #{i}", company_name: "Razão social do buffet #{i}",
                            registration_number: CNPJ.generate, contact_number: "(11) 9#{i}000-0000",
                            email: "buffet#{i}@contato.com", address: "Rua dos Bobos, 0#{i}", district: 'Bairro da Igrejinha',
                            city: 'São Paulo', state: 'SP', zipcode: "0928008#{i}", description: "Buffet ##{i} para testes e amigos",
                            payment_methods: 'Pix, Cartão de Débito', user: owner)

    buffet.buffet_logo.attach(File.open(Rails.root.join("db/images/buffet#{i}.jpg")))

    event = Event.create!(name: "Festa de 2#{i} anos", description: "Super evento do buffet #{i}",
                  minimum_participants: (i + 1) * 10, maximum_participants: (i + 1) * 20, default_duration: (i + 1) * 60,
                  menu: 'Arroz, feijão, batata', alcoholic_drinks: true, decorations: false,
                  can_change_location: false, valet_service: true, buffet: buffet)

    event.event_logo.attach(File.open(Rails.root.join("db/images/event#{i}.jpg")))

    EventPrice.create!(base_price: (i + 1) * 100, additional_hour_price: (i + 1) * 100, additional_person_price: (i + 1) * 100,
                      weekend_base_price: (i + 1) * 200, weekend_additional_hour_price: (i + 1) * 200, weekend_additional_person_price: (i + 1) * 200,
                      event: event)
  end

  2.times do |i|
    customer = User.create!(username: "customer_#{i}", full_name: "Customer #{i}", contact_number: "(21) 92222-000#{i}",
                email: "customer#{i}@test.com", social_security_number: CPF.generate, password: 'password', role: 'customer')

    order = Order.create!(desired_date: '2024-12-16', estimated_invitees: 15, observation: "Pedido #{i}",
                  desired_address: "Rua dos Bobos, #{i}", buffet: Buffet.find(i+1), event: Event.find(i+1), user: customer, status: 'confirmed')

    Proposal.create!(total_value: 1000, expire_date: '2024-12-30', description: "Proposta #{i}", discount: "#{i*5}", tax: '', payment_method: 'Pix', order: order)

    Review.create!(rating: i+2, comment: "Muito bom, gostei #{i+1} vezes!", order: order, reviewer: customer)
  end
