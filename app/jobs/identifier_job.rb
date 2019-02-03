require 'csv'
class IdentifierJob < ApplicationJob
  queue_as :default

  def perform(file_path, identifier)
    record = {identifier: identifier}
    CSV.foreach(file_path, headers: true) do |row|
      index = ($. - 1)
      str_hash = row.to_h.merge(row_id: index).merge(record)
      attrs = ActiveSupport::HashWithIndifferentAccess.new(str_hash)
      validator = RowValidator.new(attrs)
      unless validator.valid?
        attrs[:message] = validator.errors.full_messages.join('. ')
        attrs[:is_failed] = true
      end
      csv_data = CsvData.find_by(row_id: index, identifier: identifier)
      if csv_data.present?
        if validator.valid? && csv_data.is_failed == true
          attrs[:message] = 'Data corrected.'
          attrs[:is_failed] = false
        end
        csv_data.update_attributes(attrs)
      elsif !csv_data.present?
        CsvData.create!(attrs)
      end
    end
  rescue => e
    puts "Jobs Failed: #{e.message}"
  end
end