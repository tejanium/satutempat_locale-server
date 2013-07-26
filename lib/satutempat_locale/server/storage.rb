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

      scope :by_key, ->(key) do
        return scoped unless key
        where(key: /#{ key }/)
      end

      scope :by_value, ->(value) do
        return scoped unless value
        where(value: /#{ value }/)
      end

      def self.import file_path
        create_from_hash YAML.load_file(file_path), nil, file_path
      end

      def self.export file_path, file_destination=file_path
        FileUtils.mkdir_p File.dirname file_destination

        dump to_hash(file_path), file_destination
      end

      def self.export_all file_destination
        dump to_hash, file_destination
      end

      def self.to_hash file_path=/.*/
        where(file_path: file_path).to_a.map(&:to_hash).inject(&:deep_merge)
      end

      def self.export_each folder=nil
        proper_folder = "#{ folder }/" if folder

        all.distinct(:file_path).each do |file_path|
          export file_path, "#{ proper_folder }#{ file_path }"
        end
      end

      def self.search params={}
        params = {} if params.nil?

        by_key(params[:key]).by_value(params[:value])
      end

      private
        def self.dump hash, file_destination
          File.open(file_destination, 'w') do |out|
            YAML::ENGINE.yamler = 'syck'
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
