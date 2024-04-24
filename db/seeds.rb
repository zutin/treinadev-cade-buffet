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
  user = User.create!(username: "user_#{i}", full_name: "User #{i}", contact_number: "(11) 91111-000#{i}", email: "user#{i}@test.com", password: 'password')
  buffet = Buffet.create!(trading_name: "Buffet ##{i}", company_name: "Razão social do buffet #{i}", registration_number: "11.222.333/0000-0#{i}", contact_number: "(11) 9#{i}000-0000",
                email: "buffet#{i}@contato.com", address: "Rua dos Bobos, 0#{i}", district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                zipcode: "0928008#{i}", description: "Buffet ##{i} para testes e amigos", payment_methods: 'Pix, Cartão de Débito', user: user)
  Event.create!(name: "Festa de 2#{i} anos", description: "Super evento do buffet #{i}", minimum_participants: i * 10, maximum_participants: i * 20,
                default_duration: i * 60, menu: 'Arroz, feijão, batata', alcoholic_drinks: true, decorations: false,
                can_change_location: false, valet_service: true, buffet: buffet)
end