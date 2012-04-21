# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120420083250) do

  create_table "fields", :force => true do |t|
    t.integer  "form_id"
    t.string   "question"
    t.string   "field_type"
    t.text     "options"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position"
  end

  add_index "fields", ["form_id"], :name => "index_fields_on_form_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "active"
  end

  create_table "notes", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.boolean  "hidden"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "questions", :force => true do |t|
    t.integer  "ticket_id"
    t.string   "question"
    t.text     "answer"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position"
  end

  add_index "questions", ["ticket_id"], :name => "index_questions_on_ticket_id"

  create_table "rules", :force => true do |t|
    t.integer  "provider_id"
    t.integer  "form_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "service_area_forms", :force => true do |t|
    t.integer  "default_provider_id"
    t.integer  "service_area_id"
    t.string   "title"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "service_areas", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "active"
  end

  create_table "tickets", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "opened_on"
    t.datetime "closed_on"
    t.integer  "creator_id"
    t.integer  "provider_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "service_area_id"
    t.integer  "location_id"
  end

  add_index "tickets", ["service_area_id"], :name => "index_tickets_on_service_area_id"

  create_table "user_service_areas", :force => true do |t|
    t.integer  "user_id"
    t.integer  "service_area_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "user_service_areas", ["service_area_id"], :name => "index_user_service_areas_on_service_area_id"
  add_index "user_service_areas", ["user_id"], :name => "index_user_service_areas_on_user_id"

  create_table "user_tickets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "provider"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "privilege"
    t.string   "password"
    t.string   "location"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "active"
  end

end
