module ListMore
  class UpdateItem < UseCase
    attr_reader :params

    def run params
      @params = params

      item_update = ListMore::Entities::Item.new({:id => params['id'], :content => params['content'], :user_id => params['user_id'], :list_id => params['list_id']})
      item_update = ListMore.items_repo.update item_update

      return failure unless item_update
      success item: item_update
      
    end
  end
end