module SatutempatLocale
  class PushHandler
    def initialize client_last_update, tar_file
      @client_last_update = client_last_update.to_i
      @tar_file           = tar_file
      @unpack_folder      = Time.now.to_i.to_s
    end

    def perform!
      raise PushRejectedError unless can_perform?

      unpack_file
      get_files
      import_files
      delete_folder
      update_global_marker
    end

    private
      def unpack_file
        Archive::Tar::Minitar.unpack @tar_file, @unpack_folder
      end

      def delete_folder
        FileUtils.rm_rf @unpack_folder
      end

      def get_files
        @files = Dir["#{ @unpack_folder }/**/*.yml"]
      end

      def import_files
        @files.each do |file|
          Storage.import file
        end
      end

      def update_global_marker
        GlobalMarker.update_marker
      end

      def can_perform?
        GlobalMarker.last_update >= @client_last_update
      end
  end
end
