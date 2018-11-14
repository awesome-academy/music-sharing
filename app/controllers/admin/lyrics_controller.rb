class Admin::LyricsController < Admin::BaseController
  before_action :load_lyric, except: :index

  def index
    @lyrics = Lyric.load_data.order_date.includes(:song, :user)
      .page(params[:page]).per Settings.page.admin_lyrics
  end

  def show
    respond_to {|format| format.js}
  end

  def update
    if @lyric.accepted?
      if @lyric.accept_lyric false
        flash[:success] = t ".unaccept_successfully"
      else
        flash[:danger] = t ".unaccept_failed"
      end
    else
      if @lyric.accept_lyric true
        flash[:success] = t ".accept_successfully"
      else
        flash[:danger] = t ".accept_failed"
      end
    end
    redirect_to admin_lyrics_url
  end

  def destroy
    if @lyric.destroy
      flash[:success] = t ".delete_successfully"
    else
      flash[:danger] = t ".delete_failed"
    end
    redirect_to admin_lyrics_url
  end

  private

  def load_lyric
    @lyric = Lyric.find_by id: params[:id]
    return if @lyric
    flash[:danger] = t ".no_found_lyric"
    redirect_to admin_lyrics_url
  end
end
