module SatutempatLocale
  module Server
    class Storage
      include ::Mongoid::Document

      after_save :update_global_marker

      with_options type: String do |string|
        string.field :key
        string.field :value
        string.field :file_path
      end

      def self.import file_path
        create_from_hash YAML.load_file(file_path), nil, file_path
      end

      def self.export file_path, file_destination=file_path
        dump to_hash(file_path), file_destination
      end

      def self.export_all file_destination
        dump to_hash, file_destination
      end

      def self.to_hash file_path=/.*/
        where(file_path: file_path).to_a.map(&:to_hash).inject(&:deep_merge)
      end

      private
        def self.dump hash, file_destination
          File.open(file_destination, 'w') do |out|
            YAML.dump hash, out
          end
        end

        def self.set key, value, file_path
          find_or_new_by_key(key).tap do |storage|
            storage.value     = value
            storage.file_path = file_path
          end.save
        end

        def self.find_or_new_by_key key
          where(key: key).first || new(key: key)
        end

        def self.create_from_hash hash, namespace, file_path
          namespaced = "#{ namespace }." if namespace

          hash.each do |key, value|
            namespaced_key = "#{ namespaced }#{ key }"

            if value.is_a? Hash
              create_from_hash value, namespaced_key, file_path
            else
              set namespaced_key, value, file_path
            end
          end
        end

      public
        def to_hash
          inversed_keys = key.split('.').reverse
          hash          = { inversed_keys.shift => value }

          inversed_keys.inject(hash) do |memo, namespaced_key|
            { namespaced_key => memo }
          end
        end

        def update_global_marker
          GlobalMarker.update_marker
        end
    end
  end
end
