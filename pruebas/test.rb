class Customer

	@@noCustomers = 0

	def initialize(id, name, addr)
		@custId = id
		@custName = name
		@custAddr = addr
		@@noCustomers+=1
	end

	def display_details()
		puts "Id: "+@custId+" | Name: "+@custName+" | Address: "+@custAddr+"\n\n"
	end

	def total_no_of_customers()
		#@@noCustomers+=1
		puts "Total Customers: "+String(@@noCustomers)+"\n\n"
	end

end

usuario = gets

usuario = usuario.chomp


cust1 = Customer.new("1", usuario, "Caracas")
cust2 = Customer.new("2", "Caracol", "Pecera")

cust1.display_details()
cust1.total_no_of_customers()
cust2.display_details()
cust1.total_no_of_customers()