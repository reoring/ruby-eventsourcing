class AbstractProjection
    protected
    def projectWhen(aDispatchableDomainEvent)
        return unless understands(aDispatchableDomainEvent)

        domainEvent = aDispatchableDomainEvent.domainEvent()

        eventType = domainEvent.class.name

        mutatorMethodName = "when" + eventType

        begin
            self.method(mutatorMethodName).call domainEvent
        rescue => e
            raise "method invoke failed: " + e.message
        end
    end
end