require 'spec_helper'

describe SatutempatLocale::Server::Config do
  before :each do
    SatutempatLocale::Server.reset_configuration
  end

  context 'override' do
    before :each do
      SatutempatLocale::Server.configure do |config|
        config.locale_path  = 'anywhere/else'
      end
    end

    it 'locale_path goes to anywhere/else' do
      SatutempatLocale::Server.configuration.locale_path.should eql 'anywhere/else'
    end
  end
end
