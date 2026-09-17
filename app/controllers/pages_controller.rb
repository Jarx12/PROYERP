class PagesController < ApplicationController
  skip_before_action :require_login, only: [:home, :about, :contactanos, :proyectos]
  def home
    render layout: false
  end
  def about
    render layout: false
  end
  def contactanos
    render layout: false
  end
  def proyectos
    render layout: false
    @proyectos = defined?(Project) ? Project.order(created_at: :desc) : []
  end
end