require "./perceptron_classifier.rb"

DEFAULT_IMAGE_FILE = "image.data".freeze

# define helper methods
def read_file(file)
  # File.readlines(file).reject { |line| line.strip.empty? }.drop(2).map do |line|
  #   values         = line.split
  #   given_category = values[0]
  #   attributes     = values.drop(1).map { |value| to_boolean(value) }
  #
  #   HepatitisInstance.new(given_category, attributes)
  # end
rescue StandardError => e
  abort("Error occurred when reading \"#{file}\". Exception message: #{e.message}.")
end

