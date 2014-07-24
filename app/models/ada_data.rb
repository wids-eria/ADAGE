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

  def self.get_keys
    map = %Q{
      function(){
        for(var key in this) {
         // emit(key, null);
          if( isArray(this[key]) || typeof this[key] == 'object'){
            m_sub(key, this[key]);
          }
        }
      }
      m_sub = function(base, value){
        for(var key in value) {
          emit(base + "." + key, null);
          if( isArray(value[key]) || typeof value[key] == 'object'){
            m_sub(base + "." + key, value[key]);
          }
        }
      }

      isArray = function (v) {
        return v && typeof v === 'object' && typeof v.length === 'number' && !(v.propertyIsEnumerable('length'));
      }
    }

    reduce = %Q{function(key, stuff){ return null; }}
    results = self.all.map_reduce(map,reduce).out(inline:1)

    keys = Array.new
    results.each do |result|
      result.keys.each do |key|
        value = result[key]
        unless keys.include? value
          keys << value
        end
      end
    end

    return keys
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
