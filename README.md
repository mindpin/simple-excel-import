simple-excel-import
===================

[![Build Status](https://travis-ci.org/mindpin/simple-excel-import.png?branch=master)](https://travis-ci.org/mindpin/simple-excel-import)
[![Coverage Status](https://coveralls.io/repos/mindpin/simple-excel-import/badge.png?branch=master)](https://coveralls.io/r/mindpin/simple-excel-import)
[![Code Climate](https://codeclimate.com/github/mindpin/simple-excel-import.png)](https://codeclimate.com/github/mindpin/simple-excel-import)


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

## How to use

in a model

```ruby
class Book < ActiveRecord::Base
  simple_excel_import :common, :fields => [:title, :price, :kind]

  simple_excel_import :program, :fields => [:title, :price, :url],
                                :default => {
                                  :kind => '编程'
                                }
end
```

then, you can call Model.parse_excel_xxx

```ruby
# parse excel file without saving
Book.parse_excel_common(excel_file)
# -> return a array of <#Book> with fields title, price, kind filled

Book.parse_excel_program(excel_file)
# -> return a array of <#Book> with fields title, price, url filled, and kind of default value '编程'
```

you can call Model.import_excel_xxx to save models into database

```ruby
Book.parse_excel_common(excel_file)
Book.parse_excel_program(excel_file)
```

## TODO
- support nil field in field list
:fields => [:tid, nil, :gender, :nation]

- more format files, etc, ods, good doc..

