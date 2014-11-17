RSpec.shared_context "recipe tests", type: :recipe do

  let(:chef_run) { ChefSpec::Runner.new(node_attributes).converge(described_recipe) }

  let(:node) { chef_run.node }

  let(:node_attributes) do
    {}
  end

  def described_cookbook_and_recipe
    described_recipe.split("::", 2)
  end

  alias_method :cookbook_name, :described_cookbook

  def recipe_name
    described_cookbook_and_recipe.last
  end

  def cookbook_attribute(attribute_name)
    node[described_cookbook][attribute_name]
  end

end