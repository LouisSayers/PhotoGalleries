require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../models'

describe "Person and Page relationship" do

   before(:each) do
    Person.delete_all
    #Arrange
      @person = Person.new(user_id: '12345')
      @person.login
      @person.save
    end

   it "should create a new site and page when a site doesn't already exist" do
    #Act
    post $links[:admin_homepage_main_image_upload].link,
          {'image' => Rack::Test::UploadedFile.new(test_image_location, 'image/png')},
          'rack.session' => {:id => @person.session_ids[0]}


    helena = Person.where(name: 'Helena')[0]
    image_url = helena.userContent.homepage_image

    last_response.body.include?(image_url).should == true
   end
end
