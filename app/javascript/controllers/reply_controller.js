import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  toggle(event) {
    event.preventDefault()
    const commentId = event.currentTarget.dataset.commentId
    const form = document.getElementById(`reply-form-${commentId}`)
    if (form) {
      form.style.display = form.style.display === "none" ? "block" : "none"
    }
  }
}
