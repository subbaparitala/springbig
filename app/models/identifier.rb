class Identifier < ApplicationRecord
  belongs_to :user
  has_many :csv_datas, dependent: :destroy
  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9]*\Z/,  message: "special character are not allowed." }

end
