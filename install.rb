require 'fileutils'

initializer = File.expand_path(File.dirname(__FILE__) + '/../../../config/initializers/annotate_properties.rb')

if File.exists?(initializer)
  puts "AnnotateProperties initializer already exists."
else
  FileUtils.cp File.dirname(__FILE__) + "/initializers/annotate_properties.rb", initializer
  puts "Initializer that adds dummy ActiveRecord::Base.property method has been written to #{initializer}."
end