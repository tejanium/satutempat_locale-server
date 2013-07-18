require 'spec_helper'

describe SatutempatLocale::PullHandler do
  before :each do
    Time.stub now: 100
  end

  def basename
    File.method :basename
  end

  describe '#perform!' do
    context 'tar' do
      after :each do
        File.delete '100.tar'
      end

      it 'tar folder' do
        lambda{
          SatutempatLocale::PullHandler.new('spec/fixtures').perform!
        }.should change { File.exist? '100.tar' }.from(false).to(true)
      end

      context 'folder content' do
        after :each do
          FileUtils.rm_rf('unpacked')
        end

        it 'have extra file, marker' do
          SatutempatLocale::PullHandler.new('spec/fixtures').perform!

          Archive::Tar::Minitar.unpack('100.tar', 'unpacked')

          ls = Dir['unpacked/spec/fixtures/.*']

          ls.should_not be_empty
          ls.map(&basename).should be_include '.last_update'
        end

        it 'extra file should contain time' do
          stub_global_marker 100

          SatutempatLocale::PullHandler.new('spec/fixtures').perform!

          Archive::Tar::Minitar.unpack('100.tar', 'unpacked')

          File.read('unpacked/spec/fixtures/.last_update').should eql '100'
        end

        it 'have proper file' do
          SatutempatLocale::PullHandler.new('spec/fixtures').perform!

          Archive::Tar::Minitar.unpack('100.tar', 'unpacked')

          Dir['unpacked/spec/fixtures/*'].map(&basename).should eql Dir['spec/fixtures/*'].map(&basename)
        end
      end
    end

    it 'raise error when folder not found' do
      lambda{
        SatutempatLocale::PullHandler.new('invalid/folder').perform!
      }.should raise_error PullRejectedError
    end
  end
end
