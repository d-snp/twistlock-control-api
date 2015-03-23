require 'ddp/server/rethinkdb'
require 'twistlock_control'

# A simple messaging API
class RotterdamAPI < DDP::Server::API
	include DDP::Server::RethinkDB::Helpers

	def initialize
		TwistlockControl.configure(database_name: 'twistlock_control_dev')
		super
	end

	def new_connection
		TwistlockControl.new_connection
	end

	# Define a module named Collections that exposes subscribable rethinkdb queries
	module Collections
		def provisioners
			TwistlockControl::Collections.provisioners
		end

		def services
			TwistlockControl::Collections.services
		end

		def service_instances
			TwistlockControl::Collections.service_instances
		end

		def container_instances
			TwistlockControl::Collections.container_instances
		end
	end

	# Define a module named RPC that exposes RPC methods
	module RPC
		def add_provisioner(properties)
			TwistlockControl::Actions::Provisioner.add(properties).serialize
		end

		def remove_provisioner(id)
			TwistlockControl::Actions::Provisioner.remove(id)
		end
	end
end

run DDP::Server::WebSocket.rack(RotterdamAPI)
