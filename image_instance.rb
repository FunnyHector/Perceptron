class ImageInstance
  attr_reader :given_class, :width, :height, :pixels
  attr_accessor :classified_class

  def initialize(given_class, classified_class, width, height, pixels)
    @given_class      = given_class
    @classified_class = classified_class
    @width            = width
    @height           = height
    @pixels           = pixels
  end

  def pixel_at?(x, y)
    @pixels[x + y * width] == "1"
  end

  def misclassified?
    given_class != classified_class
  end

  def yes_class?
    given_class == "Yes"
  end

  def other_class?
    given_class == "other"
  end
end
