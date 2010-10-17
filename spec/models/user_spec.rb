require 'spec_helper'

describe User do
  it { should have_field(:name).of_type(String) }
  it { should have_field(:score).of_type(Integer) }
end
