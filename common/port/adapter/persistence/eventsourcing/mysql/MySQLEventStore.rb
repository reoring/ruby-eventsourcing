class MySQLEventStore < EventStore
    @collaborationDataSource
    @eventNotifiable

    def initialize(aDataSource)
        @collaborationDataSource = aDataSource
    end

    def appendWith(startingIdentity, events)
        connection = connection()

        index = 0

        event_id = 0
        stream_name = startingIdentity.streamName()

        if startingIdentity.streamVersion == nil
            stream_version = 0
        else
            stream_version = startingIdentity.streamVersion() + index
        end

        events.each do |domainEvent|
            event_body = JSON.generate(domainEvent.toHash())
            event_type = domainEvent.class.name

            connection.query(
                "INSERT INTO tbl_es_event_store 
                    (event_id, stream_name, stream_version, event_type, event_body)
                    VALUES(#{event_id}, #{stream_name}, #{stream_version}, '#{event_type}', '#{event_body}')")

            index += 1
        end

        notifyDispatchableEvents()
    end

    def eventsSince(lastReceivedEvent)
        connection = connection()

        begin
            event_id = lastReceivedEvent

            result = connection.query(
                "SELECT event_id, event_body, event_type FROM tbl_es_event_store WHERE event_id > #{event_id} ORDER BY event_id"
            )

            return buildEventSequence(result)
        rescue => e
            raise "event since fetch failed because: " + e.message
        end
    end

    def eventStreamSince (identity)
        connection = connection()

        begin
            stream_name = identity.streamName()
            stream_version = identity.streamVersion()

            result = connection.query(
                "SELECT stream_version, event_type, event_body FROM tbl_es_event_store
                    WHERE stream_name = #{stream_name} AND stream_version >= #{stream_version}
                    ORDER BY stream_version")

            eventStream = buildEventStream(result)

            if eventStream.version() == 0 then
                raise "There is no such event stream: "
                        + identity.streamName()
                        + " : "
                        + identity.streamVersion()
            end

            return eventStream
        rescue
            raise "event stream since"
        end
    end

    def fullEventStreamFor(identity)
        # TODO: Implement fullEventStreamFor() method.
    end

    def purge
        # TODO: Implement purge() method.
    end

    def registerEventNotifiable(eventNotifiable)
        @eventNotifiable = eventNotifiable
    end

    def collaborationDataSource()
        return @collaborationDataSource
    end

    def setCollaborationDataSource(aDataSource)
        @collaborationDataSource = aDataSource
    end

    def connection()
        connection = nil

        begin
            connection = @collaborationDataSource.getConnection()
        rescue => e
            p e
            raise "Cannot acquire database connection."
            return connection
        end
    end

    def buildEventSequence(results)
        events = []

        results.each do |row|
            eventClassName = row["event_type"]

            domainEvent = Module.const_get(eventClassName).fromHash JSON.parse row["event_body"]

            events.push DispatchableDomainEvent.new(row["event_id"], domainEvent)
        end

        return events
    end

    def buildEventStream(results)
        events = []
        version = 0

        results.each do |stream_version, event_type, event_body|
            # domainEvent = eventClassName.fromArray(json_decode(event_body, true))

            events.push domainEvent
        end

        return DefaultEventStream.new(events, version)
    end

    def eventNotifiable()
        return @eventNotifiable
    end

    def notifyDispatchableEvents()
        eventNotifiable = eventNotifiable()

        unless eventNotifiable == nil
            eventNotifiable.notifyDispatchableEvents()
        end
    end
end
