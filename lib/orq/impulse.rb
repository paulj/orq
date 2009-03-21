require 'rubygems'
require 'yaml'
require 'active_support'

module ORQ
  # Base class inherited by domain objects describing a message that can be sent
  class Impulse
    def initialize(config = {})
      apply_hash!(config)
    end
    
    # Instructs the impulse to send itself to the message queue
    def fire!
      self.class.get_target(self.class.target_name).fire self.class.uri, self.to_json
    end
    
    # Instructs the impulse to apply the properties in the given hash
    def apply_hash!(props)
      props.each do |k, v|
        send("#{k}=", v) if respond_to? "#{k}="
      end
    end
    
    # Class Methods
    class << self
        #
        # Configuration Methods
        #
      
      # Sets the uri for this Impulse if a uri is provided; returns the value for the uri
      # (or the class name if not overriden)
      def uri(uri = nil)
        @uri = uri unless uri.nil?
        
        return self.name if @uri.nil?
        @uri
      end
      
      # Sets the target name for this Impulse if a uri is provided; returns the value for the target name
      # (or 'default' if not overriden)
      def target_name(target_name = nil)
        @target_name = target_name unless target_name.nil?
        
        return 'default' if @target_name.nil?
        @target_name
      end
      
      # Declares a field that should be available on an impulse.
      def field(name)
        attr_accessor name
      end
      
        #
        # Control Methods
        #
      def subscribe(&block)
        target = get_target self.target_name
        target.subscribe self, &block
      end
      
        #
        # Loading Methods
        #
      def load(text)
        vals = ActiveSupport::JSON.decode(text)
        result = new(vals)
        result
      end
    end
    
    # Static Methods
    
    # Configures the ORQ infrastructure using the file on the given path.
    def self.configure(path, environment)
      # Load the given YAML file
      config = YAML::load_file(path)
      
      # Get the configuration for the profile
      env_config = config[environment.to_s]
      raise "No configuration for environment #{environment} in #{path}" unless env_config
      
      # Clear the list of targets, and then process each
      @@targets = {}
      if env_config.is_a? Hash
        env_config.each do |target_name, target_config|
        
          @@targets[target_name] = load_target target_name, target_config
        end
      end
    end
    
    # Requests that the ORQ infrastructure start any connections
    def self.start
      @@targets.each do |name, target|
        target.start
      end
    end
    
    private
      def self.load_target(name, config)
        driver = config.delete 'driver'
        raise "No driver specified for target #{name}" unless driver
        
        # Load the adapter for the given driver
        require "orq/adapters/#{driver}_adapter"
        driver_class = Kernel.const_get("#{driver}_adapter".classify).new config
      end

      # Retrieves a target with the given name
      def self.get_target(name)
        raise "No target #{name} available" unless @@targets[name]
        @@targets[name]
      end
  end
end
