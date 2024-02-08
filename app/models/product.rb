class Product < ApplicationRecord
  enum category: {
    'Electronics' => 1,
    'Clothing' => 2,
    'Books' => 3,
  }
end
