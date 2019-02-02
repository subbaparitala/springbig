class RowValidator
  include ActiveModel::Validations
  attr_accessor :first, :last, :phone, :email, :row, :identifier

  validates :phone, presence: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validate :verify_phone_number
  validate :verify_first_and_last_name

  def initialize(opts)
    self.first = opts[:first]
    self.last = opts[:last]
    self.phone = opts[:phone]
    self.email = opts[:email]
    self.row = opts[:row]
    self.identifier = opts[:identifier]
  end

  private

  def verify_phone_number
    ph = self.phone.scan(/\d+/).join('')
    errors.add(:phone, 'is the wrong length (should be 10 characters).') if (Math.log10(ph.to_i).to_i + 1) != 10
    errors.add(:phone, 'is invalid.') if ([0, 1].include?(ph[0]) || [0, 1].include?(ph[3]))
  end

  def verify_first_and_last_name
    errors.add(:base, 'First name or last name shoul be present.') unless first.present? || last.present?
  end
end