require 'bundler'
Bundler.require


require_relative 'item'
require_relative 'user'
require_relative 'cart'
 
#Items por defecto	
	a= Item.new(1, 333, "Papel", 20, 50.0)
	b= Item.new(2, 444, "Toalla",10, 30.0)
	c= Item.new(3, 555, "Jabon", 25, 10.0)
	d= Item.new(4, 666, "Shampoo", 5, 100.0)
	items = [a, b, c, d]

#Carritos por defecto
	carrito_vacio = Cart.new()
	carrito_algo = Cart.new(c,d)

#Usuarios por defecto
	u1 = User.new(1, "Pepe")		#User sin carrito
	u2 = User.new(2, "ElPro", carrito_algo)	#User con carrito
	users = [u1,u2]

before do
	content_type 'application/json'
end

not_found do
	'No se encontro lo que buscabas'
end


get '/items.json' do 
	
	body = items.map{ |x|  x.basic_info}
	[200,  [JSON.dump(body)] ]

end



get '/items/:id.json' do

	if (items.any?{|x| x.id == params['id'].to_i})
		body = items.detect{ |x| x.id == params['id'].to_i}
		[200,  {'Content-Type' => 'application/json'} , [JSON.dump(body)] ]
	else
		 [404, {'Content-Type' => 'application/json'}]
	end	

end

post '/items.json' do

    data = JSON.parse request.body.read

    item = Item.new(items.length + 1, data['sku'].to_i, data['descripcion'], data['stock'].to_i, data['precio'].to_f )
    
	halt 422, 'Alguno de los campos vino vacio, intente de nuevo' if item.as_json.values.find_index(nil)
     

    items.push(item)
    [ 201, {'Content-Type' => 'application/json'}, [JSON.dump(item)]]
    


end


get '/cart/:username.json' do

	user = users.detect{ |x| x.username == params['username']}

	(user.cart = Cart.new) unless user.has_cart?
	
	body = user.my_data

	[200,  {'Content-Type' => 'application/json'} , [JSON.dump(body)] ]

end

put '/items/:id.json' do #FALTA TERMINAR
	
	if (items.any?{|x| x.id == params['id'].to_i})
		item = items.detect{ |x| x.id == params['id'].to_i}
	else
		 halt 404
	end	
	
	data = JSON.parse request.body.read

	parameters = data.select{|k, v| k == "sku" || k == "descripcion" || k == "stock" || k == "precio"}
	
	if parameters.empty?
		halt 422, 'Los parametros que se esperaban no estan'
	else 
		parameters['stock']=parameters['stock'].to_i if parameters.any?{|k, v| k == "stock"}
		parameters['precio']=parameters['precio'].to_f if parameters.any?{|k, v| k == "precio"}
		item.update(parameters)
	end

	[200,  {'Content-Type' => 'application/json'} , [JSON.dump(item)] ]
	

	 
	
end

delete '/cart/:username/:item_id.json' do

	user = users.detect{ |x| x.username == params['username']} 

	if user.has_cart?

		user.cart.delete_item(params['item_id'].to_i)

	else
		user.cart = Cart.new
	end

	body = user.my_data

	[200,  {'Content-Type' => 'application/json'} , [JSON.dump(body)] ]

end


put '/cart/:username.json' do 

	data = JSON.parse request.body.read

	halt 422, 'No se paso Id como parametro' if data['id'] == nil

	user = users.detect{ |x| x.username == params['username']}

	(user.cart = Cart.new) unless user.has_cart?

	if (items.any?{|x| x.id == data['id'].to_i})
		item = items.detect{ |x| x.id == data['id'].to_i}
	else
		 halt 404
	end	

	user.cart.add_item(item, data['how_many'].to_i)
	item.stock= item.stock - data['how_many'].to_i

	body = user.my_data

	[200,  {'Content-Type' => 'application/json'} , [JSON.dump(body)] ]


end