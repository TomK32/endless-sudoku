require 'spec_helper'

describe Sudoku do
  it { should have_field(:rows).of_type(Array) }
  it { should have_field(:parts).of_type(Array) }
end
