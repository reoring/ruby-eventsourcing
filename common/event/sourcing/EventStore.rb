class EventStore
    def appendWith(startingIdentity, events)
        raise "Not implemented"
    end

    def eventsSince(lastReceivedEvent)
        raise "Not implemented"
    end

    def eventStreamSince (identity)
        raise "Not implemented"
    end

    def fullEventStreamFor(identity)
        raise "Not implemented"
    end

    def purge
        raise "Not implemented"
    end

    def registerEventNotifiable(eventNotifiable)
        raise "Not implemented"
    end
end