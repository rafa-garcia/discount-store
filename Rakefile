# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new do |task|
  task.libs << 'test'
  task.test_files = FileList['test/**/*_test.rb']
end

task default: :test
