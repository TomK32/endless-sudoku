class Board
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String

  references_many :sudokus, :class_name => "BoardSudoku"

  validates_presence_of :name

  after_create :assign_sudokus

  def assign_sudokus
    self.sudokus = 5.times.collect do |i|
      self.sudokus.create_random(:board_id => self.id, :lng => i, :lat => i)
    end
  end

  def as_json(options = {})
    attributes.reject{|k,v| %w(_id).include?(k)}.merge(
      :sudokus => self.sudokus.collect(&:as_json),
      :id => self.id
    ).as_json(options)
  end

end