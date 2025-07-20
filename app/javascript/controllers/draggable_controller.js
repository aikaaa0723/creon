// app/javascript/controllers/draggable_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("mousedown", this.dragStart.bind(this))
  }

  dragStart(e) {
    const elem = this.element
    let shiftX = e.clientX - elem.getBoundingClientRect().left
    let shiftY = e.clientY - elem.getBoundingClientRect().top

    const moveAt = (pageX, pageY) => {
      elem.style.left = pageX - shiftX + 'px'
      elem.style.top = pageY - shiftY + 'px'
      elem.style.zIndex = 9999
    }

    const onMouseMove = (event) => moveAt(event.pageX, event.pageY)

    document.addEventListener('mousemove', onMouseMove)
    elem.onmouseup = () => {
      document.removeEventListener('mousemove', onMouseMove)
      elem.onmouseup = null
    }
  }
}
