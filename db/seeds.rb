
#create admin
User.create! name: "Admin", email: "admin@bmusic.com", phone: "0376542134",
  role: 2, password: "123123", password_confirmation: "123123",
  activated: true, activated_at: Time.zone.now

#create user
20.times do |n|
  email = FFaker::InternetSE.unique.free_email
  name  = FFaker::InternetSE.unique.user_name
  phone = "037365421" << "#{n}"
  role = 1
  password = "123123"
  activated = true
  activated_at = Time.zone.now
  User.create!(email: email, name: name, phone: phone, password: password,
    activated: activated, activated_at: activated_at, role: role)
end

#create category
10.times do |n|
  user_id = n + 1
  name = FFaker::Music.unique.genre
  info = "info"
  Category.create!(user_id: user_id, name: name, info: info)
end

#create songs
# name_songs = [ "dunderpatrullen-singularity",
#           "nobuo-uematsu-the-promise",
#           "lol-bit-rush",
#           "lol-worlds-collide",
#           "hatsune-miku-secret-police",
#           "hatsune-miku-senbonzakura",
#           "hatsune-miku-talent-shredder",
#           "one-punch-man-opening-1",
#         ]
# name_songs.each do |name_song|
#   name = name_song
#   song_url = "https://cdn.zekken.rocks/mp3/#{name_song}.mp3"
#   user_id = 1
#   category_id = 1
#   view = 1856
#   Song.create(name: name, song_url: song_url, user_id: user_id, category_id: category_id, view: view)
# end

# #create album
# 20.times do
#   name = FFaker::Music.album
#   user_id = 1
#   Album.create!(name: name, user_id: user_id)
# end

# 8.times do |n|
#   song_id = n + 1
#   album_id = n + 5
#   AlbumSong.create!(song_id: song_id, album_id: album_id)
# end

10.times do |n|
  name = FFaker::Music.album
  user_id = rand 1..10
  Album.create! name: name,
    user_id: user_id
end
