Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources	:imports do
  	collection do
	  	get	:es_form
	  	post :es_execute
	  	get	:es_result
	  	get	:es_form_simulasi
	  	post :es_execute_simulasi
	end
  end
end
