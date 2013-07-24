require 'spec_helper'

describe SatutempatLocale::Server::Storage do
  describe '.export' do
    DUMPSTER = 'spec/dump.yml'

    after :each do
      File.delete DUMPSTER if File.exist? DUMPSTER
    end

    context 'three level' do
      before :each do
        SatutempatLocale::Server::Storage.import 'spec/fixtures/three_level.yml'
      end

      it 'export all data to yml' do
        SatutempatLocale::Server::Storage.export 'spec/fixtures/three_level.yml', DUMPSTER

        YAML.load_file(DUMPSTER).should eq YAML.load_file('spec/fixtures/three_level.yml')
      end

      it 'export all data to some folder that does not exist' do
        SatutempatLocale::Server::Storage.export 'spec/fixtures/three_level.yml', 'dumpster/dump.yml'

        YAML.load_file('dumpster/dump.yml').should eq YAML.load_file('spec/fixtures/three_level.yml')

        FileUtils.rm_rf 'dumpster'
      end
    end

    context 'multi level' do
      before :each do
        SatutempatLocale::Server::Storage.import 'spec/fixtures/two_level.yml'
        SatutempatLocale::Server::Storage.import 'spec/fixtures/three_level.yml'
      end

      it 'only export two_level' do
        SatutempatLocale::Server::Storage.export 'spec/fixtures/two_level.yml', DUMPSTER

        YAML.load_file(DUMPSTER).should eq YAML.load_file('spec/fixtures/two_level.yml')
      end

      it 'only export three_level' do
        SatutempatLocale::Server::Storage.export 'spec/fixtures/three_level.yml', DUMPSTER

        YAML.load_file(DUMPSTER).should eq YAML.load_file('spec/fixtures/three_level.yml')
      end
    end
  end
end
