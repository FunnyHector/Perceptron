class Feature
  DEFAULT_THRESHOLD = 0.75

  attr_accessor :weight

  def initialize(is_dummy, num_connected_pixels, width, height, random_seed)
    @is_dummy         = is_dummy
    @random_generator = random_seed.nil? ? Random.new : Random.new(random_seed)
    @weight           = random_weight
    @connections      = {}

    return if @is_dummy

    @threshold_num = (num_connected_pixels * DEFAULT_THRESHOLD).to_i

    # Example of @connections
    # @connections = {
    #   [1, 2] => true,
    #   [3, 4] => false,
    #   [5, 6] => true,
    #   [7, 8] => false
    # }

    num_connected_pixels.times do
      coordinate               = [random_int_within(width), random_int_within(height)]
      @connections[coordinate] = random_boolean
    end
  end

  def num_connections
    @connections.size
  end

  def dummy_feature?
    @is_dummy
  end

  def value_on(image_instance)
    return 1 if @is_dummy

    count = @connections.count do |coordinate, boolean|
      image_instance.pixel_at?(coordinate[0], coordinate[1]) == boolean
    end

    count >= @threshold_num ? 1 : 0
  end

  private

  def random_boolean
    @random_generator.rand > 0.5
  end

  def random_int_within(max)
    @random_generator.rand(max.to_i)
  end

  def random_weight
    @random_generator.rand
  end
end
