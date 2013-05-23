class DomainRegistry
	def DomainRegistry.UserRepository()
		eventStore = EventStoreProvider.instance().eventStore()
		return EventStoreUserRepository.new(eventStore)
	end
end