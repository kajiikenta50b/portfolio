// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import HelloController from "./hello_controller"
application.register("hello", HelloController)

// app/javascript/controllers/index.js
import { Application } from "@hotwired/stimulus"
import SearchController from "./search_controller"

const application = Application.start()
application.register("search", SearchController)
