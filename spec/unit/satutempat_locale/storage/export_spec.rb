require 'spec_helper'

describe SatutempatLocale::Storage do
  describe '.export' do
    DUMPSTER = 'spec/dump.yml'

    after :each do
      File.delete DUMPSTER
    end

    context 'three level' do
      before :each do
        SatutempatLocale::Storage.import 'spec/fixtures/three_level.yml'
      end

      it 'export all data to yml' do
        SatutempatLocale::Storage.export 'spec/fixtures/three_level.yml', DUMPSTER

        YAML.load_file(DUMPSTER).should eq YAML.load_file('spec/fixtures/three_level.yml')
      end
    end

    context 'multi level' do
      before :each do
        SatutempatLocale::Storage.import 'spec/fixtures/two_level.yml'
        SatutempatLocale::Storage.import 'spec/fixtures/three_level.yml'
      end

      it 'only export two_level' do
        SatutempatLocale::Storage.export 'spec/fixtures/two_level.yml', DUMPSTER

        YAML.load_file(DUMPSTER).should eq YAML.load_file('spec/fixtures/two_level.yml')
      end

      it 'only export three_level' do
        SatutempatLocale::Storage.export 'spec/fixtures/three_level.yml', DUMPSTER

        YAML.load_file(DUMPSTER).should eq YAML.load_file('spec/fixtures/three_level.yml')
      end
    end
  end
end
