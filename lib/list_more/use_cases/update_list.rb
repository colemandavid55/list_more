module ListMore
  class UpdateList < UseCase
    attr_reader :params

    def run params
      @params = params

      list = ListMore.lists_repo.find_by_id params['id']

      unless list
        return failure "List does not exist in the database"
      end

      list_update = ListMore::Entities::List.new({:name => params['name'], :id => params['id']})
      list_update = ListMore.lists_repo.update list_update

      return failure unless list_update

      success list: list_update
    end

  end
end