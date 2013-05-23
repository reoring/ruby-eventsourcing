require File.dirname(__FILE__) + '/UserRegistered.rb'
require File.dirname(__FILE__) + '/../../../common/domain/model/EventSourcedRootEntity.rb'

class User
	include EventSourcedRootEntity

	@id
	@name

	def initialize(userId, userName)
		super
		self.apply(UserRegistered.new(userId, userName))
	end

	def userId()
		return @id
	end

	def name()
		return @name
	end

	def whenUserRegistered(userRegisteredEvent)
		@id = userRegisteredEvent.userId()
		@name = userRegisteredEvent.userName()
	end
end