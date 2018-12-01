require 'json'

class Item
	attr_accessor :id , :sku , :descripcion, :stock, :precio


	def initialize(id, sku, desc, stock, precio)
		@id =id
		@sku =sku
		@descripcion=desc
		@stock=stock
		@precio=precio
	end

	def basic_info
		{
			id:@id,
			sku:@sku,
			descripcion:@descripcion
		}
	end
	def as_json(options={})
		{
			id: @id,
			sku: @sku,
			descripcion: @descripcion,
			stock: @stock,
			precio: @precio

		}
	end


	def to_json(*options)
		as_json(*options).to_json(*options)
	end

	def to_json_pretty()
		#JSON.pretty_generate(self)
	end

	def update(params)
		params.each{|k,v| self.send(k + "=", v)}
		self
	end
end