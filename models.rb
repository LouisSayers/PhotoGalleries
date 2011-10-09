
class Page
  include Mongoid::Document
  store_in :pages

  field :name, type: String
  field :content, type: String
  field :markup, type: String

  def self.new_from(params)
    Page.new(name: params[:name],
             content: params[:content],
             markup: params[:markup])
  end
end