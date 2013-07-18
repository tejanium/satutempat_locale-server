module SatutempatLocale
  class PullHandler
    include Archive::Tar

    def initialize folder_path
      @folder_path      = folder_path
      @last_update_file = "#{ normalize_folder_path(folder_path) }/.last_update"
    end

    def perform!
      raise PullRejectedError unless can_perform?

      create_marker
      pack_folder
    end

    private
      def create_marker
        File.open(@last_update_file, "w") do |file|
          file.write GlobalMarker.last_update
        end
      end

      def pack_folder
        File.open(file_name, 'wb') do |tar|
          Minitar.pack(@folder_path, tar)
        end
      end

      def can_perform?
        File.directory? @folder_path
      end

      def file_name
        "#{ Time.now.to_i }.tar"
      end

      def normalize_folder_path folder_path
        folder_path.gsub /\/\z/, ''
      end
  end
end
