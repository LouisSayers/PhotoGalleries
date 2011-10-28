require 'mongoid'

class Person
  include Mongoid::Document
  store_in :people

  field :twitter_user_id, type: String
  field :session_ids, type: Array
  field :subdomain, type: String

  def login
    self.session_ids = [] if self.session_ids.nil?
    self.session_ids << Digest::MD5.hexdigest("#{self.twitter_user_id}#{Time.now}").to_s()
  end

  def logout
    self.session_ids = []
  end

  def self.get_or_create(twitter_user_id)
    person = Person.where(twitter_user_id: twitter_user_id).first
    return person if !person.nil?
    return Person.new(twitter_user_id: twitter_user_id)
  end

  def self.with(session_id)
    Person.any_in(session_ids: [session_id])[0]
  end
end

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

