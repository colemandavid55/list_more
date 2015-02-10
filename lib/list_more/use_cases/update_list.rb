module ListMore
  class UpdateList < UseCase
    attr_reader :params

    def run params
      @params = params
      unless verify_fields
        return failure "Please check all fields"
      end


    end

    def verify_fields
      return false if !(params['name'] && params['list_id'])
    end
  end
end