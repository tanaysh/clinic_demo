# frozen_string_literal: true

module CustomTokenResponse
  def body
    user_details = User.find(@token.resource_owner_id)
    {
      success: true,
      message: '',
      data: {
        token: super,
        user: ActiveModelSerializers::SerializableResource.new(
          user_details,
          serializer: UserSerializer
        )
      },
      meta: [],
      errors: []
    }
  end
end
