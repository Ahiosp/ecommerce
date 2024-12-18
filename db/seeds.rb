require "json"
require "open-uri"

file = File.read(Rails.root.join("db/fixtures/products.json"))
products = JSON.parse(file)

Product.destroy_all

products.each do |product_data|
  puts "Traitement du produit : #{product_data["nom"]}"

  product = Product.create(
    nom: product_data["nom"],
    price_cents: product_data["price_cents"],
    description: product_data["description"],
    disponibilité: product_data["disponibilité"]
  )

  image_url = product_data["image"]
  file = URI.open(image_url)
  product.image.attach(io: file, filename: "#{product.nom}.jpg", content_type: "image/jpg")

  file.close

  puts "Produit créé : #{product_data["nom"]}"
end
