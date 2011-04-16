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

ActiveRecord::Schema.define(:version => 20110416193339) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "rut"
    t.text     "address"
    t.string   "city"
    t.string   "industry"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
    t.integer  "admin_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "accounts", ["admin_id"], :name => "altered_accounts_admin_index"

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "contacts", ["account_id"], :name => "contacts_account_index"
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
    t.integer  "account_id"
    t.string   "alias",      :default => ""
  end

  add_index "customers", ["account_id"], :name => "customers_account_index"
  add_index "customers", ["name"], :name => "customers_name_index"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "histories", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "comment"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.integer  "history_type_id"
    t.boolean  "system",          :default => false
  end

  add_index "histories", ["account_id"], :name => "histories_account_index"
  add_index "histories", ["history_type_id"], :name => "histories_type_index"
  add_index "histories", ["invoice_id"], :name => "histories_invoice_index"
  add_index "histories", ["user_id"], :name => "histories_user_index"

  create_table "history_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_items", :force => true do |t|
    t.integer  "product_id",  :limit => 255
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
    t.integer  "account_id"
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
    t.string   "subject"
  end

  add_index "invoices", ["account_id"], :name => "altered_invoices_company_index"
  add_index "invoices", ["account_id"], :name => "invoices_account_index"
  add_index "invoices", ["contact_id"], :name => "altered_invoices_contact_index"
  add_index "invoices", ["currency_id"], :name => "altered_invoices_currency_index"
  add_index "invoices", ["customer_id"], :name => "altered_invoices_customer_index"
  add_index "invoices", ["history_id"], :name => "altered_invoices_history_index"
  add_index "invoices", ["number"], :name => "altered_invoices_number_index"
  add_index "invoices", ["status_id"], :name => "altered_invoices_status_index"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "perishable_token",    :default => "",    :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "admin",               :default => false
    t.boolean  "active",              :default => true
  end

  add_index "users", ["account_id"], :name => "altered_users_account_index"
  add_index "users", ["account_id"], :name => "altered_users_company_index"
  add_index "users", ["perishable_token"], :name => "altered_users_ptoken_index"

end
