class EventStoreProvider
    @@eventStore = nil

    def EventStoreProvider.instance()
        return EventStoreProvider.new()
    end

    def eventStore()
        if @@eventStore == nil then
            dataSource = ApplicationContainer.instance().get('DataSource')
            @@eventStore = MySQLEventStore.new(dataSource)
        end

        return @@eventStore
    end
end