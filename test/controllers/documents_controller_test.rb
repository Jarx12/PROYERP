require "test_helper"

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:superuser)
    @document = documents(:one)
  end

  test "should get index" do
    get documents_url
    assert_response :success
  end

  test "should get new" do
    get new_document_url
    assert_response :success
  end

  test "should create document" do
    assert_difference("Document.count") do
      post documents_url, params: { document: {
        category: "contract", status: "draft", title: "Nuevo contrato",
        file: fixture_file_upload("documento_contrato.txt", "text/plain")
      } }
    end

    assert_redirected_to document_url(Document.order(:id).last)
    assert Document.order(:id).last.file.attached?, "el documento debe quedar con archivo adjunto"
  end

  test "should not create a document without a file" do
    assert_no_difference("Document.count") do
      post documents_url, params: { document: { category: "contract", status: "draft", title: "Sin archivo" } }
    end

    assert_response :unprocessable_content
  end

  test "should show document" do
    get document_url(@document)
    assert_response :success
  end

  test "should get edit" do
    get edit_document_url(@document)
    assert_response :success
  end

  test "should update document" do
    patch document_url(@document), params: { document: { category: @document.category, status: @document.status, title: "Contrato actualizado" } }
    assert_redirected_to document_url(@document)
    assert_equal "Contrato actualizado", @document.reload.title
  end

  test "should destroy document" do
    assert_difference("Document.count", -1) do
      delete document_url(@document)
    end

    assert_redirected_to documents_url
  end
end
