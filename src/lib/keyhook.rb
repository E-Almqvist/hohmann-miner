# Handler for key events

class MethodContainer 
	attr_reader :method_registry
	def initialize
		@method_registry = [] 
	end

	def create_method(name, &block)
		method_registry << name
		self.class.send(:define_method, name, &block)
	end

	def call(method_name, *args)
		debug("Calling method '#{method_name}' for #{self}")
		if( @method_registry.include? method_name ) then
			self.send(method_name, *args)
		end
	end
end

class KeyHook
	attr_accessor :key_hooks, :method_container

	def initialize
		@method_container = MethodContainer.new
		@key_hooks = Hash.new([])
	end

	def add(hook, event_name=:main, &block)
		if( @key_hooks[hook].include? event_name ) then
			error("Duplicate event_name ('#{event_name}') for hook '#{hook}'!")
		else
			@method_container.create_method(event_name, &block)
			@key_hooks[hook] << event_name
			return event_name
		end
	end

	def call(hook, *args)
		if( @key_hooks.key? hook ) then
			@key_hooks[hook].each do |event_name|
				@method_container.send(event_name, *args)
			end
		end
	end

	def get_hooks
		return self.key_hooks
	end
end
