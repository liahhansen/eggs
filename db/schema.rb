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

ActiveRecord::Schema.define(:version => 20100503180523) do

  create_table "backup", :force => true do |t|
    t.string   "storage"
    t.string   "trigger"
    t.string   "adapter"
    t.string   "filename"
    t.string   "path"
    t.string   "bucket"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deliveries", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "farm_id"
    t.date     "date"
    t.string   "status"
    t.datetime "opening_at"
    t.datetime "closing_at"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "minimum_order_total"
    t.boolean  "deductions_complete", :default => false
    t.boolean  "finalized_totals",    :default => false
  end

  create_table "email_templates", :force => true do |t|
    t.string   "subject",    :null => false
    t.string   "from",       :null => false
    t.string   "bcc"
    t.string   "cc"
    t.text     "body",       :null => false
    t.text     "template"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "farm_id"
    t.text     "notes"
    t.string   "name"
    t.string   "identifier"
  end

  create_table "farms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
    t.string   "paypal_link"
    t.string   "contact_email"
    t.string   "contact_name"
    t.string   "subdomain",                      :default => "soulfood"
    t.string   "mailing_list_subscribe_address"
    t.string   "address"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "host_name"
    t.string   "host_phone"
    t.string   "host_email"
    t.string   "address"
    t.text     "notes"
    t.string   "time_window"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "farm_id"
    t.string   "label_color", :default => "000000"
  end

  create_table "members", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "neighborhood"
    t.datetime "joined_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "alternate_email"
    t.text     "notes"
    t.boolean  "joined_google_groups", :default => true
  end

  create_table "order_items", :force => true do |t|
    t.integer  "stock_item_id"
    t.integer  "order_id"
    t.integer  "quantity"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "member_id"
    t.integer  "delivery_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "finalized_total"
    t.integer  "location_id"
  end

  create_table "pickups", :force => true do |t|
    t.integer  "delivery_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.float    "price"
    t.boolean  "estimated"
    t.integer  "farm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "price_code"
    t.string   "category"
    t.integer  "default_quantity",   :default => 100
    t.integer  "default_per_member", :default => 4
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snippets", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "identifier"
    t.integer  "farm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_items", :force => true do |t|
    t.integer  "delivery_id"
    t.integer  "product_id"
    t.integer  "max_quantity_per_member"
    t.integer  "quantity_available"
    t.boolean  "substitutions_available"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hide"
    t.string   "product_name"
    t.text     "product_description"
    t.float    "product_price"
    t.boolean  "product_estimated"
    t.string   "product_price_code"
    t.string   "product_category"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "member_id"
    t.integer  "farm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "deposit_type",        :default => "unknown (old system)"
    t.boolean  "deposit_received",    :default => true
    t.boolean  "joined_mailing_list", :default => true
    t.boolean  "pending",             :default => false
    t.string   "referral"
  end

  create_table "transactions", :force => true do |t|
    t.date     "date"
    t.float    "amount"
    t.string   "description"
    t.integer  "member_id"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "debit"
    t.float    "balance"
    t.integer  "subscription_id"
  end

  create_table "users", :force => true do |t|
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "email"
    t.integer  "member_id"
    t.string   "perishable_token"
    t.boolean  "active",            :default => false, :null => false
  end

end
