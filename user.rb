
require_relative 'cart'


class User


	attr_accessor :id, :username, :cart

	def initialize (id, username, cart=nil)
		@id = id
		@username = username
		@cart = cart
	end

	def has_cart?
		@cart != nil
	end

	def my_data()
		{
			id:@id,
			username:@username,
			cartItems:@cart.print_data(),
			Total: @cart.total,
			cartTime: @cart.time
		}
	end
end