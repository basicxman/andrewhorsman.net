namespace :test do
  rule "" do |t|
    if t.name =~ /test:controller/
      controller, regex = t.name.split(":")[2, 2]
      sh "ruby -W0 -Itest test/functional/#{controller}_controller_test.rb -n /#{regex}/"
    end

    if t.name =~ /test:model/
      model, regex = t.name.split(":")[2, 2]
      sh "ruby -W0 -Itest test/unit/#{model}_test.rb -n /#{regex}/"
    end
  end
end
