class UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update destroy ]

  def index
    @users = User.includes(:permissions).ordered
    @superusers_count = @users.count(&:superuser?)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.role = :admin if @user.superuser?

    if save_user_with_permissions
      redirect_to users_path, notice: "Usuario creado correctamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if removing_own_superuser_access?
      redirect_to edit_user_path(@user),
                  alert: "No puedes quitarte a ti mismo el acceso de superusuario."
      return
    end

    @user.role = :admin if @user.superuser?

    if save_user_with_permissions
      redirect_to users_path, notice: "Usuario actualizado correctamente.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @user == current_user
      redirect_to users_path, alert: "No puedes eliminar tu propio usuario."
    elsif @user.superuser? && User.superusers.count <= 1
      redirect_to users_path, alert: "El sistema debe conservar al menos un superusuario."
    else
      @user.destroy!
      redirect_to users_path, notice: "Usuario eliminado correctamente.", status: :see_other
    end
  end

  private

  def set_user
    @user = User.find(params.expect(:id))
  end

  # Guarda usuario y permisos dentro de una misma transacción.
  def save_user_with_permissions
    saved = false

    ActiveRecord::Base.transaction do
      if @user.save
        @user.sync_module_permissions!(permissions_params)
        saved = true
      else
        raise ActiveRecord::Rollback
      end
    end

    saved
  rescue ActiveRecord::RecordInvalid => e
    @user.errors.add(:base, e.record.errors.full_messages.to_sentence)
    false
  end

  def removing_own_superuser_access?
    return false unless @user == current_user && current_user.superuser?

    !ActiveModel::Type::Boolean.new.cast(permitted_user_params[:superuser])
  end

  def user_params
    permitted_user_params.except(:permissions)
  end

  def permissions_params
    permitted_user_params[:permissions] || {}
  end

  def permitted_user_params
    @permitted_user_params ||= params.require(:user).permit(
      :username, :email, :password, :password_confirmation, :superuser, :role,
      permissions: {}
    )
  end
end
