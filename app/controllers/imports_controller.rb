class ImportsController < ApplicationController




	def es_execute
	  @data = Import.es_import(params[:file])
	  render :json => @data.to_json
	end

	def es_form

	end

	def es_result

	end



end
