# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ---------------------------------------------------------------------------
# Superusuario inicial del ERP.
#
# Puede sobreescribirse con variables de entorno:
#   PROYERP_ADMIN_USERNAME, PROYERP_ADMIN_EMAIL, PROYERP_ADMIN_PASSWORD
# ---------------------------------------------------------------------------
admin_username = ENV.fetch("PROYERP_ADMIN_USERNAME", "admin")
admin_email    = ENV.fetch("PROYERP_ADMIN_EMAIL", "admin@proyerp.com")
admin_password = ENV.fetch("PROYERP_ADMIN_PASSWORD", "proyerp123")

superuser = User.find_by(username: admin_username)

if superuser.nil?
  superuser = User.create!(
    username: admin_username,
    email: admin_email,
    password: admin_password,
    password_confirmation: admin_password,
    superuser: true
  )
  puts "Superusuario creado: #{superuser.username} (#{admin_email})"
else
  superuser.update(superuser: true)
  puts "El superusuario #{superuser.username} ya existía."
end
