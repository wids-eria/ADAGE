class AdaData
  include Mongoid::Document
  include Mongoid::Timestamps

  before_validation :set_collection

  field :game, type: String
  field :user_id, type: Integer

  index user_id: 1
  index gameName: 1
  index created_at: 1
  index name: 1
  index key: 1, schema: 1

  def user=(user)
    self.user_id = user.id
  end

  def user
    User.find(self.user_id)
  end

  def self.with_game(gameName = "ada_data")
    with(collection: gameName.to_s.gsub(' ', '_').downcase)
  end

  def self.include_filters(filters = @filters)
    puts "-"*20
    puts filters.to_json

    where(filters)
  end

  def set_collection
    game_name = 'ada_data'

    #icky code needed for backwards compatibility with GLS applications
    if self.respond_to?('gameName')
      game_name = self.gameName
    end

    if self.respond_to?('application_name')
      game_name = self.application_name
    end
    
    with(collection: game_name.gsub(' ', '_').downcase)
  end
end
