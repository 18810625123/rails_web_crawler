class Crawler::BaseController < ApplicationController
  before_action :check_current_user
  before_action :get_current_menus

  layout :set_layout

  def index

  end

  def check_current_user

  end

  def get_current_menus
    @all_menus = Crawler::Menu.all.order :location
    @index_menu = Crawler::Menu.find_by_name('系统首页')
    # @menus = @index_menu.children#.map{|m| m}.unshift(@index_menu)
    @menus = @all_menus

    controller = params[:controller].split('/')[1]
    if params[:action]=='index'
      action = ''
    else
      if @all_menus.map(&:action).include?(params[:action])
        action = params[:action]
      else
        action = ''
      end
    end
    @current_menu = Crawler::Menu.where("controller = '#{controller}' and action = '#{action}'").first
    @current_menu = @index_menu if !@current_menu
    @navs = @current_menu.navs
  end

  def set_layout
    if !params[:layout].blank?
      session[:layout] = params[:layout]
    else
      session[:layout] = session[:layout].nil? ? 'crawler' : session[:layout]
    end
    session[:layout]
  end
  
end
