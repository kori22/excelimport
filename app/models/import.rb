class Import < ApplicationRecord



	def self.es_import(file)
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(1)
	  es_data = []
	  (2..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
	    es_data << {
	    	"index": {
	    		"_id": i
	    	}
	    }
	    es_data << row.to_hash
	  end

	  return es_data
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
