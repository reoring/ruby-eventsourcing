# Domain Event
class UserRegistered
	@userId = nil
	@userName = nil

	def initialize(userId, userName)
		@userId = userId
		@userName = userName
	end

	def userId()
		return @userId
	end

	def userName()
		return @userName
	end

	def toHash()
		return {'userId'=> @userId, 'userName'=> @userName}
	end

	def self.fromHash(value)
		return self.new value["userId"], value["userName"]
	end
end