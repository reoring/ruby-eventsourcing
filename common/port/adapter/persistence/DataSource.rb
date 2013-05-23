require 'mysql2'

class DataSource
    @connection = nil

    def initialize(host, database, user, password)
        @connection = Mysql2::Client.new(:host     => host,
                                         :username => user,
                                         :password => password,
                                         :database => database)
    end

    def getConnection()
        @connection
    end

    def close()
        @connection = nil
    end
end