require 'yaml'

ENV['RACK_ENV'] ||= 'test'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
APP_DIR ||= File.expand_path('../../', __FILE__)

require 'demoji'
require 'rspec'
require 'active_record'

ActiveRecord::Base.send :include, Demoji

Dir["#{APP_DIR}/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

  config.before(:suite) do
    db_config = YAML.load_file(File.join(APP_DIR, 'spec', 'config', 'database.yml'))[ENV['RACK_ENV']]
    ActiveRecord::Base.establish_connection db_config

    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS `test_users`")
    ActiveRecord::Base.connection.execute("CREATE TABLE IF NOT EXISTS `test_users` (`id` int(11) NOT NULL AUTO_INCREMENT, `name` varchar(255) NOT NULL, PRIMARY KEY (`id`)) DEFAULT CHARSET=utf8;")
  end

  config.before(:each) do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE `test_users`")
  end

end
