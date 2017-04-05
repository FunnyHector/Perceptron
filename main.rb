require "./perceptron.rb"
require "./image_instance.rb"

DEFAULT_IMAGE_FILE           = "image.data".freeze
DEFAULT_TEST_IMAGE_FILE      = "test_images.data".freeze
DEFAULT_NUM_FEATURES         = 50
DEFAULT_NUM_CONNECTED_PIXELS = 4
DEFAULT_MAX_EPOCHS           = 500
DEFAULT_LEARNING_RATE        = 0.1
DEFAULT_ACCEPTABLE_ACCURACY  = 1.0
DEFAULT_RANDOM_SEED          = nil

# define helper methods
def read_file(file)
  File.read(file).split("P1").reject { |meta| meta.strip.empty? }.map do |meta|
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
test_image_file      = ARGV[1].nil? ? DEFAULT_TEST_IMAGE_FILE : ARGV[1]
num_features         = ARGV[2].nil? ? DEFAULT_NUM_FEATURES : ARGV[2].to_i
num_connected_pixels = ARGV[3].nil? ? DEFAULT_NUM_CONNECTED_PIXELS : ARGV[3].to_i
max_epochs           = ARGV[4].nil? ? DEFAULT_MAX_EPOCHS : ARGV[4].to_i
learning_rate        = ARGV[5].nil? ? DEFAULT_LEARNING_RATE : ARGV[5].to_f
acceptable_accuracy  = ARGV[6].nil? ? DEFAULT_ACCEPTABLE_ACCURACY : ARGV[6].to_f
random_seed          = ARGV[7].nil? ? DEFAULT_RANDOM_SEED : ARGV[7].to_i

output_txt = ""

# display the parameters
if ARGV.empty?
  output_txt << "No arguments found.\nTo provide arguments, run: ruby main.rb [training_image_file] [test_image_file] [num_features] [num_connected_pixels] [max_epochs] [learning_rate] [acceptable_accuracy] [random_seed]\n\nRunning with default parameters:\n"
else
  output_txt << "Arguments found. Running with parameters:\n"
end

output_txt << " - Training image file: \"./#{training_image_file}\""
output_txt << "  # default" if training_image_file == DEFAULT_IMAGE_FILE
output_txt << "\n"

output_txt << " - Test image file: \"./#{test_image_file}\""
output_txt << "  # default" if test_image_file == DEFAULT_TEST_IMAGE_FILE
output_txt << "\n"

output_txt << " - Number of features: #{num_features}"
output_txt << "  # default" if num_features == DEFAULT_NUM_FEATURES
output_txt << "\n"

output_txt << " - Number of connected pixels: #{num_connected_pixels}"
output_txt << "  # default" if num_connected_pixels == DEFAULT_NUM_CONNECTED_PIXELS
output_txt << "\n"

output_txt << " - Max epochs: #{max_epochs}"
output_txt << "  # default" if max_epochs == DEFAULT_MAX_EPOCHS
output_txt << "\n"

output_txt << " - Learning rate: #{learning_rate}"
output_txt << "  # default" if learning_rate == DEFAULT_LEARNING_RATE
output_txt << "\n"

output_txt << " - Acceptable accuracy: #{acceptable_accuracy}"
output_txt << "  # default" if acceptable_accuracy == DEFAULT_ACCEPTABLE_ACCURACY
output_txt << "\n"

output_txt << " - Seed for generating random values: #{random_seed.nil? ? "None" : random_seed}"
output_txt << "  # default" if random_seed == DEFAULT_RANDOM_SEED
output_txt << "\n"

# read in the training images and test images
training_images = read_file(training_image_file)
test_images = read_file(test_image_file)

perceptron = Perceptron.new(training_images, num_features, num_connected_pixels, max_epochs, learning_rate, acceptable_accuracy,random_seed)

# print out things before training
output_txt << "\n==================== before training ====================\n"
output_txt << "#{num_features} features before training:\n"
perceptron.features.each do |feature|
  output_txt << "  #{feature}\n"
end

# let's train it babyyyyyyyyyyyy
output_txt << "\n================== training in progress ==================\n"
perceptron.train(output_txt)

# print out things after training
output_txt << "\n==================== after training ====================\n"
output_txt << "Accuracy on training images: #{format("%.2f", perceptron.accuracy_on_training * 100)}%\n"
output_txt << "Number of Epochs: #{perceptron.epoch}\n"
output_txt << "#{num_features} features after training:\n"
perceptron.features.each do |feature|
  output_txt << "  #{feature}\n"
end

# report the misclassified images
if perceptron.accuracy_on_training < 1
  num_incorrect = training_images.count(&:misclassified?)
  output_txt << "\n#{num_incorrect} misclassified images:\n"

  training_images.each_with_index do |image, index|
    if image.misclassified?
      output_txt << "No. #{index + 1}, given class: #{image.given_class}, classified class: #{image.classified_class}\n"
      output_txt << "  pixels: #{image.pixels}\n"
    end
  end
end

# now let's test it on new images
perceptron.test(test_images)

# report the accuracy on test images
output_txt << "\n==================== on test images ====================\n"
output_txt << "Accuracy on test images: #{format("%.2f", perceptron.accuracy_on_test * 100)}%\n"

# report the misclassified images
if perceptron.accuracy_on_test < 1
  num_incorrect = test_images.count(&:misclassified?)
  output_txt << "\n#{num_incorrect} misclassified images:\n"

  test_images.each_with_index do |image, index|
    if image.misclassified?
      output_txt << "No. #{index + 1}, given class: #{image.given_class}, classified class: #{image.classified_class}\n"
      output_txt << "  pixels: #{image.pixels}\n"
    end
  end
end

# write the result into file, and print out in console
File.write("./sample_output.txt", output_txt)
puts output_txt
puts "\n=======================================================\n"
puts "\"sample_output.txt\" is generated.\n"
