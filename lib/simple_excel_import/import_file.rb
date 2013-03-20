module SimpleExcelImport

  module ImportFile

    class FormatError < Exception; end

    def self.open_spreadsheet(file)
      original_filename = file.original_filename
      case File.extname(original_filename)
      when ".sxc" then Roo::Openoffice.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise FormatError.new("Incorrect format #{original_filename}")
      end
    end
    
  end

end