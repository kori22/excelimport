class Import < ApplicationRecord
	require "net/http"
	require "uri"
	require 'json'

	include Elasticsearch::Model
  	include Elasticsearch::Model::Callbacks

	def self.es_import(file)
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(1)
	  # es_data = []
	  repository = Elasticsearch::Persistence::Repository.new
	  (2..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
	    
		repository.save(row)
	  end

	  return true
	end


	def self.bloom_simulasi(file)

	end

	def self.es_import_simulasi(file)
	  spreadsheet = open_spreadsheet(file)
	  dataArray = []
	  header = spreadsheet.row(1)
	  (2..spreadsheet.last_row).each do |i|
	    data = spreadsheet.row(i)


		# uri = URI.parse("http://localhost:8889/validate/use")

		# header = {'Content-Type': 'text/json'}
		dataHash = {
	    	"code" => "NICOFIX",
			"user_id" => data[1].to_i,
			"email" => data[2],
			"msisdn" => data[3].to_s,
			"msisdn_verified" => 1,
			"total_recharge_price" => 50000,
			"device_type" => "samsung",
			"book" => true,
			"language" => "EN",
			"service_id" => 819380128012836,
			"secret_key" => "asdfg",
			"product_code" => data[11],
			"category_code" => 1,
			"client_number" => data[13].to_s,
			"is_qc_acc" => 0,
			"is_giftcard" => true,
			"ip_address" => data[16],
			"user_agent" => data[17],
			"fingerprint_id" => ""
	    }

	    dataArray << dataHash
		# # Create the HTTP objects
		# http = Net::HTTP.new(uri.host, uri.port)
		# request = Net::HTTP::Post.new(uri.request_uri, header)
		# request.body = dataHash.to_json

		# byebug
		# # Send the request
		# response = http.request(request)






	  end

	  return dataArray
	end


	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
	   when '.csv' then Roo::Csv.new(file.path, packed: false, file_warning: :ignore)
	   when '.xls' then Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
	   when '.xlsx' then Roo::Excelx.new(file.path, packed: false, file_warning: :ignore)
	   else raise "Unknown file type: #{file.original_filename}"
	  end
	end


end
