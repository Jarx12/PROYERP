require "application_system_test_case"

class DocumentsTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:superuser)
    @document = documents(:one)
  end

  test "visiting the index" do
    visit documents_url

    assert_selector "h1", text: "Repositorio de Documentos"
    assert_selector "td", text: @document.title
  end

  test "should show document" do
    visit document_url(@document)

    assert_selector "h1", text: @document.title
    assert_selector "a", text: "Ver en el navegador"
  end

  test "should update Document" do
    visit edit_document_url(@document)

    fill_in "document_title", with: "Contrato actualizado"
    click_on "Subir Documento"

    assert_text "Document was successfully updated."
    assert_equal "Contrato actualizado", @document.reload.title
  end
end
