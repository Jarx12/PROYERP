class PagesController < ApplicationController
  skip_before_action :require_login, only: [ :home, :about, :soluciones, :contactanos, :proyectos ]

  def home
  end

  def about
  end

  def soluciones
  end

  def contactanos
  end

  def proyectos
    @proyectos = Project.order(created_at: :desc)
  end
end
