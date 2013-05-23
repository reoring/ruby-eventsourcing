module EventSourcedRootEntity
    @mutatingEvents
    @unmutatedVersion

    def initialize(*args, &block)
        @mutatingEvents = []
    end

    def EventSourcedRootEntity.constructWithEventStream(domainEvents, streamVersion)
        #self = (new ReflectionClass(get_called_class())).newInstanceWithoutConstructor()

        p self.class.name

        domainEvents.each do |domainEvent|
            self.mutateWhen(domainEvent)
        end

        self.setUnmutatedVersion(streamVersion)

        return self
    end

    def mutatedVersion()
        return @unmutatedVersion + 1
    end

    def mutatingEvents()
        return @mutatingEvents
    end

    def unmutatedVersion()
        return @unmutatedVersion
    end

    # event is DomainEvent
    def apply(event)
        @mutatingEvents.push event
        mutateWhen(event)
    end

    private
    def mutateWhen(domainEvent)
        eventType = domainEvent.class.name
        mutatorMethodName = "when" + eventType

        begin
            self.method(mutatorMethodName).call domainEvent
        rescue => exc
            raise "Method invoke failed"
        end
    end

    private 
    def setUnmutatedVersion(streamVersion)
        @unmutatedVersion = streamVersion
    end
end

