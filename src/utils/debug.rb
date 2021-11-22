
def debug(str)
	if ENABLE_DEBUG then
		puts("[DEBUG] #{str}")
	end
end

def error(str)
	puts("[ERROR] #{str}!!!!")
end
