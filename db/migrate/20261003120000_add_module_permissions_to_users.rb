class AddModulePermissionsToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :username, :string
    add_column :users, :superuser, :boolean, default: false, null: false

    # El correo deja de ser obligatorio: el usuario puede identificarse con un
    # "username" que no necesariamente es un correo electrónico.
    change_column_null :users, :email, true

    # Los usuarios existentes tenían acceso total al ERP (no existían
    # permisos), por lo que se convierten en superusuarios para que nadie
    # pierda acceso al aplicar la migración.
    execute "UPDATE users SET superuser = 1"

    # Backfill del username a partir del correo existente.
    select_all("SELECT id, email FROM users ORDER BY id").each do |row|
      username = available_username_for(row["email"], row["id"])
      execute "UPDATE users SET username = #{connection.quote(username)} WHERE id = #{row["id"].to_i}"
    end

    add_index :users, :username, unique: true

    create_table :permissions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :module_key, null: false
      t.boolean :can_read, default: false, null: false
      t.boolean :can_write, default: false, null: false

      t.timestamps
    end

    add_index :permissions, %i[ user_id module_key ], unique: true
  end

  def down
    drop_table :permissions

    execute "UPDATE users SET email = username WHERE email IS NULL"
    change_column_null :users, :email, false

    remove_index :users, :username
    remove_column :users, :username
    remove_column :users, :superuser
  end

  private

  # Deriva un username único a partir del correo (parte anterior al "@").
  def available_username_for(email, user_id)
    base = email.to_s.split("@").first.to_s.downcase.gsub(/[^a-z0-9._\-]/, "")
    base = "user#{user_id}" if base.blank?

    candidate = base
    suffix = 1
    while select_value("SELECT id FROM users WHERE username = #{connection.quote(candidate)} LIMIT 1").present?
      suffix += 1
      candidate = "#{base}#{suffix}"
    end

    candidate
  end
end
