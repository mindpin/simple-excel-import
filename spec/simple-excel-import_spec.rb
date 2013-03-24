# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'db_init'

class TestMigration < ActiveRecord::Migration
  def self.up
    create_table :books, :force => true do |t|
      t.column :title, :string
      t.column :price, :integer
      t.column :kind,  :string
      t.column :url,   :string
    end

  end

  def self.down
    drop_table :books
  end
end

class Book < ActiveRecord::Base
  simple_excel_import :common, :fields => [:title, :price, :kind]


  simple_excel_import :program, :fields => [:title, :price, :url],
                                 :default => {
                                   :kind => '编程'
                                 }
end


describe 'Excel导入' do

  before {
    TestMigration.up
  }

  after { 
    TestMigration.down
  }

  describe '方法定义' do
    it {
      Book.methods.include?(:parse_excel_program).should == true
    }

    it {
      Book.methods.include?(:import_excel_program).should == true
    }

    it {
      Book.methods.include?(:get_sample_excel_program).should == true
    }

    it {
      Book.methods.include?(:parse_excel_common).should == true
    }

    it {
      Book.methods.include?(:import_excel_common).should == true
    }

    it {
      Book.methods.include?(:get_sample_excel_common).should == true
    }
  end

  describe ".parse_excel_xxx" do
    context 'common_books' do
      before {
        @parsed_common_books = Book.parse_excel_common File.new('spec/data/common_books.xls')
      }

      it {
        @parsed_common_books.count.should == 3
      }

      it {
        @parsed_common_books.each { |book|
          book.should be_new_record
        }
      }

      it {
        Book.count.should == 0
      }

      it '检查标题' do
        @parsed_common_books.map { |book|
          book.title
        }.should == ['冰与火之歌', '麦田守望者', '庆余年']
      end

      it '检查价格' do
        @parsed_common_books.map { |book|
          book.price
        }.should == [129, 29, 58]
      end

      it '检查分类' do
        @parsed_common_books.map { |book|
          book.kind
        }.should == ['奇幻', '外国', '通俗']
      end

      it '检查分类' do
        @parsed_common_books.map { |book|
          book.url
        }.should == [nil, nil, nil]
      end
    end

    context 'program_books' do
      before {
        @parsed_program_books = Book.parse_excel_program File.new('spec/data/program_books.xls')
      }

      it {
        @parsed_program_books.count.should == 4
      }

      it {
        @parsed_program_books.each { |book|
          book.should be_new_record
        }
      }

      it {
        Book.count.should == 0
      }

      it '检查标题' do
        @parsed_program_books.map { |book|
          book.title
        }.should == ['松本行弘的程序世界', 'HTML5移动开发即学即用', '版本控制之道——使用Git', 'Ruby Cookbook']
      end

      it '检查分类' do
        @parsed_program_books.map { |book|
          book.kind
        }.should == ['编程', '编程', '编程', '编程']
      end

      it '检查价格' do
        @parsed_program_books.map { |book|
          book.price
        }.should == [75, 59, 39, 108]
      end

      it '检查URL' do
        @parsed_program_books.map { |book|
          book.url
        }.should == ['http://sample/ruby', 'http://sample/html5', 'http://sample/git', 'http://sample/rubycook']
      end
    end
  end

  describe '.import_excel_xxx' do
    context 'common_books' do
      before {
        Book.import_excel_common File.new('spec/data/common_books.xls')
      }

      it {
        Book.count.should == 3
      }

      it '检查标题' do
        Book.all.map { |book|
          book.title
        }.should == ['冰与火之歌', '麦田守望者', '庆余年']
      end

      it '检查价格' do
        Book.all.map { |book|
          book.price
        }.should == [129, 29, 58]
      end

      it '检查分类' do
        Book.all.map { |book|
          book.kind
        }.should == ['奇幻', '外国', '通俗']
      end

      it '检查分类' do
        Book.all.map { |book|
          book.url
        }.should == [nil, nil, nil]
      end
    end

    context 'program_books' do
      before {
        Book.import_excel_program File.new('spec/data/program_books.xls')
      }

      it {
        Book.count.should == 4
      }

      it '检查标题' do
        Book.all.map { |book|
          book.title
        }.should == ['松本行弘的程序世界', 'HTML5移动开发即学即用', '版本控制之道——使用Git', 'Ruby Cookbook']
      end

      it '检查分类' do
        Book.all.map { |book|
          book.kind
        }.should == ['编程', '编程', '编程', '编程']
      end

      it '检查价格' do
        Book.all.map { |book|
          book.price
        }.should == [75, 59, 39, 108]
      end

      it '检查URL' do
        Book.all.map { |book|
          book.url
        }.should == ['http://sample/ruby', 'http://sample/html5', 'http://sample/git', 'http://sample/rubycook']
      end
    end
  end

  describe '.get_sample_excel_xxx' do
    before {
      sample_file = Book.get_sample_excel_common
      @spreadsheet = SimpleExcelImport::ImportFile.open_spreadsheet sample_file
    }

    it {
      @spreadsheet.last_row.should == 1 # 共一行
    }

    it {
      @spreadsheet.last_column.should == 3 # 共三列
    }

    it {
      @spreadsheet.cell(1, 1).should == I18n.t('activerecord.attributes.book.title')
    }

    it {
      @spreadsheet.cell(1, 2).should == I18n.t('activerecord.attributes.book.price')
    }

    it {
      @spreadsheet.cell(1, 3).should == I18n.t('activerecord.attributes.book.kind')
    }
  end


  # describe "生成 excel 示例文件" do
  #   it "should have correct field title" do
  #     spreadsheet = SimpleExcelImport::ImportFile.open_spreadsheet(@sample_file)
  #     header = spreadsheet.row(1)

  #     # 取得表的字段列表，并把 id 字段去掉
  #     user_fields = User.columns.map {|c| c.name }
  #     user_fields.delete('id')

  #     cn_fields = User.do_i18n

  #     # 把生成的表头 跟 数据表字段比较
  #     header.each_with_index do |header_column, index|
  #       header_column.should == cn_fields[index].to_s
  #     end

  #   end

  # end


  
end
