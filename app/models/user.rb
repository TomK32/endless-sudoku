class User
  include Mongoid::Document

  field :name, :type => String
  field :score, :type => Integer, :default => 0
  attr_protected :score

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  def as_json(options = {})
    {:id => self.id.to_s, :name => self.name, :score => self.score}.as_json(options)
  end
end
