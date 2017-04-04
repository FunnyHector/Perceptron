require "./feature.rb"

class Perceptron
  attr_reader :features, :epoch, :accuracy_on_training, :accuracy_on_test

  def initialize(training_images, num_features, num_connected_pixels, max_epochs, learning_rate, random_seed)
    @training_images      = training_images
    @num_features         = num_features
    @num_connected_pixels = num_connected_pixels
    @max_epochs           = max_epochs
    @learning_rate        = learning_rate
    @random_generator     = random_seed.nil? ? Random.new : Random.new(random_seed)

    sample_image = @training_images.first
    width        = sample_image.width
    height       = sample_image.height

    # put in a dummy feature first
    @features = [DummyFeature.new({}, random_weight)]

    # then the features
    num_features.times do
      connections = {}

      # randomly generate connected pixels
      num_connected_pixels.times do
        coordinate = [random_int(width), random_int(height)]

        # if the coordinate is already there, have to regenerate another one
        coordinate = [random_int(width), random_int(height)] until connections[coordinate].nil?

        connections[coordinate] = random_boolean
      end

      @features << Feature.new(connections, random_weight)
    end
  end

  def train(output_io)
    @epoch             = 0
    no_more_converging = false
    total_num          = @training_images.size

    until always_correct? || no_more_converging || @epoch >= @max_epochs
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

      @epoch += 1

      # show the converging progress
      output_io << "# epoch #{@epoch}:\n"

      num_incorrect = @training_images.count(&:misclassified?)
      @accuracy_on_training = (total_num - num_incorrect).to_f / total_num

      output_io << "  Accuracy: #{format("%.2f", @accuracy_on_training * 100)}%\n"

      weights = @features.map do |feature|
        format("#{feature.weight >= 0 ? "+" : ""}%.2f", feature.weight)
      end.join(" | ")

      output_io << "  Weights: #{weights}\n"
    end
  end

  def test(test_images)
    test_images.each do |image|
      classify_image!(image)
    end

    num_incorrect     = test_images.count(&:misclassified?)
    total_num         = test_images.size
    @accuracy_on_test = (total_num - num_incorrect).to_f / total_num
  end

  private

  def classify_image!(image)
    image.classified_class = total_value_on(image) > 0 ? "Yes" : "other"
  end

  def total_value_on(image)
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
