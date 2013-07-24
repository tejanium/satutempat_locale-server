require 'spec_helper'

describe SatutempatLocale::Server::Storage do
  describe '.export_each' do
    context 'multi level' do
      before :each do
        SatutempatLocale::Server::Storage.import 'spec/fixtures/one_level.yml'
        SatutempatLocale::Server::Storage.import 'spec/fixtures/two_level.yml'
        SatutempatLocale::Server::Storage.import 'spec/fixtures/three_level.yml'
      end

      after :each do
        FileUtils.rm_rf 'dumpster'
      end

      it 'export each level to specific folder' do
        lambda{
          SatutempatLocale::Server::Storage.export_each 'dumpster'
        }.should change { File.directory? 'dumpster' }.from(false).to(true)
      end

      it 'have proper structure' do
        SatutempatLocale::Server::Storage.export_each 'dumpster'
        dumpster = `ls dumpster/spec/fixtures`.split($/)
        fixtures = `ls spec/fixtures`.split($/)

        (dumpster & fixtures).should eql dumpster
      end
    end
  end
end
