class Crawler::Menu < ApplicationRecord

  CONTROLLERS = {plans:'计划',menus:'菜单',works:'岗位'}
  ACTIONS = {new:'新建',edit:'修改',index:'首页',exec:'执行',test:'测试',tj:'统计',wj:'挖掘',handle:'处理'}

  def parent
    Crawler::Menu.where("id = '#{parent_id}'").first
  end
  def owner
    parent
  end
  def childs
    children
  end
  def children
    Crawler::Menu.where("parent_id = '#{id}'")
  end

  # 生成菜单链接
  def url
    str = "/"
    str += "#{namespace}" if !namespace.blank?
    str += "/#{controller}" if !controller.blank?
    str += "/#{action}" if !action.blank?
    str
  end

  # 生成导航
  def navs
    menus = [self]
    loop do
      parent_menu = menus.first.owner
      break if parent_menu.nil? or parent_menu == menus.first
      menus.unshift(parent_menu)
    end
    menus
  end

  # 移动菜单的排序
  def self.move a, type
    case type
      when '顶'
        Crawler::Menu.find_by_location(1).update location:a.location
        a.update location:1
      when '上'
        Crawler::Menu.find_by_location(a.location.to_i-1).update location:a.location
        a.update location:(a.location-1)
      when '下'
        Crawler::Menu.find_by_location(a.location.to_i+1).update location:a.location
        a.update location:(a.location+1)
      when '底'
        last = Crawler::Menu.all.order(:location).last
        a_l = a.location
        a.update location:last.location
        last.update location:a_l
    end
  end


end
