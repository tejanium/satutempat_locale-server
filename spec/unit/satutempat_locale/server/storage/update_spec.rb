require 'spec_helper'

describe SatutempatLocale::Server::Storage do
  describe 'update' do
    before :each do
      SatutempatLocale::Server::Storage.import 'spec/fixtures/one_level.yml'
    end

    it 'update global marker' do
      Time.stub now: Time.at(100)
      SatutempatLocale::Server::GlobalMarker.update_marker

      SatutempatLocale::Server::Storage.first.tap do |storage|
        storage.value = 'Hello'
        Time.stub now: Time.at(200)

        lambda{
          storage.save
        }.should change { SatutempatLocale::Server::GlobalMarker.last_update }.from(100).to(200)
      end
    end
  end
end
