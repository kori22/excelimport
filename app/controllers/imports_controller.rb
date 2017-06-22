class ImportsController < ApplicationController
	require "net/http"
	require "uri"
	require 'json'



	def es_execute
	  @data = Import.es_import(params[:file])
	  render :json => {"message" => "imported"}
	end

	def es_form

	end

	def es_result

	end

	def es_form_simulasi

	end

	def bloom_form

	end

	def bloom_simulation
		@data = Import.bloom_simulasi(params[:file])
		url = "http://localhost:8889/promo_codes/bloom"
		uri = URI.parse(url)
		http = Net::HTTP.new(uri.host, uri.port)
		send_param = {"list_data" => @data}.to_json

		request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
		request.body = send_param
		resp = http.request(request)
		respData = JSON.parse(resp.body)["data"]

	end

	def es_execute_simulasi
	  @data = Import.es_import_simulasi(params[:file])
	  url = "http://localhost:8889/promo_codes/validate/use"
	  uri = URI.parse(url)
	  http = Net::HTTP.new(uri.host, uri.port)
	  paymentid = 100231000
	  @data.each do |data|
	  	paymentid += 1
		send_param = {"data" => data}.to_json

		request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
		request.body = send_param
		resp = http.request(request)
		respData = JSON.parse(resp.body)["data"]

		if respData["success"].present?
			send_notify_success(data, respData, paymentid)
		end


		puts "===========validate use============"
		puts resp.body
		puts "===================================="
	  end

	  render :json => {"message" => "imported"}
	end

	def send_notify_success(data, resp, paymentid)
		data_request = {
		  "data" =>{
		    "promo_code_id" => resp["promo_code_id"],
		    "code" => data["code"],
		    "category_code" => 1,
		    "discount_amount" => 50000,
		    "cashback_amount" => 10000,
		    "saldo_amount" => 20000,
		    "cashback_voucher_amount" => 5000,
		    "cashback_top_cash_amount" => 3000,
		    "payment_amount" => 200000,
		    "payment_id" => paymentid,
		    "user_id" => data["user_id"],
		    "msisdn" => data["msisdn"],
		    "msisdn_verified" => 1,
		    "service_id" => 819380128012836,
		    "email" => data["email"],
		    "client_number" => data["client_number"],
		    "gateway_id" => "12",
		    "book" => false,
		    "credit_card_number" => "897655566455",
		    "cc_exp_month" => 8,
		    "cc_exp_year" => 2017,
		    "klik_bca_user_name" => "kori123",
		    "mandiri_click_pay_number" => "134324234324",
		    "message_success" => "Success used",
		    "success" => true,
		    "ip_address" => data["ip_address"],
		    "user_agent" => data["user_agent"],
		    "fingerprint_id" => data["fingerprint_id"],
		    "product_code" => data["product_code"],
		  }
		}

		url = "http://localhost:8889/promo_codes/notify/success"
		uri = URI.parse(url)
		http = Net::HTTP.new(uri.host, uri.port)

		request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
		request.body = data_request.to_json
		resp = http.request(request)

		puts "===========nofiy success============"
		puts paymentid
		puts resp.body
		puts "===================================="
	end

end
