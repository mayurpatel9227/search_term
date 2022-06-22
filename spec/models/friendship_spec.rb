require 'rails_helper'

  RSpec.describe Friendship, type: :model do
  	context 'validation tests' do
  		it 'ensures user is present' do 
  			friendship = Friendship.new(friend_id:1).save
  			expect(friendship).to eq(false)
  		end

  		it 'ensures friend is present' do 
  			friendship = Friendship.new(user_id:1).save
  			expect(friendship).to eq(false)
  		end

  		let (:params) { {name: 'First', email: 'sample@example.com', web_url: 'https://www.google.com/', password: 'test@123'} }
	    before(:each) do
	      User.new(params).save
	    end

	    let (:params) { {name: 'First', email: 'sample@example.com', web_url: 'https://www.google.com/', password: 'test@123'} }
	    before(:each) do
	      User.new(params).save
	    end

  		it 'should save successfully' do 
  			friendship = Friendship.new(user_id: 1,friend_id: 2).save
  			expect(friendship).to eq(true)
  		end

  	end
	end