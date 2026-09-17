class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase.strip)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_root_path, notice: "Sesión iniciada correctamente."
    else
      flash.now[:alert] = "Correo o contraseña no válidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Has cerrado sesión."
  end
end