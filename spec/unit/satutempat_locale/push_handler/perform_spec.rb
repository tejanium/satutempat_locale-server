require 'spec_helper'

describe SatutempatLocale::PushHandler do
  describe '#perform!' do
    context 'accepted' do
      it 'client update is more than server\'s' do
        stub_global_marker 20

        lambda{
          SatutempatLocale::PushHandler.new(10, "spec/tar/fixtures.tar").perform!
        }.should change { SatutempatLocale::Storage.count }.from(0).to(10)
      end

      it 'client update is equal with server\'s' do
        stub_global_marker 10

        lambda{
          SatutempatLocale::PushHandler.new(10, "spec/tar/fixtures.tar").perform!
        }.should change { SatutempatLocale::Storage.count }.from(0).to(10)
      end

      it 'create global marker' do
        lambda{
          SatutempatLocale::PushHandler.new(10, "spec/tar/fixtures.tar").perform!
        }.should change { SatutempatLocale::GlobalMarker.count }.from(0).to(1)
      end

      it 'update global marker but do not create new marker' do
        SatutempatLocale::PushHandler.new(10, "spec/tar/fixtures.tar").perform!

        lambda{
          SatutempatLocale::PushHandler.new(10, "spec/tar/fixtures.tar").perform!
        }.should_not change { SatutempatLocale::GlobalMarker.count }.from(1).to(2)
      end

      it 'update global marker' do
        Time.stub now: 10
        SatutempatLocale::PushHandler.new(10, "spec/tar/fixtures.tar").perform!
        SatutempatLocale::GlobalMarker.first.last_update.should eql 10

        Time.stub now: 20
        SatutempatLocale::PushHandler.new(10, "spec/tar/fixtures.tar").perform!
        SatutempatLocale::GlobalMarker.first.reload.last_update.should eql 20
      end
    end

    context 'rejected' do
      it 'client update is less than server\'s' do
        stub_global_marker 10

        lambda{
          SatutempatLocale::PushHandler.new(20, "spec/tar/fixtures.tar").perform!
        }.should raise_error PushRejectedError
      end
    end
  end
end
