module SatutempatLocale
  module Server
    class PullHandler
      include Archive::Tar

      def initialize folder_path
        @folder_path      = folder_path
        @last_update_file = "#{ normalize_folder_path(folder_path) }/.last_update"
      end

      def perform!
        puts 'Export from database...'
        export_each

        raise PullRejectedError unless can_perform?
        puts 'Create marker...'
        create_marker
        puts 'Pack folder...'
        pack_folder
        puts 'Done.'
      end

      def file_path
        @file_path
      end

      private
        def export_each
          Storage.export_each SatutempatLocale::Server.configuration.locale_path
        end

        def create_marker
          File.open(@last_update_file, "w") do |file|
            file.write GlobalMarker.last_update
          end
        end

        def pack_folder
          Tempfile.open(file_name) do |tar|
            @file_path = tar.path

            in_folder_path do
              Minitar.pack('.', tar)
            end
          end
        end

        def file_name
          @file_name ||= "#{ Time.now.to_i }.tar"
        end

        def can_perform?
          File.directory? @folder_path
        end

        def normalize_folder_path folder_path
          folder_path.gsub /\/\z/, ''
        end

        def in_folder_path
          Dir.chdir @folder_path do
            yield
          end
        end
    end
  end
end
