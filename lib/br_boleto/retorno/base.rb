# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		class Base < BrBoleto::ActiveModelBase
			
			attr_reader    :file
			attr_accessor :pagamentos
			attr_accessor :codigo_banco

			def initialize(file)
				self.pagamentos = []
				@file = file
				read_file! if @file.present?
			end

			validates :file, presence: true

			# O atributo pagamentos sempre irá retornar um Array 
			def pagamentos
				@pagamentos = [@pagamentos].flatten
			end

			def file
				@file
			end
		
		private

			def conta_pagamento_class
				case codigo_banco.to_i.to_s.rjust(3, '0')
				when '001'
					BrBoleto::Conta::BancoBrasil
				when '033'
					BrBoleto::Conta::Santander
				when '085'
					BrBoleto::Conta::Cecred
				when '104'
					BrBoleto::Conta::Caixa
				when '237'
					BrBoleto::Conta::Bradesco
				when '341'
					BrBoleto::Conta::Itau
				when '748'
					BrBoleto::Conta::Sicredi
				when '756'
					BrBoleto::Conta::Sicoob
				else
					BrBoleto::Conta::Base
				end
				
			end

			def read_file!
				raise NotImplementedError.new('Sobreescreva este método na classe referente ao CNAB 240 ou 400')
			end

			# Resolve problema quando existe algum caractere com acentuação e encode UTF-16
			# converte esse caractere para ? e converte para o encode UTF-8.
			# Fix issue #5
			#
			def adjust_encode(line)
				line.encode!("UTF-16be", invalid: :replace, replace: "?").encode!('UTF-8')
			end
			
		end
	end
end