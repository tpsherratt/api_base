require 'pundit'

# Base functionality for all API controllers, eg error handling
module ApiBase
  module Concerns
    module ApplicationControllerBase
      extend ActiveSupport::Concern

      # Error classes to be used throughout steak api engines
      # Add here if you require another general error, but if it
      # is specific to one engine, stick it in that ApplicationController,
      # or if it is specif to a set of functionality provided by an engine
      # add it to a concern (similar to this one) in that engine, for
      # inclusion in ApplicationControllers as appropriate.
      # TS
      class ApiBase::InvalidParameter < StandardError; end
      class ApiBase::Unauthorized < StandardError; end
      class ApiBase::Conflict < StandardError; end
      class ApiBase::Forbidden < StandardError; end

      # Custom http status codes
      ApiBase::NOT_CONFIRMED = 494

      # include access control and authorization library
      include Pundit

      included do

        # api controllers should only be responding to json
        respond_to :json

        # handle the following errors with the provided methods
        rescue_from ApiBase::Conflict, with: :conflict
        rescue_from ApiBase::InvalidParameter, with: :unprocessable
        rescue_from ApiBase::Unauthorized, with: :unauthorized
        rescue_from ApiBase::Forbidden, with: :forbidden
        rescue_from Storm::RecordNotFound, with: :record_not_found
        rescue_from Storm::InvalidRecordError, with: :unprocessable
        rescue_from Storm::NonUniqueRecordError, with: :conflict
        rescue_from ActionController::RoutingError, with: :routing_error
        rescue_from Pundit::NotAuthorizedError, with: :unauthorized
      end


      private

      # methods to handle exceptions raised from within the classes

      def conflict(exception)
        # had to remove as gives away details of our db structure.
        # TODO: come up with solution to give further details
        if exception.is_a? ApiBase::Conflict
          message = exception.message || "Conflict"
        else
          message = "Conflict"
        end
        render status: :conflict, json: { message: message } 
      end

      def forbidden(expection)
        render status: :forbidden, json: { message: "Forbidden" }
      end

      def record_not_found(exception)
        render status: :not_found, json: { message: "No Such Record" }
      end

      def routing_error(exception)
        render status: :not_found, json: { message: "No Such Route" }
      end

      def unauthorized
        render status: :unauthorized, json: { message: "Unauthorized" }
      end

      def unprocessable(exception)
        message = exception.message || "The data you provided was unprocessable"
        render status: :unprocessable_entity, json: { message: message }
      end
    end
  end
end