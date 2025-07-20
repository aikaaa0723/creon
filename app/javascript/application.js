// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "../assets/stylesheets/application.tailwind.css"
import "controllers"

import { Application } from "@hotwired/stimulus"
import DraggableController from "./controllers/draggable_controller"

const application = Application.start()
application.register("draggable", DraggableController)
