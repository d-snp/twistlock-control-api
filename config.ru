require 'ddp/server/rethinkdb'
require 'twistlock-control'

# A simple messaging API
class RotterdamAPI < DDP::Server::RethinkDB::API
	# Define a module named Collections that exposes subscribable rethinkdb queries
	module Collections
		extend TwistlockControl::Collections
	end

	# Define a module named RPC that exposes RPC methods
	module RPC
		def add_provisioner(properties)
			TwistlockControl::Actions::Provisioner.add(properties)
		end

		def remove_provisioner(id)
			TwistlockControl::Actions::Provisioner.remove(id)
		end
	end
end

config = {
	connection_pool_size: 8,
	connection_pool_timeout: 5,
	host: 'localhost',
	port: 28_015,
	database: 'message'
}

run DDP::Server::RethinkDB::WebSocket.rack(RotterdamAPI, config)
