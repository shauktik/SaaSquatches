require 'rails_helper'

describe Preference do
  
  before :each do
    @preference = Preference.new "1" "1" "1" "1"
  end
  
end

 RSpec.describe HomePageController, type: :controller do
  
  
  # 0. HOME link at the top
   describe "GET #home" do
     it "returns http success for admin" do
     session[:user_id] = '3'
     session[:permission] = 'Admin'
       get :home
       expect(response).to have_http_status(:success)
     end
   it "returns http success for professor" do
     session[:user_id] = '2'
     session[:permission] = 'User'
       get :home
     response.should redirect_to '/professorhome'
     end
   end
   

   describe "add new faculty" do
     it "should call the model method to create new faculty" do
   session[:user_id] = "3"
   session[:FacultyName] = "Faculty1"
   session[:permission] = "Admin"
   Faculty.create(:faculty_name => "Faculty1", :permission => "User").should be_valid
   post :addfaculty, {:class => {:faculty_name => "Faculty1", :permission=>"User"}}
   response.should redirect_to root_path
     end
   end
   
   describe "reset user" do
   before :each do
   @user = [double(:id => 4, :faculty_name=> "Shell Dylan",:faculty_id=>"40", :email => "mm@gmail.com", :password => "asdf")]
   session[:selectedUser] = 4
   end
     it "should call resetuser and redirect to root" do
   post :resetuser, {:class=>{:selectedUser => 1}}
   User.create(:id=>1, :faculty_name=> "Keyser John", :faculty_id=>"25", :email => "john@tamu.edu", :password => "asdf")
   end
   end
   
   describe "addpreference" do
   before :each do
     session[:user_id] = '3'
   session[:semester_id] = '1'
   session[:permission] = 'Admin'
   end
  it "should add bad professor preferences to database" do
  post :addpreference, {:class=>{:FacultyName => "3"}, :unacceptable_ids=>['17','18','19']}
  end
  it 'should add good professor preferences to database' do
  post :addpreference, {:class=>{:FacultyName => "3"}, :preferred_ids=>['4','5']}
  end
  
   end
   
   
   
   describe "add new course" do
   before :each do
     session[:CourseName] = 'CSCE 601'
   session[:CourseTitle] = 'Programming with C and Java'
   session[:course_size] = '100'
   session[:semester_id] = '1'
   session[:user_id] = '3'
   session[:permission] = 'Admin'
   end
     it "should call the model method to create new course" do
   
   #Course.create(:course_name => 'name', :CourseTitle => 'title').should be_valid
   #Course.should_receive(:create!).with(:course_name => 'name', :CourseTitle => 'title')
   get :addcourse, {:class => {:course_name => 'CSCE 601', :CourseTitle => 'Programming with C and Java'}, :course_size=>{:course_size => '100'}}
     end
   end
 
   describe 'setting semester id in session' do
   it 'should set the semester id in session and redirect to home page' do
     session[:user_id] = '3'
     session[:permission] = 'Admin'
     post :setsession, {:class => {:semester_id => '1'}}
     session[:semester_id].should == '1'
     response.should redirect_to root_path
   end
   end
 
   describe 'creating new semester' do
   before :each do
     session[:user_id] = '3'
     session[:permission] = 'Admin'
   end
   it 'should call model method to create new semester' do
     Semester.should_receive(:find_by)
     Semester.should_receive(:create_semester).with('test1')
     post :createsemester, {:class => {:SemesterTitle => 'test1'}}
     response.should redirect_to '/'
   end
   it 'should check for valid input before creating new semester' do
     post :addsemester, {:class => {:SemesterTitle => ''}}
     response.should have_http_status(:success)
     #response.should redirect_to session[:"page#addsemester"]
   end
   end
   
   describe 'adding new preference' do
     it 'should add a new preference'do
   Preference.create(:time_slot_id => '1', :day_combination_id => '1', :building_id => '1', :semester_id => '1').should be_valid
     #Preference.should_receive(:create!).with({:time_slot_id=>'1',:day_combination_id=>'1', :building_id=> '1',:semester_id=> '1'})
     post :addpreference, {:class=>{:time_slot_id=>'1',:day_combination_id=>'1', :building_id=> '1',:semester_id=> '1'}}
   end
   end
   
   describe 'adding new faculty preference' do
     it 'should add a new faculty preference if it is new'do
   FacultyPreference.create(:preference1_id => '99').should be_valid
     #FacultyPreference.should_receive(:create!).with(:preference1_id=>'99')
     post :addpreference, {:class=>{:preference1_id=>'99'}}
   end
   end
   
   describe 'addclassroom' do
   before :each do
     session[:building_name] = "HRBB"
   session[:room_name] = "113"
   session[:room_capacity] = "60"
   end
     it 'should add a new classroom if it is new' do
   post :addclassroom, {:class=>{:building_name=>"HRBB",:room_name=>"113",:room_capacity=>"60"}}
   end
   end
   #Links to various pages:

=begin
  # 1. Add Courses and Faculty
  describe "GET #course_and_faculty" do
    it "redirects to the Courses and Faculty page" do
      get :course_and_faculty
      expect(response).to have_http_status(:success)
    end
  end
=end

=begin  # 2. Add Classrooms and Timings
  describe "GET #addclassroom" do
    it "returns http success" do
      get :addclassroom
      expect(response).to have_http_status(:success)
    end
  end
=end
=begin
  # 3. Show Courses assigned
  describe "GET #courses_assigned" do
    it "redirects to the Courses assigned page" do
      get :courses_assigned
      expect(response).to have_http_status(:success)
    end
  end
=end

=begin
  # 4. Show Faculty Preferences
  describe "GET #faculty_preferences" do
    it "redirects to the Faculty Preferences page" do
      get :facultyprefs
      expect(response).to have_http_status(:success)
    end
  end
=end

=begin
  # 5. Show Conflict Resolution
  describe "GET #conflict_resolution" do
    it "redirects to the Conflict Resolution page" do
      get :conflict_resolution
      expect(response).to have_http_status(:success)
    end
  end
=end

=begin
  # 6. Add New Faculty
  describe "GET #add_new_faculty" do
    it "redirects to the Add New Faculty page" do
      get :add_new_faculty
      expect(response).to have_http_status(:success)
    end
  end
=end

=begin
   # 7. Add New Preference
   describe "GET #addpreference" do
     it "redirects to the Add New Preference page" do
       get :addpreference
       expect(response).to have_http_status(:success)
     end
   end
=end 

end