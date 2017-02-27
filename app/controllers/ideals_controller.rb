class IdealsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @ideal = current_user.ideal
  end

  def update
    @ideal = current_user.ideal
    @ideal.update_attributes(ideal_params)
    redirect_to edit_ideal_path, notice: "update user config"
  end

  private
  def ideal_params
    params.require(:ideal).permit(
      :user_image, :twitter_post, :twitter_username
    )
  end
end
