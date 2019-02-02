class CsvData < ApplicationRecord
  belongs_to :identifier

  scope :validation_failed_datas, -> { where(is_failed: true) }
  scope :validation_success_datas, -> { where(is_failed: false) }

end
