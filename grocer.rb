require "pry"

def consolidate_cart(cart)

  # values_at(item).length is the count
  consolidated_cart = {}
  cart.each { |item_hash|
    item = item_hash.keys[0]
    attributes = item_hash.values[0]
    if !consolidated_cart.key?(item)
      consolidated_cart[item] = attributes
      consolidated_cart[item][:count] = 1
    else
      consolidated_cart[item][:count] += 1
    end
  }
consolidated_cart
end

def find_coupon_for_item(coupons, item)
  coupons.find {|coupon_data| coupon_data[:item] == item}
end

def apply_coupons(cart, coupons)
  coupons.each {|coupon|
    item = coupon[:item]
    if cart.key?(item) && cart[item][:count] >= coupon[:num]

      if cart.key?("#{item} W/COUPON")
      # if item already has coupon applied, increment coupon count
        cart["#{item} W/COUPON"][:count] += 1
      else
      # add new key to cart hash for item with coupon applied
        cart["#{item} W/COUPON"] = {
          :price => coupon[:cost],
          :clearance => cart[item][:clearance],
          :count => 1
        }
      end
      # update count for original item to remove items with coupon applied
      new_item_count = cart[item][:count] - coupon[:num]
      cart[item][:count] = new_item_count
    end
  }
  cart
end

def apply_clearance(cart)
  cart.each { |item, attributes|
    if attributes[:clearance]
      attributes[:price] -= attributes[:price] * 0.20
    end
  }
end

def get_cart_total(cart)
  total = 0.00
  cart.each { |item, attributes| total += attributes[:price] * attributes[:count]}
  total
end

def checkout(cart, coupons)
  updated_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = get_cart_total(updated_cart)
  total > 100.00 ? total - total * 0.10 : total 
end
