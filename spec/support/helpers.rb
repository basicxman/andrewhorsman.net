module Helpers
  def get_config(sym)
    Site::Application.config.send(sym)
  end
end
