class TransferValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    @errors = record.errors

    validate_insufficient_balance
    validate_transfer_to_self
  end

  private

  def validate_insufficient_balance
    return unless @record.amount > @record.source.balance

    @errors.add(:base, "Insufficient wallet's balance")
  end

  def validate_transfer_to_self
    return unless @record.target.eql?(@record.source)

    @errors.add(:base, "Cannot transfer to the same wallet")
  end
end
