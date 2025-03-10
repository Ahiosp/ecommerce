// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "bootstrap";
import "../stylesheets/application.scss"
// import Rails from "rails-ujs";
// Rails.start();
import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

window.Stimulus = Application.start()
const context = require.context("controllers", true, /.js$/)
Stimulus.load(definitionsFromContext(context))
