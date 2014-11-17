require "chefspec/helpers/version"

RSpec.configure do |config|
  config.alias_example_group_to :describe_recipe, type: :recipe
  config.alias_example_group_to :describe_helpers, type: :helpers
  config.alias_example_group_to :describe_resource, type: :resource
  config.alias_example_group_to :describe_handler, type: :handler
end

def stringify_keys(hash)
  hash.each_with_object({}) do |(k, v), base|
    v = stringify_keys(v) if v.is_a? Hash
    base[k.to_s] = v
    base
  end
end

require "chefspec/helpers/recipe"
require "chefspec/helpers/helper"
require "chefspec/helpers/resource"


