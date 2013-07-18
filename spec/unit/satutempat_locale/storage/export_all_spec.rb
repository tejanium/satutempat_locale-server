require 'spec_helper'

describe SatutempatLocale::Storage do
  describe '.export_all' do
    context 'multi level' do
      DUMPSTER = 'spec/dump.yml'

      before :each do
        SatutempatLocale::Storage.import 'spec/fixtures/two_level.yml'
        SatutempatLocale::Storage.import 'spec/fixtures/three_level.yml'
      end

      it 'export all data to yml' do
        SatutempatLocale::Storage.export_all DUMPSTER

        two_level   = YAML.load_file('spec/fixtures/two_level.yml')
        three_level = YAML.load_file('spec/fixtures/three_level.yml')

        YAML.load_file(DUMPSTER).should eq two_level.merge(three_level)

        File.delete DUMPSTER
      end
    end
  end
end
