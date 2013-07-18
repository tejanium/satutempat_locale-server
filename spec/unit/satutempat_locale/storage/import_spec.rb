require 'spec_helper'

describe SatutempatLocale::Storage do
  describe '.import' do
    context 'one level create' do
      it 'create all keys and values' do
        lambda{
          SatutempatLocale::Storage.import 'spec/fixtures/one_level.yml'
        }.should change { SatutempatLocale::Storage.count }.from(0).to(3)
      end

      context 'datas' do
        before :each do
          SatutempatLocale::Storage.import 'spec/fixtures/one_level.yml'
        end

        it 'should have all keys' do
          SatutempatLocale::Storage.all.to_a.map(&:key).sort
            .flatten.should eq ['one', 'two', 'three'].sort
        end

        it 'should have all values' do
          SatutempatLocale::Storage.all.to_a.map(&:value).sort
            .flatten.should eq ['One', 'Two', 'Three'].sort
        end

        it 'should have all file_path' do
          SatutempatLocale::Storage.all.each do |storage|
            storage.file_path.should eql 'spec/fixtures/one_level.yml'
          end
        end
      end
    end

    context 'one level update' do
      before :each do
        SatutempatLocale::Storage.import 'spec/fixtures/one_level.yml'
      end

      it 'create all keys and values' do
        lambda{
          SatutempatLocale::Storage.import 'spec/fixtures/one_level_updated.yml'
        }.should_not change { SatutempatLocale::Storage.count }.from(3).to(6)
      end

      context 'datas' do
        before :each do
          SatutempatLocale::Storage.import 'spec/fixtures/one_level_updated.yml'
        end

        it 'should have all keys' do
          SatutempatLocale::Storage.all.to_a.map(&:key).sort
                            .flatten.should eq ['one', 'two', 'three'].sort
        end

        it 'should not changed values' do
          SatutempatLocale::Storage.all.to_a.map(&:value).sort
                            .flatten.should eq ['One updated', 'Two updated', 'Three updated'].sort
        end
      end
    end

    context 'one level added' do
      before :each do
        SatutempatLocale::Storage.import 'spec/fixtures/one_level.yml'
      end

      it 'create all keys and values' do
        lambda{
          SatutempatLocale::Storage.import 'spec/fixtures/one_level_added.yml'
        }.should change { SatutempatLocale::Storage.count }.from(3).to(4)
      end

      context 'datas' do
        before :each do
          SatutempatLocale::Storage.import 'spec/fixtures/one_level_added.yml'
        end

        it 'should have all keys' do
          SatutempatLocale::Storage.all.to_a.map(&:key).sort
                            .flatten.should eq ['one', 'two', 'three', 'four'].sort
        end

        it 'should not changed values, but add new value' do
          SatutempatLocale::Storage.all.to_a.map(&:value).sort
                            .flatten.should eq ['One updated', 'Two updated', 'Three updated', 'Four'].sort
        end
      end
    end

    context 'two level' do
      it 'create all keys and values' do
        lambda{
          SatutempatLocale::Storage.import 'spec/fixtures/two_level.yml'
        }.should change { SatutempatLocale::Storage.count }.from(0).to(3)
      end

      context 'datas' do
        before :each do
          SatutempatLocale::Storage.import 'spec/fixtures/two_level.yml'
        end

        it 'should have all keys' do
          SatutempatLocale::Storage.all.to_a.map(&:key).sort
                            .flatten.should eq ['number.one', 'number.two', 'number.three'].sort
        end

        it 'should have all values' do
          SatutempatLocale::Storage.all.to_a.map(&:value).sort
                            .flatten.should eq ['One', 'Two', 'Three'].sort
        end
      end
    end

    context 'three level' do
      it 'create all keys and values' do
        lambda{
          SatutempatLocale::Storage.import 'spec/fixtures/three_level.yml'
        }.should change { SatutempatLocale::Storage.count }.from(0).to(3)
      end

      context 'datas' do
        before :each do
          SatutempatLocale::Storage.import 'spec/fixtures/three_level.yml'
        end

        it 'should have all keys' do
          SatutempatLocale::Storage.all.to_a.map(&:key).sort
                            .flatten.should eq ['en.number.one', 'en.number.two', 'en.number.three'].sort
        end

        it 'should have all values' do
          SatutempatLocale::Storage.all.to_a.map(&:value).sort
                            .flatten.should eq ['One', 'Two', 'Three'].sort
        end
      end
    end
  end
end
