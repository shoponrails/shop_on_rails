class Spree::StatesController < Spree::StoreController

  def by_country
    states = Spree::State.where(:country_id => params[:country_id]).order('name ASC')
    readable_states = states.map{ |state| { :id => state.id, :abbr => state.abbr, :name => state.name } }
    render :json => { :country_id => params[:country_id], :states => readable_states }
  end
end
