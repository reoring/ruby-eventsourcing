class EventStoreUserRepository
	@eventStore

	def initialize(eventStore)
		@eventStore = eventStore
	end

	def userOfUserId(user)
		begin
            eventStreamId = EventStreamId(user.userId())
            eventStream = eventStore.eventStreamSince(eventStreamId)
        rescue
        end

        return User.constructWithEventStream(eventStream.events(), eventStream.version())
	end

	def save(user)
		eventId = EventStreamId.new(user.userId(), user.unmutatedVersion())
        @eventStore.appendWith(eventId, user.mutatingEvents())
	end
end