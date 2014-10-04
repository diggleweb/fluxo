class Transaction < ActiveRecord::Base
  enum transaction_type: {
    :in => 0, :out => 1,          # show (green/red) and sumarize
    :balance => 2,                # show as special (gray), do not sumarize
    :transfer => 3,               # show as special (blue), do not sumarize
    :hidden => 4,                 # do not show, sumarize
    :fake_in => 5, :fake_out => 6 # show as some value, sumarize as some another value
  }

  belongs_to :category
  belongs_to :account
  belongs_to :payee

  validates :info,
            :account,
            :transaction_type,
            :amount_estimated,
            :date_estimated,
            presence: true

  validates :commited,  inclusion: { in: [false, true] }, allow_nil: false

  validates :info, length: { maximum: 40 }

  validates :date_transaction, :amount, presence: true, if: "true == commited"

  after_save :update_account

  before_validation :correct_values

  def show_amount
    return 0 unless self.transaction_type.present?
    case self.transaction_type.to_sym
    when :in, :out, :balance
      self.amount || 0
    when :transfer
      self.amount_show || 0
    end
  end

  def show_amount_estimated
    return 0 unless self.transaction_type.present?
    case self.transaction_type.to_sym
    when :in, :out, :balance
      self.amount_estimated || 0
    when :transfer
      self.amount_show_estimated || 0
    end
  end

  protected

    def update_account
      self.account.save
    end

    def correct_values
      return if !transaction_type

      case transaction_type.to_sym
      when :in
        self.amount = (amount || 0).abs
        self.amount_estimated = (amount_estimated || 0).abs
      when :out
        self.amount = -((amount || 0).abs)
        self.amount_estimated = -((amount_estimated || 0).abs)
      when :transfer
        self.amount_show = (amount || 0).abs
        self.amount_show_estimated = (amount_estimated || 0).abs
        self.amount = 0
        self.amount_estimated = 0
      end
    end

end
