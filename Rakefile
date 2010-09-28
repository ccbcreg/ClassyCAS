require "rake/testtask"

Rake::TestTask.new do |t|
  t.test_files = FileList["test/**/*_test.rb"]
end

namespace :test do
  Rake::TestTask.new(:protocol) do |t|
    t.test_files = FileList["test/protocol/*_test.rb"]
  end

  Rake::TestTask.new(:unit) do |t|
    t.test_files = FileList["test/unit/*_test.rb"]
  end

end