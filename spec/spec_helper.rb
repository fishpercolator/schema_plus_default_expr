require 'simplecov'
require 'simplecov-gem-profile'
SimpleCov.start "gem"

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'active_record'
require 'schema_plus_default_expr'
require 'schema_dev/rspec'

SchemaDev::Rspec.setup

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.warnings = true
end

def define_schema(&block)
  ActiveRecord::Migration.suppress_messages do
    ActiveRecord::Schema.define do
      connection.tables.each do |table|
        drop_table table, force: :cascade
      end
      instance_eval &block
    end
  end
end


SimpleCov.command_name "[ruby#{RUBY_VERSION}-activerecord#{::ActiveRecord.version}-#{ActiveRecord::Base.connection.adapter_name}]"
