# Annotations look like:
#   class User < ActiveRecord::Base
#     property :login, :string, :null => false
#     property :email, :string, :null => false
#     property :admin, :boolean, :default => false
#     property :created_at, :datetime
#   end
# 
desc "Add property annotations to the model files."
task 'db:annotate' => 'environment' do
  Dir["#{Rails.root}/app/models/*.rb"].each { |file| AnnotateProperties.annotate(file) }
end

