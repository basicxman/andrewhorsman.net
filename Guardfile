guard 'minitest' do
  # App components
  watch(%r|^app/controllers/(.*)\.rb|) { |m| "test/functional/#{m[1]}_test.rb" }
  watch(%r|^app/models/(.*)\.rb|)      { |m| "test/unit/#{m[1]}_test.rb" }

  # Tests
  watch(%r|^test/(.*)/(.*)_test\.rb|) { |m| "test/#{m[1]}/#{m[2]}_test.rb" }
  watch(%r|^test/test_helper\.rb|)    { "test" }
end
