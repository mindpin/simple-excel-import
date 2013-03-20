module SimpleExcelImport
  module Base
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def simple_excel_import(role, fields={})

        class_eval %(
        )

      end
    end
  end
end

ActiveRecord::Base.send :include, SimpleExcelImport::Base