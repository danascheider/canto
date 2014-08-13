require 'spec_helper'

describe Canto::FilterHelper do 
  include Canto::FilterHelper

  let(:user) { FactoryGirl.create(:user_with_task_lists) }

  before(:each) do 
    @list, @task = user.task_lists.first, user.task_lists.first.tasks.first
    @task.update!(priority: 'high')
    @hash = {'user' => @list.owner.id, 'resource' => 'tasks', 'filters' => {'priority' => 'high'}}
  end

  describe '::get_filtered' do 
    it 'returns the correct tasks' do 
      expect(get_filtered(@hash)).to eq [@task]
    end
  end

  describe '::filter_resources' do 
    it 'returns relevant resources as JSON' do 
      expected = [ @task.to_hash ].to_json
      expect(filter_resources(@hash)).to eql expected
    end
  end
end