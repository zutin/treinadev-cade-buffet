require 'rails_helper'

RSpec.describe Buffet, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when trading name is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:trading_name]).to include("não pode ficar em branco")
      end

      it 'false when company name is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome fantasia', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:company_name]).to include("não pode ficar em branco")
      end

      it 'false when registration number is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:registration_number]).to include("não pode ficar em branco")
      end

      it 'false when contact number is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate,
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:contact_number]).to include("não pode ficar em branco")
      end

      it 'false when email is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:email]).to include("não pode ficar em branco")
      end

      it 'false when address is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:address]).to include("não pode ficar em branco")
      end

      it 'false when district is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:district]).to include("não pode ficar em branco")
      end

      it 'false when city is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:city]).to include("não pode ficar em branco")
      end

      it 'false when state is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:state]).to include("não pode ficar em branco")
      end

      it 'false when zip code is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:zipcode]).to include("não pode ficar em branco")
      end

      it 'false when description is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:description]).to include("não pode ficar em branco")
      end

      it 'false when payment method is missing' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:payment_methods]).to include("não pode ficar em branco")
      end

      it 'false when user association is missing' do
        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix')

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:user]).to include("é obrigatório(a)")
      end
    end

    context 'uniqueness' do
      it 'false when registration number is already in use' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        first_buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        second_buffet = Buffet.new(trading_name: 'Buffeteria', company_name: 'Buffet festas e cia', registration_number: first_buffet.registration_number, contact_number: '(11) 91234-5678',
                            email: 'email@buffeteria.com', address: 'Rua das festas, 22', district: 'Bairro Central', city: 'Rio de Janeiro', state: 'RJ',
                            zipcode: '11622091', description: 'Buffet pra festas e atrações', payment_methods: 'Pix', user: user)

        expect(second_buffet.valid?).to eq false
        expect(second_buffet.errors[:registration_number]).to include("já está em uso")
      end
    end

    context 'length' do
      it 'false when trading name is shorter than 3 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'No', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:trading_name]).to include("é muito curto (mínimo: 3 caracteres)")
      end

      it 'false when trading name is longer than 30 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'NomeeNomeeNomeeNomeeNomeeNomeee', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:trading_name]).to include("é muito longo (máximo: 30 caracteres)")
      end

      it 'false when company name is shorter than 3 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome teste', company_name: 'Ra', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:company_name]).to include("é muito curto (mínimo: 3 caracteres)")
      end

      it 'false when company name is longer than 30 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome teste', company_name: 'Razão socialRazão socialRazão socialRazão socialRazão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:company_name]).to include("é muito longo (máximo: 30 caracteres)")
      end

      it 'false when contact number is shorter than 10 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome teste', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '118765432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:contact_number]).to include("é muito curto (mínimo: 10 caracteres)")
      end

      it 'false when contact number is longer than 15 characters' do
        user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')

        buffet = Buffet.new(trading_name: 'Nome teste', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-54321',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

        expect(buffet.valid?).to eq false
        expect(buffet.errors[:contact_number]).to include("é muito longo (máximo: 15 caracteres)")
      end
    end
  end
end
