# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

users = [
    "Andi",
    "Budi",
    "Caca",
    "Dedi",
    "Euis",
    "Fafa",
    "Gaga",
    "Hadi",
    "Ika",
    "Joko"
]

users.each do |user|
    username = user.downcase
    pass = BCrypt::Password.create(username + "123")
    user = User.create(name: user, username: username, password: pass)
    
    wallet = Wallet.create(address: SecureRandom.hex(10), user_id: user.id)
end