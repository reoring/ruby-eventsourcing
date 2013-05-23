class MySQLSampleView < AbstractProjection
    @@understoodEventTypes = ['UserRegistered']

    def initialize(aParentEventDispatcher)
        aParentEventDispatcher.registerEventDispatcher(self)
    end

	def dispatch(aDispatchableDomainEvent)
        projectWhen(aDispatchableDomainEvent)
    end

	def registerEventDispatcher(anEventDispatcher)
        raise "Cannot register additional dispatchers."
    end

	def understands(aDispatchableDomainEvent)
        eventClass = aDispatchableDomainEvent.domainEvent.class.name
        return @@understoodEventTypes.include?(eventClass)
    end

    def whenUserRegistered(event)
        user_id = event.userId()
        user_name = event.userName()

        connection = ConnectionProvider.connection()
		connection.query("INSERT INTO tbl_vw_user_list(`id`, `name`) VALUES(#{user_id}, '#{user_name}')");
    end
end