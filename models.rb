require 'mongoid'

class Page
  include Mongoid::Document
  store_in :pages

  field :name, type: String
  field :content, type: String

  def self.new_from(params)
    Page.new(name: "/#{params[:name]}",
             content: params[:content])
  end

  def self.update(page_id, params)
    page = Page.where(_id: page_id).first
    return if page.nil?

    page.name = params[:name]
    page.content = params[:content]
    page.save
  end
end

