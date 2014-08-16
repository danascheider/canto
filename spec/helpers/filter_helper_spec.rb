require 'spec_helper'

describe Canto::FilterHelper do 
  include Canto::FilterHelper

  let(:user) { FactoryGirl.create(:user_with_task_lists) }

  before(:each) do 
    @list, @task = user.task_lists.first, user.task_lists.first.tasks.first
    @task.update!(priority: 'high')
    @hash = {user: @list.owner.id, resource: 'tasks', filters: {'priority' => 'high'}}
  end

  describe '::filter_resources' do 
    before(:each) do 
      allow(Canto::FilterHelper::TaskFilter).to receive(:new).and_return(filter = double('task_filter').as_null_object)
      allow(filter).to receive(:to_a).and_return(arr = double('array'))
      allow(arr).to receive(:map).and_return [@task.to_hash]
    end

    it 'creates a TaskFilter' do 
      filter_resources(@hash)
      expect(Canto::FilterHelper::TaskFilter).to have_received(:new)
    end

    it 'returns relevant resources as JSON' do 
      expect(filter_resources(@hash)).to eql [@task.to_hash].to_json
    end
  end

  describe Canto::FilterHelper::TaskFilter do 
    
  end
end