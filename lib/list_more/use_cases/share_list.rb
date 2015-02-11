module ListMore
  class ShareList < UseCase
    attr_reader :params

    def run params

      shared_list = ListMore.shared_lists_repo.save params

      return false unless shared_list

      success shared_list: shared_list
      
    end

  end
end
