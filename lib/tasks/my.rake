namespace :my do
  desc '重建数据库 并执行rake db:seed'
  task redb:['db:drop','db:create','db:migrate','db:seed'] do
  end
end
