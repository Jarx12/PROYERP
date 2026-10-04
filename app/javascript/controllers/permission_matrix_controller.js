import { Controller } from "@hotwired/stimulus"

// Mantiene coherente la matriz de permisos del panel de usuarios:
//   · marcar "Escribir" activa "Leer"
//   · desmarcar "Leer" desactiva "Escribir"
export default class extends Controller {
  static targets = ["read", "write"]

  connect() {
    this.readTargets.forEach((read) => this.syncRow(read))
    this.writeTargets.forEach((write) => this.syncRow(write))
  }

  change(event) {
    if (!event.target.matches(".perm-checkbox")) return
    this.syncRow(event.target)
  }

  syncRow(checkbox) {
    const row = checkbox.closest("[data-permission-row]")
    if (!row) return

    const read = row.querySelector('[data-permission-matrix-target="read"]')
    const write = row.querySelector('[data-permission-matrix-target="write"]')

    if (checkbox.dataset.permissionMatrixTarget === "write") {
      if (write.checked) read.checked = true
    } else if (!read.checked) {
      write.checked = false
    }

    row.classList.toggle("perm-row--write", write.checked)
    row.classList.toggle("perm-row--read", !write.checked && read.checked)
  }
}