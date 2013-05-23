class MySQLProjectionDispatcher #implements EventDispatcher
    @registeredProjections

    def initialize(aParentEventDispatcher)
        aParentEventDispatcher.registerEventDispatcher(self)

        setRegisteredProjections([])
    end

    def dispatch(aDispatchableDomainEvent)
        @registeredProjections.each do |projection|
            projection.dispatch(aDispatchableDomainEvent)
        end
    end

    def registerEventDispatcher(aProjection)
        @registeredProjections.push aProjection
    end

    def understands(aDispatchableDomainEvent)
        return true
    end

    private
    def setRegisteredProjections(aDispatchers)
        @registeredProjections = aDispatchers
    end
end