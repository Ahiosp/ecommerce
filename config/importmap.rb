# Pin npm packages by running ./bin/importmap

pin "application"
pin "bootstrap" # , to: "bootstrap.js", preload: true # @5.3.3
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
pin "turbo", to: "turbo.min.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo-rails.js"
