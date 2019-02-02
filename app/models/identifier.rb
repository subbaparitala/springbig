class Identifier < ApplicationRecord
  belongs_to :user
  has_many :csv_datas
  validates :name, presence: true

  def self.import(file, identifier)
    record = {identifier: identifier}
    row_count = CSV.foreach(file.path, headers: true).count
    raise 'Atleast one row should be exist in the CSV' if row_count < 1
    CSV.foreach(file.path, headers: true) do |row|
      index = ($. - 1)
      str_hash = row.to_h.merge(row: index).merge(record)
      attrs = ActiveSupport::HashWithIndifferentAccess.new(str_hash)
      validator = Validator.new(attrs)
      unless validator.valid?
        attrs[:message] = validator.errors.full_messages.join('. ')
        attrs[:is_failed] = true
      end
      csv_data = CsvData.find_by(row: index, identifier: identifier)
      cp = if csv_data.present? && csv_data.is_failed == true
             if validator.valid?
               attrs[:message] = 'data corrected.'
               attrs[:is_failed] = false
             end
             csv_data.update_attributes(attrs)
           elsif !csv_data.present?
             CsvData.create!(attrs)
           end
      puts "*" * 50, cp.inspect
    end
  end

end
