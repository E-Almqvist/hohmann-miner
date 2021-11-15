# Empty method that does nothing (placeholder for keyhooks)
def nullmethod
	return
end


# Handler for key events
class KeyHook
	attr_reader :nullmethod_ptr
	attr_accessor :key_hooks

	def initialize
		@nullmethod_ptr = method(:nullmethod)

		@key_hooks = Hash.new(Hash.new(@nullmethod_ptr))
		# Each keyhook contains a hash of method pointers
	end

	def add(hook, event_name=:main, method_sym=:nullmethod)
		self.key_hooks[hook][event_name] = method(method_sym)
	end

	def remove(hook, event_name=:main)
		self.key_hooks[hook][event_name] = self.nullmethod_ptr
	end

	def call(hook, *args)
		self.key_hooks[hook].each { |h| h.call(*args) }
	end

	def get_hooks
		return self.key_hooks
	end
end
