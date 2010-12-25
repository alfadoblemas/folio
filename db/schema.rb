# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101224213709) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "rut"
    t.text     "address"
    t.string   "city"
    t.string   "industry"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["customer_id"], :name => "contacts_customer_index"

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "rut"
    t.text     "address"
    t.string   "city"
    t.string   "industry"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "phone"
    t.string   "fax"
  end

  add_index "customers", ["name"], :name => "customers_name_index"

  create_table "histories", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "comment"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "histories", ["invoice_id"], :name => "histories_invoice_index"
  add_index "histories", ["user_id"], :name => "histories_user_index"

  create_table "invoice_items", :force => true do |t|
    t.string   "product_id"
    t.integer  "quantity"
    t.text     "description"
    t.integer  "price"
    t.integer  "total"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_items", ["invoice_id"], :name => "iitems_invoice_index"
  add_index "invoice_items", ["product_id"], :name => "iitems_product_index"

  create_table "invoices", :force => true do |t|
    t.integer  "number"
    t.integer  "tax"
    t.integer  "net"
    t.integer  "total"
    t.integer  "customer_id"
    t.integer  "contact_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "taxed"
    t.date     "due"
    t.integer  "status_id"
    t.integer  "history_id"
    t.text     "comment"
    t.integer  "currency_id"
    t.date     "date"
    t.date     "close_date"
  end

  add_index "invoices", ["company_id"], :name => "invoices_company_index"
  add_index "invoices", ["contact_id"], :name => "invoices_contact_index"
  add_index "invoices", ["customer_id"], :name => "invoices_customer_index"
  add_index "invoices", ["number"], :name => "invoices_number_index"
  add_index "invoices", ["status_id"], :name => "invoices_status_index"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
