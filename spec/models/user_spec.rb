require 'spec_helper'

describe User do 
  before(:all) do 
    FactoryGirl.create(:user, email: 'admin@example.com')
  end

  describe 'attributes' do 
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:email) }
    it { should respond_to(:birthdate) }
    it { should respond_to(:city) }
    it { should respond_to(:country) }
    it { should respond_to(:fach) }
    it { should respond_to(:admin) }
  end

  describe 'instance methods' do
    before(:each) do 
      @user = FactoryGirl.create(:user, first_name: 'Jacob', last_name: 'Smith')
    end

    it { should respond_to(:admin?) }

    describe 'tasks' do 
      before(:each) do 
        2.times { FactoryGirl.create(:task_list_with_tasks, user_id: @user.id) }
      end

      it 'returns all its tasks' do 
        tasks = []
        @user.task_lists.each {|list| tasks << list.tasks }
        expect(@user.tasks).to eql tasks.flatten
      end
    end

    describe 'to_hash' do 
      it 'returns a hash of itself' do 
        expect(@user.to_hash).to eql(id: @user.id, first_name: 'Jacob', email: @user.email, last_name: 'Smith', country: 'USA')
      end
    end

    describe 'name' do 
      it 'concatenates first and last name' do 
        expect(@user.name).to eql 'Jacob Smith'
      end
    end
  end

  describe 'class methods' do 
    describe 'is_admin_key' do 
      before(:each) do 
        FactoryGirl.create(:user)
      end

      it 'returns true when the key given belongs to an admin' do 
        expect(User.is_admin_key?(User.first.secret_key)).to eql true
      end

      it 'returns false when the key given doesn\'t belong to an admin' do 
        expect(User.is_admin_key?(User.last.secret_key)).to eql nil
      end
    end
  end

  describe 'creating users' do 
    context 'validations' do 
      before(:each) do 
        @user = User.new
      end

      it 'is invalid without an e-mail address' do 
        expect(@user).not_to be_valid
      end

      it 'is invalid with a duplicate e-mail address' do 
        @user.email = 'admin@example.com'
        expect(@user).not_to be_valid
      end

      it 'is invalid with an improper e-mail format' do 
        @user.email = 'hello_world.com'
        expect(@user).not_to be_valid
      end
    end

    context 'when there are no other users in the database' do 
      it 'is automatically an admin' do 
        expect(User.first).to be_admin
      end
    end

    context 'when a regular user account is created' do 
      before(:each) do 
        @user = User.create!(email: 'joeblow@example.com')
      end

      it 'is not an admin' do 
        expect(@user).not_to be_admin
      end

      it 'has a secret key' do 
        expect(@user.secret_key).not_to be_nil
      end
    end
  end
end