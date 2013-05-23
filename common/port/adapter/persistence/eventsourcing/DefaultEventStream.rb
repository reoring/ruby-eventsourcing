class DefaultEventStream < EventStream
    @events
    @version

    def initialize(eventsList, version)
        @setEvents(eventsList)
        @setVersion(version)
    end

    def events()
        return @events
    end

    def version()
    {
        return @version
    }

    private
    def setEvents(eventsList)
        @events = eventsList
    end

    private 
    def setVersion(version)
        @version = version
    end
end
