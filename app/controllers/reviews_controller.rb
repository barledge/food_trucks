class ReviewsController < ApplicationController
  def create
    @food_truck = FoodTruck.find(params[:food_truck_id])
    @review = @food_truck.reviews.build(review_params)
    @review.user = current_user
    @user = @review.user

    if @review.save
      # Notify the truck's owner of the new review
      UserMailer.review_notice_email(@review).deliver
      flash[:notice] = 'Your review was saved!'
      redirect_to food_truck_path(@food_truck)
    else
      @food_truck.reviews.delete(@review)
      flash[:notice] = 'Your review could not be saved'
      render 'food_trucks/show'
    end
  end

  def destroy
    @food_truck = FoodTruck.find(params[:food_truck_id])
    @review = Review.find(params[:id])
    if @review.destroy
      flash[:notice] = 'Review deleted!'
      redirect_to food_truck_path(@food_truck)
    end
  end

  def update
    @food_truck = FoodTruck.find(params[:food_truck_id])
    @review = Review.find(params[:id])
    if @review.update(review_params)
      flash[:notice] = 'Changes saved!'
      redirect_to food_truck_path(@food_truck)
    end
  end

  def upvote
    @food_truck = FoodTruck.find(params[:food_truck_id])
    @review = Review.find(params[:id])
    if current_user.voted_up_on? @review
      @review.unliked_by current_user
    else
      @review.liked_by current_user
    end
    redirect_to @food_truck
  end

  def downvote
    @food_truck = FoodTruck.find(params[:food_truck_id])
    @review = Review.find(params[:id])
    if current_user.voted_down_on? @review
      @review.undisliked_by current_user
    else
      @review.downvote_from current_user
    end
    redirect_to @food_truck
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
