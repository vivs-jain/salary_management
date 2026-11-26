
module Api
  module V1
    class SessionsController < ApplicationController

      # POST /api/v1/login
      def create
        email = params[:email].to_s.strip.downcase
        password = params[:password]

        user = User.find_by(email: email)
        if user&.active? && user.authenticate(password)
          # Prevent session fixation
          reset_session

          session[:user_id] = user.id

          render json: {
            message: "Login successful",
            user: user_response(user),
            csrf_token: form_authenticity_token
          }, status: :ok
        else
          render json: {
            error: "Invalid email or password"
          }, status: :unauthorized
        end
      end

      # GET /api/v1/me
      def show
        user = User.find_by(id: session[:user_id])

        if user&.active?
          render json: {
            user: user_response(user)
          }, status: :ok
        else
          reset_session if session[:user_id].present?

          render json: {
            error: "Not authenticated"
          }, status: :unauthorized
        end
      end

      # DELETE /api/v1/logout
      def destroy
        reset_session

        render json: {
          message: "Logout successful",
          csrf_token: form_authenticity_token
        }, status: :ok
      end

      private

      def user_response(user)
        {
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email
        }
      end

    end
  end
end
