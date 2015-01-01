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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150101103547) do

  create_table "boards", force: true do |t|
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "boards", ["game_id"], name: "index_boards_on_game_id"

  create_table "games", force: true do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "squares", force: true do |t|
    t.integer  "board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "x_coord"
    t.integer  "y_coord"
    t.integer  "z_coord"
  end

  add_index "squares", ["board_id"], name: "index_squares_on_board_id"

end
