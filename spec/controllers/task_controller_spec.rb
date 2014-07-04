require 'spec_helper'

describe Canto::TaskController do 
  include Canto::TaskController
  include Canto::ErrorHandling

  context 'task indexing functions' do 

    context 'CREATE method' do 
      context 'index not explicitly set' do           
        before(:each) do 
          Task.create!(title: 'My task 1', index: 1)
          create_task(title: "My new task")
          @task = Task.last
        end

        it 'sets new task\'s index to 1 by default' do 
          expect(@task.index).to eql 1
        end

        it 'increases index of other tasks by 1' do
          expect(find_task(1).index).to eql 2
        end
      end # 'index not explicitly set'

      context 'index explicitly set' do 
        before(:each) do 
          for i in 1..4
            Task.create!(title: "My task #{i}", index: i)
          end
          create_task(title: "My new task", index: 3)
          @task = Task.last
        end

        it 'sets the task\'s index to the one specified' do 
          expect(@task.index).to eql 3
        end

        it 'increases index of 3rd and 4th tasks by 1' do 
          expect(Task.where.not(title: "My new task").pluck(:index)).to eql [1, 2, 4, 5]
        end
      end # index explicitly set
    end # CREATE method
  end # task indexing functions
end # Canto::TaskController
