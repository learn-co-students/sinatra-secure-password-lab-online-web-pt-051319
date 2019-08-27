class User < ActiveRecord::Base
	validates :username, length: { minimum: 1 }
	has_secure_password
	after_initialize :init

	def init
		self.balance ||= 0
	end

	def deposit(amount)
		new_bal = self.balance + amount.to_f
		self.update(balance: new_bal)
	end

	def withdrawl(amount)
		new_bal = self.balance - amount
		self.update(balance: new_bal)
	end

	def funds_available?(amount)
		return self.balance >= amount
	end
end
