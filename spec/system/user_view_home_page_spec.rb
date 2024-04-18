require 'rails_helper'

describe 'User views the home page' do
  it 'can see the home page content' do
    #Arrange
    #Act
    visit root_path
    #Assert
    expect(page).to have_content('Boas vindas ao Cadê Buffet!')
  end

  it 'can see the navigation bar content' do
    #Arrange
    #Act
    visit root_path
    #Assert
    expect(page).to have_content('Login')
  end

  # Futuramente segundo teste para conseguir ver alguns anuncios de buffet antes de logar / cadastrar, formato landing page
  #it 'can see the landing page ads properly' do
  #end
end