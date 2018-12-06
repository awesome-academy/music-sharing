class Admin::DashboardsController < Admin::BaseController
  def index
    @lyrics = Lyric.load_data
  end
end
