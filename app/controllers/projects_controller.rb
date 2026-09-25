class ProjectsController < ApplicationController
  before_action :set_project, only: %i[edit update destroy]

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to settings_path, notice: "Proyecto creado exitosamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @project.update(project_params)
      redirect_to settings_path, notice: "Proyecto actualizado exitosamente."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @project.destroy!
    redirect_to settings_path, notice: "Proyecto eliminado exitosamente.", status: :see_other
  end

  private

  def set_project
    @project = Project.find(params.expect(:id))
  end

  def project_params
    params.require(:project).permit(
      :name, :start_date, :end_date, :location, :customer, :description, :cover_image
    )
  end
end
