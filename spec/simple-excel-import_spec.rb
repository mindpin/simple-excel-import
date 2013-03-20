require 'spec_helper'
require 'db_init'


class TestTeachersMigration < ActiveRecord::Migration
  def self.up
    create_table :teachers, :force => true do |t|
      t.column :tid, :string
      t.column :age, :string
      t.column :gender, :string
      t.column :nation, :string
    end

  end

  def self.down
    drop_table :teachers
  end
end


class TestStudentsMigration < ActiveRecord::Migration
  def self.up

    create_table :students, :force => true do |t|
      t.column :sid, :string
      t.column :age, :string
      t.column :gender, :string
      t.column :graduated, :string
    end
  end

  def self.down
    drop_table :students
  end
end




describe SimpleExcelImport::Base do
  describe '导入老师' do
    before(:all) {TestTeachersMigration.up}
    after(:all) {TestTeachersMigration.down}

    before {
      @user = User.create
    }
  end
  
end