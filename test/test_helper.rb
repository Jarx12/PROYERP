ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "fileutils"

# Las vistas de landing page están ignoradas por git (no se rastrean en el
# remoto/CI), así que se generan a partir de sus archivos .example solo para
# poder correr los tests localmente y en CI.
Rails.root.glob("app/views/**/*.example").each do |example|
  real = example.to_s.sub(/\.example\z/, "")
  FileUtils.cp(example, real) unless File.exist?(real)
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

class ActionDispatch::IntegrationTest
  # Contraseña compartida por los usuarios de test/fixtures/users.yml
  TEST_PASSWORD = "secret123".freeze

  # Inicia sesión con el username del usuario (o con su correo si se indica).
  def sign_in_as(user, password: TEST_PASSWORD, identifier: nil)
    post login_path, params: { identifier: identifier || user.username, password: password }
  end
end
