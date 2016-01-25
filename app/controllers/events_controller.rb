class EventsController < ApplicationController
  before_action :load_categories, only: [:new, :edit]

  def index
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new event_params
    @event.user = current_user
    thumbnail_file_path = 'abra/event/thumbnail/' + Time.now.strftime("%Y/%m/%d/") + SecureRandom.hex(13) + File.extname(params[:event][:thumbnail].original_filename)
    obj = S3_BUCKET.object(thumbnail_file_path)
    obj.upload_file(params[:event][:thumbnail].tempfile, {
      acl: 'public-read'
    })

    @event.thumbnail_url = obj.public_url

    if @event.save
      render 'show'
    else
      render 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
    if @user.update_attributes(event_params)
      render 'show'
    else
      render 'edit'
    end
  end

  def show
    @event = Event.find(params[:id])
    render 'show'
  end

  private

  def event_params
    params.require(:event).permit(:name, :category_id, :location, :city, :lat, :lng, :start_at, :short_description, :number_of_participant, :required_amount, :donation_due_date, :story)
  end

  def load_categories
    @categories = Category.all_enable
  end
end
