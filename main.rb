require "./perceptron.rb"
require "./image_instance.rb"

DEFAULT_IMAGE_FILE           = "image.data".freeze
DEFAULT_NUM_FEATURES         = 50
DEFAULT_NUM_CONNECTED_PIXELS = 4
DEFAULT_MAX_EPOCHS           = 500
DEFAULT_LEARNING_RATE        = 0.1
DEFAULT_RANDOM_SEED          = 420

# define helper methods
def read_file(file)
  File.read(DEFAULT_IMAGE_FILE).split("P1").reject { |meta| meta.strip.empty? }.map do |meta|
    values = meta.split

    given_class = values[0][1..-1]
    width       = values[1].to_i
    height      = values[2].to_i
    pixels      = values[3] + values[4]

    ImageInstance.new(given_class, nil, width, height, pixels)
  end
rescue StandardError => e
  abort("Error occurred when reading \"#{file}\". Exception message: \"#{e.message}\".")
end


# ========== Here we go ===============

# set parameters
training_image_file  = ARGV[0].nil? ? DEFAULT_IMAGE_FILE : ARGV[0]
num_features         = ARGV[1].nil? ? DEFAULT_NUM_FEATURES : ARGV[1]
num_connected_pixels = ARGV[2].nil? ? DEFAULT_NUM_CONNECTED_PIXELS : ARGV[2]
max_epochs           = ARGV[3].nil? ? DEFAULT_MAX_EPOCHS : ARGV[3]
learning_rate        = ARGV[4].nil? ? DEFAULT_LEARNING_RATE : ARGV[4]
random_seed          = ARGV[5].nil? ? DEFAULT_RANDOM_SEED : ARGV[5]

# read in the training images
training_images = read_file(training_image_file)


perceptron = Perceptron.new(training_images, num_features, num_connected_pixels, max_epochs, learning_rate, random_seed)

puts "======= before training ==========="

perceptron.test

puts "=========================="

perceptron.train


perceptron.test
