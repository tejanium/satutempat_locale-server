require 'spec_helper'

describe SatutempatLocale::Server::PullHandler do
  before :each do
    Time.stub now: Time.at(100)
  end

  def basename
    File.method :basename
  end

  describe '#perform!' do
    context 'tar' do
      let :pull_handler do
        SatutempatLocale::Server::PullHandler.new('spec/fixtures')
      end

      it 'tar folder' do
        pull_handler.perform!
        File.should be_exist pull_handler.file_path
      end

      context 'folder content' do
        after :each do
          FileUtils.rm_rf('unpacked')
        end

        it 'have extra file, marker' do
          pull_handler.perform!

          Archive::Tar::Minitar.unpack(pull_handler.file_path, 'unpacked')

          ls = Dir['unpacked/spec/fixtures/.*']

          ls.should_not be_empty
          ls.map(&basename).should be_include '.last_update'
        end

        it 'extra file should contain time' do
          stub_global_marker 100

          pull_handler.perform!

          Archive::Tar::Minitar.unpack(pull_handler.file_path, 'unpacked')

          File.read('unpacked/spec/fixtures/.last_update').should eql '100'
        end

        it 'have proper file' do
          pull_handler.perform!

          Archive::Tar::Minitar.unpack(pull_handler.file_path, 'unpacked')

          Dir['unpacked/spec/fixtures/*'].map(&basename).should eql Dir['spec/fixtures/*'].map(&basename)
        end
      end
    end

    it 'raise error when folder not found' do
      lambda{
        SatutempatLocale::Server::PullHandler.new('invalid/folder').perform!
      }.should raise_error PullRejectedError
    end
  end
end
