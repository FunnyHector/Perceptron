# Example of @connections
# @connections = {
#   [1, 2] => true,
#   [3, 4] => false,
#   [5, 6] => true,
#   [7, 8] => false
# }

class Feature
  DEFAULT_THRESHOLD = 0.75

  attr_accessor :weight

  def initialize(connections, weight)
    @connections = connections
    @weight = weight
    @threshold_num = (@connections.size * DEFAULT_THRESHOLD).to_i
  end

  def value_on(image_instance)
    count = @connections.count do |coordinate, boolean|
      image_instance.pixel_at?(coordinate[0], coordinate[1]) == boolean
    end

    count >= @threshold_num ? 1 : 0
  end
end

class DummyFeature < Feature
  def value_on(image_instance)
    1
  end
end
