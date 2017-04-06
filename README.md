# Perceptron

To use default parameters, just run "ruby main.rb".

Arguments can be provided as "ruby main.rb [training_image_file] [test_image_file] [num_features] [num_connected_pixels] [max_epochs] [learning_rate] [acceptable_accuracy] [random_seed]".

Example of how to run:
(just copy it into console for convenience)
% ruby main.rb image.data test_images.data 50 4 500 0.1 1.0

All arguments are optional. If they are not provided, default data files and parameters will be used.

Default parameters:
- training_image_file:    "image.data"
- test_image_file:        "test_images.data"
- num_features:           50
- num_connected_pixels:   4
- max_epochs:             500
- learning_rate:          0.1
- acceptable_accuracy     1.0
- random_seed:            none
