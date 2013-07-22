class LocalesController < ActionController::Base
  def download
    pull_handler.perform!
    send_file pull_handler.file_path
  end

  def upload
    push_handler.perform!
    render nothing: true, head: 200
  end

  private
    def client_last_update
      params[:mark]
    end

    def tar_file
      params[:file].tempfile
    end

    def pull_handler
      @pull_handler ||= SatutempatLocale::Server::PullHandler.new 'config/locales'
    end

    def push_handler
      @push_handler ||= SatutempatLocale::Server::PushHandler.new(client_last_update, tar_file)
    end
end
