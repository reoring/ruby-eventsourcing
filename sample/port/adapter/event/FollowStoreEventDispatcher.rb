class FollowStoreEventDispatcher # implements EventDispatcher, EventNotifiable
    @collaborationDataSource
    @lastDispatchedEventId
    @registeredDispatchers

    def initialize(dataSource)
        setCollaborationDataSource(dataSource)
        setRegisteredDispatchers([])

        EventStoreProvider.instance()
                          .eventStore()
                          .registerEventNotifiable(self)

        setLastDispatchedEventId(queryLastDispatchedEventId())

        notifyDispatchableEvents()
    end

    def dispatch(aDispatchableDomainEvent)
        registeredDispatchers().each do |eventDispatcher|
            eventDispatcher.dispatch(aDispatchableDomainEvent)
        end
    end

    def registerEventDispatcher(anEventDispatcher)
        @registeredDispatchers.push anEventDispatcher
    end

    def understands(aDispatchableDomainEvent)
        return true
    end

    def notifyDispatchableEvents()
        connection =
            ConnectionProvider.connection(collaborationDataSource())

        undispatchedEvents =
            EventStoreProvider.instance()
                              .eventStore()
                              .eventsSince(lastDispatchedEventId())

        if undispatchedEvents.length == 0 then
            return # nothing to do
        end

        undispatchedEvents.each do |event|
            dispatch(event)
        end

        withLastEventId = undispatchedEvents[undispatchedEvents.length - 1]

        lastDispatchedEventId = withLastEventId.eventId()

        setLastDispatchedEventId(lastDispatchedEventId)
        saveLastDispatchedEventId(connection, lastDispatchedEventId)
    end

    private
    def collaborationDataSource()
        return @collaborationDataSource
    end

    private
    def setCollaborationDataSource(dataSource)
        @collaborationDataSource = dataSource
    end

    private
    def connection()
        connection = nil

        begin
            connection = ConnectionProvider.connection(collaborationDataSource())
        rescue => e
            raise "Cannot acquire database connection because: " + e.message
        end

        return connection;
    end

    private
    def setRegisteredDispatchers(dispatchers)
        @registeredDispatchers = dispatchers
    end

    private
    def lastDispatchedEventId()
        return @lastDispatchedEventId
    end

    private
    def setLastDispatchedEventId(aLastDispatchedEventId)
        @lastDispatchedEventId = aLastDispatchedEventId
    end

    private
    def queryLastDispatchedEventId()
        lastHandledEventId = 0

        result = nil

        begin
            result = connection().query("select max(event_id) as last_dispatched_event_id from tbl_dispatcher_last_event")

            if result.count == 0 then
                saveLastDispatchedEventId(connection, 0)
            else
                result = result.first["last_dispatched_event_id"]

                if result == nil then
                    result = 0
                end

                lastHandledEventId = result
            end
        rescue => e
            raise "Cannot query last dispatched event because: " + e.message
        end

        return lastHandledEventId
    end

    private
    def saveLastDispatchedEventId(aConnection, aLastDispatchedEventId)
        updated = 0

        result = nil

        begin
            event_id = aLastDispatchedEventId

            result = aConnection.query("update tbl_dispatcher_last_event set event_id=#{event_id}")

            if result == nil
                updated = 0
            else
                updated = result.count
            end
        rescue => e
            raise "Cannot update dispatcher last event because: " + e.message
        end

        if updated == 0 then
            begin
                event_id = aLastDispatchedEventId
                aConnection.query("insert into tbl_dispatcher_last_event values(#{event_id})")
            rescue => e
                 raise "Cannot insert dispatcher last event because: " + e.message
            end
        end
    end

    private
    def registeredDispatchers()
        return @registeredDispatchers
    end
end