require 'rails_helper'

RSpec.describe Buffet, type: :model do
  describe '#valid?' do

    before :each do
      @user = User.create!(username: 'usertest', full_name: 'Test User', contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password')
    end

    context 'presence' do
      it 'false when trading name is missing' do
        buffet = Buffet.new(trading_name: '', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', user: @user)
        expect(buffet.valid?).to eq false
      end

      it 'false when company name is missing' do
        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: '', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', user: @user)
        expect(buffet.valid?).to eq false
      end

      it 'false when registration number is missing' do
        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', user: @user)
        expect(buffet.valid?).to eq false
      end

      it 'false when contact number is missing' do
        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', user: @user)
        expect(buffet.valid?).to eq false
      end

      it 'false when email is missing' do
        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: '', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', user: @user)
        expect(buffet.valid?).to eq false
      end

      it 'false when address is missing' do
        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: '', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', user: @user)
        expect(buffet.valid?).to eq false
      end

      it 'false when district is missing' do
        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: '', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', user: @user)
        expect(buffet.valid?).to eq false
      end

      it 'false when city is missing' do
        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: '', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', user: @user)
        expect(buffet.valid?).to eq false
      end

      it 'false when state is missing' do
        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: '',
                            zipcode: '09280080', description: 'Buffet para testes', user: @user)
        expect(buffet.valid?).to eq false
      end

      it 'false when zip code is missing' do
        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '', description: 'Buffet para testes', user: @user)
        expect(buffet.valid?).to eq false
      end

      it 'false when description is missing' do
        buffet = Buffet.new(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: '', user: @user)
        expect(buffet.valid?).to eq false
      end
    end

    context 'uniqueness' do
      it 'false when registration number is already in use' do
        Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: '83.757.309/0001-58', contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', user: @user)

        buffet = Buffet.new(trading_name: 'Buffeteria', company_name: 'Buffet festas e cia', registration_number: '83.757.309/0001-58', contact_number: '(11) 91234-5678',
                            email: 'email@buffeteria.com', address: 'Rua das festas, 22', district: 'Bairro Central', city: 'Rio de Janeiro', state: 'RJ',
                            zipcode: '11622091', description: 'Buffet pra festas e atrações', user: @user)

        expect(buffet.valid?).to eq false
      end
    end

    #Context pra CNPJ não valido
  end
end
