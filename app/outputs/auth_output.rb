class AuthOutput < ApiOutput
  def format
    {
      id: @object.id,
      email: @object.email,
      full_name: @object.full_name,
      created_at: @object.created_at,
      updated_at: @object.updated_at,
      token: token,
    }
  end

  def login_format
    format.merge(token: token)
  end

  private

  def token
    @options[:token]
  end
end
