class WelcomeController < ApplicationController
  def index
  end
  def create_table

  end
  def crawler

  end
  def base_data

  end
  def create_table
    web_id = params[:web_id]
    @web = Web.find web_id
    @table = Table.new
    @table.web_id = web_id
  end
end
