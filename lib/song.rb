
# class Song
#   attr_accessor :name
#   attr_reader :artist, :genre
#
#   @@all = []
#
#
#   def initialize(name, artist=nil, genre=nil)
#     @name = name
#
#     if !artist.nil?
#       self.artist = artist
#     end
#
#     if !genre.nil?
#       self.genre = genre
#     end
#   end
#
#
#   def genre=(genre)
#     @genre = genre
#
#     if !@genre.songs.include? self
#       @genre.songs << self
#     end
#   end
#
#
#   def artist=(artist)
#     @artist = artist
#     @artist.add_song(self)
#     @artist
#   end
#
#
#   def self.all
#     @@all
#   end
#
#
#   def self.destroy_all
#     @@all.clear
#   end
#
#
#   def save
#     @@all << self
#   end
#
#
#   def self.find_by_name(name)
#     @@all.detect do |song|
#       song.name == name
#     end
#   end
#
#
#   def self.find_or_create_by_name(name)
#     if self.find_by_name(name) == nil
#       self.create(name)
#     else
#       self.find_by_name(name)
#     end
#   end
#
#
#   def self.create(name)
#     song = self.new(name)
#     song.save
#     song
#   end
#
#
#   def self.new_from_filename(filename)
#     filename_arr = filename.split(" - ")
#
#     artist_name = filename_arr[0]
#     song_name = filename_arr[1]
#     genre_name = filename_arr[2].gsub(".mp3", "")
#
#     genre_inst = Genre.find_or_create_by_name(genre_name)
#     artist_inst = Artist.find_or_create_by_name(artist_name)
#
#     song_inst = Song.new(song_name, artist_inst, genre_inst)
#   end
#
#
#   def self.create_from_filename(filename)
#     song = Song.new_from_filename(filename)
#     song.save
#     song
#   end
# end




class Song
  attr_accessor :name
  attr_reader :artist, :genre

  @@all = []

  def initialize(name, artist = nil, genre = nil)
    @name = name
    self.artist = artist if artist
    self.genre = genre if genre
  end

  def artist=(artist)
    @artist = artist
    artist.add_song(self)
  end

  def genre=(genre)
    @genre = genre
    genre.songs << self unless genre.songs.include?(self)
  end

  def self.all
    @@all
  end

  def self.destroy_all
    all.clear
  end

  def save
    self.class.all << self
  end

  def self.create(name)
    song = new(name)
    song.save
    song

    # Or, as a one-liner:
    # new(name).tap{ |s| s.save }
  end

  def self.find_by_name(name)
    all.detect{ |s| s.name == name }
  end

  def self.find_or_create_by_name(name)
    find_by_name(name) || create(name)
  end

  def self.new_from_filename(filename)
    parts = filename.split(" - ")
    artist_name, song_name, genre_name = parts[0], parts[1], parts[2].gsub(".mp3", "")

    artist = Artist.find_or_create_by_name(artist_name)
    genre = Genre.find_or_create_by_name(genre_name)

    new(song_name, artist, genre)
  end

  def self.create_from_filename(filename)
    new_from_filename(filename).tap{ |s| s.save }
  end
end
