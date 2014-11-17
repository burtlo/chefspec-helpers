# Chefspec::Helpers

Provides helper methods and shared RSpec contexts to take some of the tedium
out of the ChefSpec specifications that you write.

* Write recipe specifications with a cleaner syntax
* Test the helper methods you use in your recipes and custom resources with a fake resource object and fake node object.
* Test your custom resources with a cleaner syntax

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chefspec-helpers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chefspec-helpers

## Usage

To demonstrate the benefit of these helpers I will provide the plain ChefSpec
example followed by the example again with the helpers library loaded.

**All ChefSpec syntax is based on version 4.0.0**

### Plain ChefSpec

```ruby
require "spec_helper"

describe "ark::default" do

  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it "installs core packages" do
    expect(chef_run).to install_package("gcc")
  end

end
```

In this example we are attempting to validate Ark cookbook's default recipe.

### With ChefSpec-Helpers

```ruby
require "spec_helper"

describe_recipe "ark::default" do

  it "installs core packages" do
    expect(chef_run).to install_package("gcc")
  end

end
```

First, you'll notice that you use `describe_recipe` instead of `describe`. This
was done to ensure the helpers we are about to add are isolated to particular
specification that we are attempting to validate.

Second, there is not `let(:chef_run)` because that is already defined with an
empty set of node attributes and automatically converging the described recipe
(the text following describe_recipe).

But what about when you want to specify to test on a different platform that
requires you to set node attributes:


### Specifying Node Attributes with Plain ChefSpec

```ruby
require "spec_helper"

describe "ark::default" do

  let(:chef_run) do
    ChefSpec::Runner.new( platform: "windows", version: "2008R2" ).converge(described_recipe)
  end

  it "does not linux packages" do
    expect(chef_run).not_to install_package("gcc")
  end

end
```

### Specifying Node Attributes with ChefSpec-Helpers

```ruby
require "spec_helper"

describe_recipe "ark::default" do

  let(:node_attributes) do
    { platform: "windows", version: "2008R2" }
  end

  it "does not linux packages" do
    expect(chef_run).not_to install_package("gcc")
  end

end
```

Essentially the biggest benefit here reducing the need to continually build and
setup with `let(:chef_run)`. When you want to provide some node attributes you
define them. You are welcome to use a RSpec let (e.g. `let(:node_attributes)`)
or define a method with that name (e.g. def node_attributes).

Lastly, cookbooks often check node attributes to ensure that they have been set
correctly.

### Testing Node Attributes Set in the Cookbook with Plain ChefSpec

```ruby
require "spec_helper"

describe "ark::default" do

  let(:chef_run) do
    ChefSpec::Runner.new( platform: "windows", version: "2008R2" ).converge(described_recipe)
  end

  context "sets default attributes" do

    it "tar binary" do
      node = chef_run.node
      expect(node["ark"]["tar"]).to eq %("\\7-zip\\7z.exe")
    end

  end

end
```

### Testing Node Attributes Set in the Cookbook with ChefSpec-Helpers

```ruby
require "spec_helper"

describe_recipe "ark::default" do

  let(:node_attributes) do
    { platform: "windows", version: "2008R2" }
  end

  context "sets default attributes" do

    it "tar binary" do
      expect(cookbook_attribute("tar")).to eq %("\\7-zip\\7z.exe")
    end

  end

end
```

Here again, the benefit is time saves. Helpers provides a helper method `node`
which is the same as executing `chef_run.node`. And instead of repeating the
cookbook name over and over again within the specifications you can use the
helper `cookbook_attribute` which assumes you are asking for
`node[described_cookbook][attribute_name]`.


## Motivation

For some of you this will make your life easier. Otherse of you will cry that
this is in fact too much "magic". When I sat down and worked through testing a
cookbook I found myself writing a lot of repetition of code I didn't care about
expressing (e.g. Building the ChefSpec runner). So I refactored it into RSpec
contexts which are available now to every group of specs I wrote.

The gem attempts to do the same with testing resources and helpers. I would
also like to extend this to include some testing support for templates, handlers
(delivered in a cookbook), and Ohai plugins (delivered in a cookbook).


## Contributing

1. Fork it ( https://github.com/[my-github-username]/chefspec-helpers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
