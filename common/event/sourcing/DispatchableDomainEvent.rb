class DispatchableDomainEvent
    @eventId
    @domainEvent

    def initialize(eventId, domainEvent)
        @eventId = eventId
        @domainEvent = domainEvent
    end

    def domainEvent
        return @domainEvent
    end

    def eventId()
        return @eventId
    end
end