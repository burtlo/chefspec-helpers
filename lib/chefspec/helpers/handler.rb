require 'chef/handler'


# I could look at the currenting working directory -- however I would run
# into problems if you ran this in a directory above your cookbooks
current_directory = Dir.pwd

handler_paths = [ File.join(current_directory,"files","default") ]

handler_paths.each do |handler_path|
  $LOAD_PATH.push(handler_path) unless $LOAD_PATH.include?(handler_path)
end

# TODO: load all the ruby files in the handler paths instead of requiring each one
require "handlers/email_handler"


RSpec.shared_context "handler tests", type: :handler do

  let(:described_handler) { Module.const_get described_recipe }
  let(:subject) { described_handler.new(to_address,from_address) }

  let(:node) { stub_node }

  let(:events) { [] }

  let(:run_status) do
    Chef::RunStatus.new(node, events)
  end

end