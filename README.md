simple-excel-import
===================


## Target
Get data from excel file and save into database model

## Support
- xls, xlsx format, Microsoft Office 1997 - 2003

- sxc format, Libre Office


## Install
include in Gemfile:

```bash
gem 'simple-excel-import'
```

## How-To

```ruby
# declare in model
class User
  simple_excel_import :teacher, :fields => [:tid, :age, :gender, :nation]
                                :default => {
                                  :role => :teacher
                                }

  simple_excel_import :student, :fields => [:sid, :age, :gender, :graduated]
                                :default => {
                                  :role => :student
                                }
end
```


# parse excel file without saving
User.parse_excel_teacher(excel_file)
# -> return [user, user, user] user array


# parse excel file and save
User.import_excel_teacher(excel_file)

# generate sample excel file and return file object
User.get_sample_excel_teacher



## TODO
- support nil field in field list
:fields => [:tid, nil, :gender, :nation]

- more format files, etc, ods, good doc..

