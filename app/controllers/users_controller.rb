class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])

    # Получаем все оценки, которые поставил именно этот пользователь
    @user_values = Value.where(user_id: @user.id).includes(:image)

    # Сложная логика из Части 1: выбираем только те оценки,
    # которые отличаются от средней оценки сообщества не более чем на 25%
    @expert_values = @user_values.select do |val|
      if val.image.ave_value.present? && val.image.ave_value > 0
        # Вычисляем процент расхождения между оценкой юзера и средней оценкой
        diff_percent = (val.value - val.image.ave_value).abs / val.image.ave_value
        diff_percent <= 0.25 # Не более 25%
      else
        false
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user # Автоматически входим в систему после регистрации
        flash[:success] = "Добро пожаловать в приложение Experteese!"
        format.html { redirect_to work_path } # Сразу отправляем в рабочую область
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
