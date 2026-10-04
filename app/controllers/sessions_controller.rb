class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create ]

  def new
  end

  def create
    user = User.authenticate_by_identifier(params[:identifier], params[:password])

    if user
      session[:user_id] = user.id
      redirect_to dashboard_root_path, notice: "Sesión iniciada correctamente."
    else
      flash.now[:alert] = "Usuario o contraseña no válidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Has cerrado sesión."
  end
end
