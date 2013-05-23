class ApplicationContainer
    @@instances = {}

    def self.instance()
        return ApplicationContainer.new()
    end

    def set(name, instance)
        @@instances.store(name, instance)
    end

    def get(name)
        if @@instances.key(name) then
            raise name + " instance not registered"
        end

        return @@instances[name]
    end
end