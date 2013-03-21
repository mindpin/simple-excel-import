require 'simple_excel_import/import_file'

module SimpleExcelImport
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      def simple_excel_import(role, fields={})
        fields = fields[:fields]
        positions = {0 => :login, 1 => :name, 2 => :email, 3 => :password}

        class_eval %(
      
          def self.parse_excel_teacher(excel_file)
            user_params = {}
            users = []

            spreadsheet = SimpleExcelImport::ImportFile.open_spreadsheet(excel_file)
            header = spreadsheet.row(1)
            (2..spreadsheet.last_row).each do |i|
              row = Hash[[header, spreadsheet.row(i)].transpose].values

              #{fields}.each do |field|
                position = #{positions}.key(field)
                user_params[field] = row[position]
              end

              user = User.new(user_params)
          
              users << user
            end

            users
          end
        )

      end
    end
  end
end

ActiveRecord::Base.send :include, SimpleExcelImport::Base