simple-excel-import
===================


## Use for
import model by excel file


## Install
include in Gemfile:

```bash
gem 'simple-excel-import'
```

## Usage

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


# parse excel file without save into database
User.parse_excel_teacher(excel_file)
# -> return [user, user, user] user array


# parse excel file and save into database
User.import_excel_teacher(excel_file)

# generate sample excel file and return file object
User.get_sample_excel_teacher

```

then

```ruby
```

## TODO
# to support nil field in field list
```ruby
class User
  simple_excel_import :teacher, :fields => [:tid, nil, :gender, :nation]
end
```

