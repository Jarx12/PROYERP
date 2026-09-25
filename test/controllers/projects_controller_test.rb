require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  # The application-wide fixture set currently includes an invalid employee
  # position association. These tests use the database transaction directly.
  self.fixture_table_names = []

  setup do
    @user = User.create!(
      email: "projects-test-#{SecureRandom.hex(4)}@example.com",
      password: "password123"
    )

    post login_path, params: { email: @user.email, password: "password123" }
  end

  test "should show the new project form" do
    get new_project_path

    assert_response :success
    assert_select "form[action=?]", projects_path
    assert_select "input[name='project[name]']"
    assert_select "input[type='submit'][value=?]", "Guardar Proyecto"
  end

  test "should show project management actions in settings" do
    project = create_project

    get settings_path

    assert_response :success
    assert_select "#tab-proyectos a[href=?]", new_project_path, text: /Crear Proyecto/
    assert_select "#tab-proyectos a[href=?]", edit_project_path(project), text: "Editar"
    assert_select "#tab-proyectos form[action=?]", project_path(project)
    assert_select "#tab-proyectos form[action=?] input[name=?][value=?]",
      project_path(project), "_method", "delete"
    assert_select "#tab-proyectos form[action=?]", projects_path, count: 0
  end

  test "should create a project" do
    assert_difference("Project.count") do
      post projects_path, params: {
        project: {
          name: "Red administrativa",
          start_date: "2026-01-15",
          end_date: "2026-04-30",
          location: "Caracas",
          customer: "Cliente de prueba",
          description: "Descripción del proyecto"
        }
      }
    end

    assert_redirected_to settings_path
    assert_equal "Proyecto creado exitosamente.", flash[:notice]

    project = Project.find_by!(name: "Red administrativa")
    assert_equal Date.new(2026, 1, 15), project.start_date
    assert_equal Date.new(2026, 4, 30), project.end_date
    assert_equal "Caracas", project.location
    assert_equal "Cliente de prueba", project.customer
    assert_equal "Descripción del proyecto", project.description
  end

  test "should show the edit form" do
    project = create_project(name: "Proyecto original")

    get edit_project_path(project)

    assert_response :success
    assert_select "form[action=?]", project_path(project)
    assert_select "input[name='project[name]'][value=?]", "Proyecto original"
    assert_select "input[type='submit'][value=?]", "Actualizar Proyecto"
  end

  test "should update a project" do
    project = create_project(name: "Proyecto original")

    patch project_path(project), params: {
      project: {
        name: "Proyecto actualizado",
        customer: "Cliente actualizado",
        description: "Descripción actualizada"
      }
    }

    assert_redirected_to settings_path
    assert_equal "Proyecto actualizado exitosamente.", flash[:notice]
    assert_equal "Proyecto actualizado", project.reload.name
    assert_equal "Cliente actualizado", project.customer
    assert_equal "Descripción actualizada", project.description
  end

  test "should destroy a project" do
    project = create_project

    assert_difference("Project.count", -1) do
      delete project_path(project)
    end

    assert_redirected_to settings_path
    assert_equal "Proyecto eliminado exitosamente.", flash[:notice]
  end

  test "should redisplay the new form when creation validation fails" do
    assert_no_difference("Project.count") do
      post projects_path, params: { project: { name: "" } }
    end

    assert_response :unprocessable_content
    assert_select "form[action=?]", projects_path
    assert_select ".form-alert--danger li", minimum: 1
  end

  test "should redisplay the edit form when update validation fails" do
    project = create_project(name: "Proyecto original")

    patch project_path(project), params: { project: { name: "" } }

    assert_response :unprocessable_content
    assert_select "form[action=?]", project_path(project)
    assert_select ".form-alert--danger li", minimum: 1
  end

  private

  def create_project(attributes = {})
    Project.create!({
      name: "Proyecto de prueba",
      start_date: Date.new(2026, 1, 1),
      end_date: Date.new(2026, 2, 1),
      location: "Caracas",
      customer: "Cliente"
    }.merge(attributes))
  end
end
