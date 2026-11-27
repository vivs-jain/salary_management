module Api
  module V1
    class UsersController < ApplicationController

      before_action :authenticate_user!
      before_action -> {
        authorize_permission!("users", "view")
      }

      # GET /api/v1/users
      def index
        users = User.select(
          :id,
          :first_name,
          :last_name,
          :email,
          :active,
          :last_login_at,
          :created_at
        ).order(:id)

        render json: {
          users: users
        }, status: :ok
      end

    end
  end
end