require 'spec_helper'
require 'db_init'

GEM_RAILS_ROOT=File.join(File.dirname(__FILE__), '/')

class TestMigration < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.column :login, :string
      t.column :name, :string
      t.column :email, :string
      t.column :password, :string
      t.column :role, :string
    end

  end

  def self.down
    drop_table :users
  end
end



class User < ActiveRecord::Base
  simple_excel_import :teacher, :fields => [:login, :name, :email, :password],
                                :default => {
                                  :role => :teacher
                                }


  simple_excel_import :student, :fields => [:login, :name, :email, :password],
                                :default => {
                                  :role => :student
                                }
  
end


describe SimpleExcelImport::Base do
  describe '导入老师' do
    before(:all) {
      TestMigration.up
    }
    after(:all) {TestMigration.down}

    before {
      @excel_file = ActionDispatch::Http::UploadedFile.new({
        :filename => 'user.xls',
        :type => 'application/vnd.ms-excel',
        :tempfile => File.new(GEM_RAILS_ROOT + 'data/user.xls')
      })


      #@excel_file = File.join(GEM_RAILS_ROOT, "spec/data/user.xls")
      #@sample_file = File.join(GEM_RAILS_ROOT, "spec/data/sample.xls")
    }

    describe "只解析, 不保存" do
      before(:each) {
        @parsed_users = User.parse_excel_teacher(@excel_file)
      }
  
      it "should get the users count" do
        
        @parsed_users.count.should == 3

        # expect{
        #   @parsed_users = User.parse_excel_teacher(@excel_file)
        # }.to change{@parsed_users.count}.by(3)
      end

      it "should not be saved" do
        @parsed_users = User.parse_excel_teacher(@excel_file)

        @parsed_users.each do |user|
          user.new_record?.should == true
        end
      end

      it "should be the correct user value" do
        @parsed_users.each do |user|
          if user.name == 'hello2'
            user.login.should == 'aaa2'
          end
        end

        @parsed_users.map{|user|user.email}.should == ["hi1@gmail.com","hi2@gmail.com","hi3@gmail.com"]

      end
    end

    describe "解析同时保存实例到数据库" do
      before(:each) {
        @saved_users = User.import_excel_teacher(@excel_file)
      }


      it "should get the users count" do
        @saved_users.count.should == 3
      end

      it "should be saved" do
        @saved_users.each do |user|
          user.persisted?.should == true
        end
      end

      it "should be the correct user value" do
        @saved_users.each do |user|
          if user.name == 'hello3'
            user.login.should == 'aaa3'
          end
        end

        @saved_users.map{|user|user.email}.should == ["hi1@gmail.com","hi2@gmail.com","hi3@gmail.com"]
      end

    end


    describe "生成 excel 示例文件" do
      it "should have correct field title" do
        spreadsheet = SimpleExcelImport::ImportFile.open_spreadsheet(@sample_file)
        header = spreadsheet.row(0)
        header[0].should == 'login'
        header[1].should == 'name'
        header[2].should == 'email'
        header[3].should == 'password'
      end

      it "should get the correct sample users count" do
        expect{
          @sample_users = User.get_sample_excel_teacher(@sample_file)
        }.to change{@sample_users.count}.by(5)
      end
    end


  end
  
end
