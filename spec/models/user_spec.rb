require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation tests' do
    it 'ensures web url presence' do
      user = User.new(name: 'Last', email: 'sample@example.com', password: 'test@123').save
      expect(user).to eq(false)
    end
    
    it 'ensures email presence' do
      user = User.new(name: 'First', web_url: 'https://www.google.com/', password: 'test@123').save
      expect(user).to eq(false)
    end
    
    it 'ensures name presence' do
      user = User.new(email: 'sample@example.com', web_url: 'https://www.google.com/', password: 'test@123').save
      expect(user).to eq(false)
    end
    
    it 'should save successfully' do 
      user = User.new(name: 'First', email: 'sample@example.com', web_url: 'https://www.google.com/', password: 'test@123').save
      expect(user).to eq(true)
    end
  end
end
