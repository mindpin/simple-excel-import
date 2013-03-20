require 'spec_helper'
require 'db_init'

class TestMigration < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.column :tid, :string
      t.column :age, :string
      t.column :gender, :string
      t.column :nation, :string
      t.column :role, :string
    end

  end

  def self.down
    drop_table :users
  end
end



class User < ActiveRecord::Base
  simple_excel_import :teacher, :fields => [:tid, :age, :gender, :nation],
                                :default => {
                                  :role => :teacher
                                }


  simple_excel_import :student, :fields => [:tid, :age, :gender, :nation],
                                :default => {
                                  :role => :student
                                }
end


describe SimpleExcelImport::Base do
  describe '导入老师' do
    before(:all) {TestMigration.up}
    after(:all) {TestMigration.down}

    before {
      @excel_file = Rails.root.join('spec/data/user.xls')
      @teacher_sample_file = Rails.root.join('spec/data/teacher_sample.xls')
      @student_sample_file = Rails.root.join('spec/data/student_sample.xls')
    }

    context "只解析, 不保存" do
  
      it "should get the users count" do
        expect{
          @parsed_users = User.parse_excel_teacher(@excel_file)
        }.to change{@parsed_users.count}.by(3)
      end

      it "should not be saved" do
        @parsed_users.each do |user|
          user.new_record?.should == true
        end
      end

      it "should be the correct user value" do
        @parsed_users.each do |user|
          if user.tid == '222'
            user.gender.should == '男'
          end
        end

        @parse_users.map{|user|user.age}.should = ["10","20","30"]

      end
    end

    context "解析同时保存实例到数据库" do
      it "should get the users count" do
        expect{
          @saved_users = User.import_excel_teacher(@excel_file)
        }.to change{@saved_users.count}.by(3)
      end

      it "should be saved" do
        @saved_users.each do |user|
          user.persisted?.should == true
        end
      end

      it "should be the correct user value" do
        @saved_users.each do |user|
          if user.tid == '222'
            user.gender.should == '男'
          end
        end

        @saved_users.map{|user|user.age}.should = ["10","20","30"]
      end

    end


    context "生成 teacher excel 示例文件" do
      it "should have correct field title" do
        spreadsheet = ImportFile.open_spreadsheet(@teacher_sample_file)
        header = spreadsheet.row(0)
        header[0].should == 'tid'
        header[1].should == 'age'
        header[2].should == 'gender'
        header[3].should == 'nation'
      end

      it "should get the correct sample users count" do
        expect{
          @sample_users = User.get_sample_excel_teacher(@teacher_sample_file)
        }.to change{@sample_users.count}.by(5)
      end
    end


    context "生成 student excel 示例文件" do
      it "should have correct field title" do
        spreadsheet = SimpleExcelImport::ImportFile.open_spreadsheet(@student_sample_file)
        header = spreadsheet.row(0)
        header[0].should == 'sid'
        header[1].should == 'age'
        header[2].should == 'gender'
        header[3].should == 'graduated'
      end

      it "should get the correct sample users count" do
        expect{
          @sample_users = User.get_sample_excel_student(@student_sample_file)
        }.to change{@sample_users.count}.by(5)
      end
    end

  end
  
end
