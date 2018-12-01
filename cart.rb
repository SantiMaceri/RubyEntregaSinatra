require_relative 'item'

class Cart

	attr_accessor :items , :time


	def initialize(*items)
		@items = []
		@time = Time.now
		items.each { |x| @items.push(x) }

	end

	def add_item(item, how_many)
		how_many.times{ @items.push(item)}
	end

	def delete_item(item_id)
		@items.delete_if{ |x| x.id == item_id}
	end

	def total()
		@items.inject(0){ | sum, each | sum + each.precio}
	end

	def print_data()
		@items.map { |x| x.basic_info }

	end
end