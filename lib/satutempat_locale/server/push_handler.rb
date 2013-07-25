module SatutempatLocale
  module Server
    class PushHandler
      def initialize client_last_update, tar_file
        @client_last_update = client_last_update.to_i
        @tar_file           = tar_file
        @unpack_folder      = Time.now.to_i.to_s
      end

      def perform!
        raise PushRejectedError unless can_perform?

        puts 'Unpack files...'
        unpack_file
        puts 'Get files...'
        get_files
        puts 'Import files to database...'
        import_files
        puts 'Cleanup...'
        delete_folder
        puts 'Done.'
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
          in_unpack_folder do
            @files = Dir["**/*.yml"]
          end
        end

        def import_files
          @files.each do |file|
            in_unpack_folder do
              Storage.import file
            end
          end
        end

        def update_global_marker
          GlobalMarker.update_marker
        end

        def can_perform?
          return true if @client_last_update == -1

          GlobalMarker.last_update <= @client_last_update
        end

        def in_unpack_folder
          Dir.chdir @unpack_folder do
            yield
          end
        end
    end
  end
end
