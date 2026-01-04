require 'yaml'

# Handles saving and loading the game using YAML
class SaveLoad
  def self.save(game)
    File.write("save.yml", YAML.dump(game))
    puts "Game saved!"
  end

  def self.load
    YAML.load_file("save.yml")
  end
end
