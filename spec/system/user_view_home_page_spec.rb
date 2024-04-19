require 'rails_helper'

describe 'User views the home page' do
  it 'should be redirected to login page if not signed in and trying to navigate' do
    #Arrange
    #Act
    visit(user_index_path)
    #Assert
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'can see the home page and navigation bar' do
    #Arrange
    #Act
    visit root_path
    #Assert
    expect(page).to have_content('Boas vindas ao Cadê Buffet!')
    expect(page).to have_content('Login')
  end
end