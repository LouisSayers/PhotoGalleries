require 'mongoid'

class Person
  include Mongoid::Document
  store_in :people

  field :user_id, type: String
  field :auth_type, type: String
  field :session_ids, type: Array
  embeds_many :sites

  def login
    self.session_ids = [] if self.session_ids.nil?
    self.session_ids << Digest::MD5.hexdigest("#{self.twitter_user_id}#{Time.now}").to_s()
  end

  def logout
    self.session_ids = []
  end

  def self.get_or_create(user_id, auth_type)
    person = Person.where(user_id: user_id, auth_type: auth_type).first
    return person if !person.nil?
    return Person.new(user_id: user_id, auth_type: auth_type)
  end

  def self.with(session_id)
    Person.any_in(session_ids: [session_id])[0]
  end
end

class Site
  include Mongoid::Document
  store_in :sites
  embedded_in :person
  embeds_many :sites

  field :subdomain, type: String
end

class Page
  include Mongoid::Document
  store_in :pages
  embedded_in :site

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


