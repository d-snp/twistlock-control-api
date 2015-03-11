$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'twistlock_control'

module Rotterdam
    DEFAULT_CONFIG_FILE = "#{File.dirname(__FILE__)}/config/settings.yml"

    class << self
        attr_accessor :settings

        def boot(environment)
            all_settings = YAML.load_file DEFAULT_CONFIG_FILE
            @settings = all_settings[environment]
            TwistlockControl.configure settings['twistlock_control']

			puts "Loaded environment: #{environment}"
        end
    end
end
