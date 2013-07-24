require 'spec_helper'

describe SatutempatLocale::Server::Storage do
  describe '.search' do
    before :each do
      SatutempatLocale::Server::Storage.import 'spec/fixtures/three_level.yml'
    end

    def search params
      SatutempatLocale::Server::Storage.search params
    end

    it 'use partial key' do
      result = search(key: 'one')

      result.size.should eql 1
      result.first.key.should eql 'en.number.one'
      result.first.value.should eql 'One'
    end

    it 'use partial key with dot' do
      result = search(key: 'number.one')

      result.size.should eql 1
      result.first.key.should eql 'en.number.one'
      result.first.value.should eql 'One'
    end

    it 'use whole key' do
      result = search(key: 'en.number.one')

      result.size.should eql 1
      result.first.key.should eql 'en.number.one'
      result.first.value.should eql 'One'
    end

    it 'use partial value' do
      result = search(value: 'On')

      result.size.should eql 1
      result.first.key.should eql 'en.number.one'
      result.first.value.should eql 'One'
    end

    it 'use whole value' do
      result = search(value: 'One')

      result.size.should eql 1
      result.first.key.should eql 'en.number.one'
      result.first.value.should eql 'One'
    end
  end
end
