class EventStreamId
	@streamName
    @streamVersion

    def initialize(streamName, streamVersion)
    	@streamName = streamName
    	@streamVersion = streamVersion
    end

    def streamName
        return @streamName
	end

    def streamVersion
        return @streamVersion
    end

    private
    def setStreamName(streamName)
        @streamName = streamName;
    end

    private
    def setStreamVersion(streamVersion)
        @streamVersion = streamVersion;
    end
end