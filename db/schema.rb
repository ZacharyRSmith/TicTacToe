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

ActiveRecord::Schema.define(version: 20150102120311) do

  create_table "boards", force: true do |t|
    t.integer  "game_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "squares_id_ary"
    t.integer  "size"
  end

  add_index "boards", ["game_id"], name: "index_boards_on_game_id"

  create_table "games", force: true do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "squares", force: true do |t|
    t.integer  "board_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "x_coord",    null: false
    t.integer  "y_coord",    null: false
    t.integer  "z_coord",    null: false
    t.string   "mark"
  end

  add_index "squares", ["board_id"], name: "index_squares_on_board_id"
  add_index "squares", ["x_coord"], name: "index_squares_on_x_coord"
  add_index "squares", ["y_coord"], name: "index_squares_on_y_coord"
  add_index "squares", ["z_coord"], name: "index_squares_on_z_coord"

end
