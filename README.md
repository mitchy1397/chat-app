# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


<!--① READMEにDB設計を記述
マークダウン方式を用いてテーブルや見出しを見やすくする -->
<!-- ② アソシエーションの記述 -->

# テーブル設計

## users テーブル

| Column             | Type    | Options     |
| ------------------ | ------- | ----------- |
| name               | string  | null: false |
| email              | string  | null: false, unique:true |
| encrypted_password | string  | null: false |

## Association

- has_many :room_users
- has_many :rooms, through: :room_users
- has_many :messages



## rooms テーブル

| Column           | Type    | Options     |
| ---------------- | ------- | ----------- |
| name             | string  | null: false |

## Association

- has_many :room_users
- has_many :users, through: :room_users
- has_many :messages



## room_users テーブル

| Column    | Type       | Options                        |
| ----------| ---------- | ------------------------------ |
| users     | references | null: false, foreign_key: true |
| room      | references | null: false, foreign_key: true |

### Association

- belongs_to :room
- belongs_to :user


## messages テーブル

| Column    | Type       | Options                        |
| ----------| ---------- | ------------------------------ |
| content   | string     |
| users     | references | null: false, foreign_key: true |
| room      | references | null: false, foreign_key: true |

### Association

- belongs_to :room
- belongs_to :user