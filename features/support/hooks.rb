Before do |scenario|
  FactoryGirl.create(:admin, id: 1, email: 'admin@example.com', username: 'abc123', password: 'abcde12345')
  FactoryGirl.create(:user, id: 2, email: 'user2@example.com', username: 'bcd234', password: 'bcdef23456')
  FactoryGirl.create(:user, id: 3, email: 'user3@example.com', username: 'cde345', password: 'cdefg34567')
end

# This seems like a smell, but the fact is that sometimes I just need
# to know exactly what the tasks' IDs are.
Before('@tasks') do |scenario|
  list_id_1 = User.find(1).default_task_list.id
  list_id_2 = User.find(2).default_task_list.id
  list_id_3 = User.find(3).default_task_list.id

  FactoryGirl.create(:task, task_list_id: list_id_1, id: 1)
  FactoryGirl.create(:task, task_list_id: list_id_1, id: 2)
  FactoryGirl.create(:task, task_list_id: list_id_1, id: 3)

  FactoryGirl.create(:task, task_list_id: list_id_2, id: 4)
  FactoryGirl.create(:task, task_list_id: list_id_2, id: 5)
  FactoryGirl.create(:task, task_list_id: list_id_2, id: 6)

  FactoryGirl.create(:task, task_list_id: list_id_3, id: 7)
  FactoryGirl.create(:task, task_list_id: list_id_3, id: 8)
  FactoryGirl.create(:task, task_list_id: list_id_3, id: 9)
end