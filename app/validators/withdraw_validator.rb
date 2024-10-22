class WithdrawValidator < ActiveModel::Validator
  def validate(record)
    if record.amount > record.source.balance
      record.errors.add(:base, "Insufficient wallet's balance")
    end
  end
end
