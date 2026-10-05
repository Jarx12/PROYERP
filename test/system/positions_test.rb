require "application_system_test_case"

# Los cargos se administran desde Configuración; no existe índice ni ficha propia.
class PositionsTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:superuser)
    @position = positions(:one)
  end

  test "should create position" do
    visit settings_path
    open_settings_tab "tab-rrhh"

    assert_selector "#tab-rrhh", text: "Cargos"

    within "#tab-rrhh" do
      click_on "+ Nuevo"
    end

    fill_in "position_title", with: "Analista de Sistemas"
    fill_in "position_description", with: "Soporte tecnológico"
    click_on "Guardar Cargo"

    assert_text "Position was successfully created."
    assert_selector "#tab-rrhh", text: "Analista de Sistemas"
  end

  test "should update Position" do
    visit edit_position_path(@position)

    fill_in "position_title", with: "Gerente de Operaciones"
    click_on "Guardar Cargo"

    assert_text "Position was successfully updated."
    assert_equal "Gerente de Operaciones", @position.reload.title
  end

  test "should destroy Position" do
    visit settings_path
    open_settings_tab "tab-rrhh"

    accept_confirm do
      within "#tab-rrhh" do
        first("form[action='#{position_path(@position)}']").find("button").click
      end
    end

    assert_text "Position was successfully destroyed."
    assert_not Position.exists?(@position.id)
  end
end
