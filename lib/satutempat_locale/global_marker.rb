module SatutempatLocale
  class GlobalMarker
    include ::Mongoid::Document

    field :last_update, type: Integer

    def self.update_marker
      if first
        first.set :last_update, Time.now.to_i
      else
        create last_update: Time.now.to_i
      end
    end


    def self.last_update
      update_marker unless first

      first.last_update
    end
  end
end
