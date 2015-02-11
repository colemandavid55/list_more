module ListMore
  class Serializer < UseCase
    def run entity
      case entity
      when ListMore::Entities::List
        serialize_list entity
      when ListMore::Entities::Item
        serialize_item entity
      when ListMore::Entities::User
        serialize_user entity
      end
    end

    def serialize_list list
      {
        :id      => list.id.to_i,
        :name    => list.name,
        :user_id => list.user_id.to_i
      }
    end

    def serialize_item item
      {
        :id      => item.id.to_i,
        :content => item.content,
        :list_id => item.list_id.to_i,
        :user_id => item.user_id.to_i
      }
    end

    def serialize_user user
      {
        :id        => user.id.to_i,
        :username  => user.username,
        :email     => user.email
        # :gravatars => user.gravatar_url(128)
      }
    end
  end
end