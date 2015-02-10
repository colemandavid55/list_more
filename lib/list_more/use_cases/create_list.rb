module ListMore
  class CreateList < UseCase
    attr_reader :params

    def run params
      @params = params

      list = ListMore::Entities::List.new({:user_id => params['user_id'], :name => params['name']})
      list = ListMore.lists_repo.save list

      return failure unless list

      success list: list
    end

  end
end