class ConnectionProvider
    @@connectionHolder = nil

    def self.closeConnection()
        begin
            connection = self.connection()

            unless connection == null then
                connection.close()
            end
        rescue
            raise "Cannot close connection because."
        end
    end

    def self.connection(dataSource = nil)
        if dataSource == nil then
            return @@connectionHolder
        end

        connection = self.connection()

        begin
            if connection == nil
                connection = dataSource.getConnection()
                @@connectionHolder = connection
            end
        rescue
            raise "Connection not provided."
        end

        return connection
    end
end