class Board
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String

  references_many :sudokus, :class_name => "BoardSudoku", :stored_as => :array

  validates_presence_of :name

  after_create :assign_sudokus

  def assign_sudokus
    self.sudokus = 5.times{ self.sudokus.create_random }
  end
end