require 'json'

$LOAD_PATH.push(File.dirname(__FILE__))

$LOAD_PATH.push('common/event/')
require 'EventStore'
require 'sourcing/DispatchableDomainEvent'

$LOAD_PATH.push('common/port/adapter/')
require 'ApplicationContainer'
require 'persistence/AbstractProjection'
require 'persistence/DataSource'
require 'persistence/ConnectionProvider'
require 'persistence/eventsourcing/mysql/MySQLEventStore'
require 'sourcing/EventStreamId'


$LOAD_PATH.push('sample/domain/model/')
require 'User'
require 'UserRegistered'
require 'DomainRegistry'
require 'UserRepository'

$LOAD_PATH.push('sample/port/adapter/persistence/')
require 'EventStoreUserRepository'
require 'EventStoreProvider'

$LOAD_PATH.push('sample/port/adapter/event/')
require 'FollowStoreEventDispatcher'

$LOAD_PATH.push('sample/port/adapter/persistence/view/')
require 'MySQLProjectionDispatcher'
require 'MySQLSampleView'




dataSource = DataSource.new('localhost', 'ruby_eventsourcing', 'root', 'root')

connection = dataSource.getConnection()
connection.query("DROP TABLE IF EXISTS tbl_es_event_store")
connection.query("CREATE TABLE `tbl_es_event_store` (
				  `event_id` bigint(20) NOT NULL AUTO_INCREMENT,
				  `stream_name` varchar(250) NOT NULL,
				  `stream_version` int(11) NOT NULL,
				  `event_type` varchar(250) NOT NULL,
				  `event_body` mediumtext NOT NULL,
				  PRIMARY KEY (`event_id`),
				  UNIQUE KEY `stream_name_2` (`stream_name`,`stream_version`),
				  KEY `stream_name` (`stream_name`)
				) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;")

connection.query("DROP TABLE IF EXISTS tbl_dispatcher_last_event")
connection.query("CREATE TABLE `tbl_dispatcher_last_event` (
				  `event_id` bigint(20) NOT NULL,
				  PRIMARY KEY (`event_id`)
				) ENGINE=InnoDB;")

connection.query("DROP TABLE IF EXISTS tbl_vw_user_list")
connection.query("CREATE TABLE `tbl_vw_user_list` (
				  `id` bigint(20) NOT NULL,
				  `name` varchar(64) NOT NULL,
				  PRIMARY KEY (`id`)
				) ENGINE=InnoDB;")

ApplicationContainer.instance().set("DataSource", dataSource)
ApplicationContainer.instance().set("MySQLEventStore", MySQLEventStore.new(dataSource))


followStoreEventDispatcher = FollowStoreEventDispatcher.new(dataSource)
mysqlProjectionDispatcher = MySQLProjectionDispatcher.new(followStoreEventDispatcher)
MySQLSampleView.new(mysqlProjectionDispatcher);


user = User.new(1, "reoring")

userRepository = DomainRegistry.UserRepository()
userRepository.save user