RSpec.shared_context "resource tests", type: :resource do

  let(:chef_run) do
    ChefSpec::Runner.new(node_attributes.merge(step_into)).converge(example_recipe)
  end

  let(:node_attributes) do
    {}
  end

  let(:step_into) do
    { step_into: [cookbook_name] }
  end

  let(:node) { chef_run.node }

  let(:example_recipe) do
    fail %(
Please specify the name of the test recipe that executes your resource:

    let(:example_recipe) do
      "ark_spec::put"
    end

)
  end

  def described_cookbook_and_recipe
    described_recipe.split("::", 2)
  end

  alias_method :cookbook_name, :described_cookbook

  def recipe_name
    described_cookbook_and_recipe.last
  end

end