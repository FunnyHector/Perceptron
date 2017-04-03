require "./feature.rb"

class Perceptron
  def initialize(training_images, num_features, num_connected_pixels, max_epochs, learning_rate, random_seed)
    @training_images      = training_images
    @num_features         = num_features
    @num_connected_pixels = num_connected_pixels
    @max_epochs           = max_epochs
    @learning_rate        = learning_rate
    @random_generator     = random_seed.nil? ? Random.new : Random.new(random_seed)

    sample_image = @training_images.first
    width  = sample_image.width
    height = sample_image.height

    # put in a dummy feature first
    @features = [DummyFeature.new({}, random_weight)]

    # then the features
    num_features.times do
      connections = {}

      # randomly generate connected pixels
      num_connected_pixels.times do
        coordinate = [random_int(width), random_int(height)]
        connections[coordinate] = random_boolean
      end

      @features << Feature.new(connections, random_weight)
    end
  end

  def train
    epoch = 0
    no_more_converging = false

    until always_correct? || no_more_converging || epoch >= @max_epochs
      no_more_converging = true

      @training_images.each do |image|
        classify_image!(image)

        next unless image.misclassified?

        @features.each do |feature|
          value_of_feature   = feature.value_on(image)
          no_more_converging = false unless value_of_feature.zero?

          if image.yes_class?
            feature.weight += value_of_feature * @learning_rate
          elsif image.other_class?
            feature.weight -= value_of_feature * @learning_rate
          end
        end
      end

      epoch += 1

      # ========= test =============
      puts "========= epoch: #{epoch} ============="

      weights = @features.map do |feature|
        feature.weight.to_s
      end.join(" | ")

      puts weights
      puts "=================================="
    end
  end

  def test
    @features.each { |feature| puts feature.weight }

    @training_images.each do |image|
      puts "#{image.given_class} -- #{image.classified_class}"
    end
  end

  private

  def classify_image!(image)
    image.classified_class = value_on(image) > 0 ? "Yes" : "other"
  end

  def value_on(image)
    @features.reduce(0) { |sum, feature| sum + feature.weight * feature.value_on(image) }
  end

  def always_correct?
    @training_images.none?(&:misclassified?)
  end

  def random_boolean
    @random_generator.rand > 0.5
  end

  def random_int(max)
    @random_generator.rand(max.to_i)
  end

  def random_weight
    @random_generator.rand(-1.0..1.0)
  end
end
