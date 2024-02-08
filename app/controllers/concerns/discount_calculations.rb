module DiscountCalculations
    extend ActiveSupport::Concern

    DISCOUNT_PERCENTAGES = {
      purchase_count: 5,
      price_threshold: 15,
      specific_category: 10
    }.freeze

    SPECIFIC_CATEGORY_ID = Product.categories["Electronics"]
  
    included do
      def calculate_discount(product, user)
        total_discount_percentage = 0

        total_discount_percentage += DISCOUNT_PERCENTAGES[:purchase_count] if user.purchase_count > 2
        total_discount_percentage += DISCOUNT_PERCENTAGES[:price_threshold] if product.price > 120
        total_discount_percentage += DISCOUNT_PERCENTAGES[:specific_category] if product.category_id == SPECIFIC_CATEGORY_ID 
        {
          final_price: calculate_final_price(product.price, total_discount_percentage),
          discount_perc: total_discount_percentage
        }
      end
  
      private
  
      def calculate_final_price(original_price, discount_percentage)
        discounted_price = original_price * (1 - discount_percentage / 100.0)
        discounted_price.round(2)
      end
    end
  end
  