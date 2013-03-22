require 'simple_excel_import/import_file'

module SimpleExcelImport
  module Base
    extend ActiveSupport::Concern

    module ClassMethods

      def simple_excel_import(role, fields, default)
        # fields = fields[:fields]
        default = default[:default]
        
        positions = {0 => :login, 1 => :name, 2 => :email, 3 => :password}

        class_eval %(

      
          def self.parse_excel_#{role}(excel_file)
            user_params = {}
            users = []

            spreadsheet = SimpleExcelImport::ImportFile.open_spreadsheet(excel_file)
            header = spreadsheet.row(1)
            (2..spreadsheet.last_row).each do |i|
              row = Hash[[header, spreadsheet.row(i)].transpose].values

              #{fields}.each do |field|
                position = #{positions}.key(field)
                user_params[field] = row[position]

                user_params = user_params.merge(#{default})
              end

              user = User.new(user_params)

              users << user
            end

            users
          end

          def self.import_excel_#{role}(excel_file)
            user_params = {}
            users = []

            spreadsheet = SimpleExcelImport::ImportFile.open_spreadsheet(excel_file)
            header = spreadsheet.row(1)
            (2..spreadsheet.last_row).each do |i|
              row = Hash[[header, spreadsheet.row(i)].transpose].values

              #{fields}.each do |field|
                position = #{positions}.key(field)
                user_params[field] = row[position]

                user_params = user_params.merge(#{default})
              end

              user = User.create(user_params)

              users << user
            end

            users
          end

          def self.get_sample_excel_#{role}

            source_dir = File.join(File.dirname(__FILE__), '/spec/data/')
            source_data = source_dir + 'sample.yaml'
            target_file = source_dir + 'sample.xlsx'

            users_hash = YAML.load_file(source_data)

            p = Axlsx::Package.new
            p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
              sheet.add_row users_hash.first.keys
              users_hash.each do |user|
                sheet.add_row user.values
              end
              
            end
            p.use_shared_strings = true
            p.serialize(target_file)

            File.new(target_file)


          end
        )

      end
    end
  end
end

ActiveRecord::Base.send :include, SimpleExcelImport::Base