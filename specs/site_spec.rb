require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../models'

describe "Site creation" do

   before(:each) do
    Person.delete_all
    #Arrange
      @person = Person.new(user_id: '12345')
      @person.login
      @person.save
    end

   it "should create a new site when a site doesn't already exist" do
     #precondition
     Person.where(user_id: @person.user_id).first.sites.count.should == 0

     #Act
     post '/admin/site/create', {'site_name' => 'test-site'}, 'rack.session' => {:id => @person.session_ids[0]}

     stored_person = Person.where(user_id: @person.user_id).first
     stored_person.sites.count.should == 1
     stored_person.sites[0].subdomain.should == 'test-site'
   end
end
