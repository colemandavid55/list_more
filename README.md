ListMore

Project Overview

ListMore is an "over-engineered" application primarily demonstrating a foundation in SOLID software design principles, testing and project management through the use of the entity model design pattern, an extensive testing suite and Github issues. Within this application, a user can signup/login and create a list, and also create the items within a list.  This list can be also be shared with other users, allowing them to edit or delete the list. Overall, this application is designed to showcase the skill set acquired at MakerSquare.

Technology

This application uses the following:

1.  Sinatra Server
2.  Bcrypt
3.  PostgreSQL
4.  RSpec
5.  Ruby
6.  Javascript MVC Framework => Mithril
7.  HTML/CSS => Bootstrap
8.  JSON
9.  Rest-client
10. Pry-byebug (for debugging)

User Stories

A User can...

1. Sign up and sign in
2. Create/read/update/delete their own lists and items
3. Read another user’s lists and items
4. Share a list with another user

Software Design

Entities: 
Within the application, there exist three entities. User, List, and Item. Each of these is a subclass of the module Entities and inherits from the OpenStruct class in Ruby. By making each entity an OpenStruct, we can dynamically add both attributes and methods, thus allowing the code to operate independently of both the repositories and the server. Use of the entity model, as opposed to dealing with ordinary ruby hashes, is essential when it comes to the encapsulation of both data and methods. For example, the user entity has two methods (update_password and has_password?). In this way, data about a user, coming from both the server and the database, is delivered in a consistent format with these specific methods included.

          module ListMore
            module Entities    
              class User < OpenStruct

                def update_password password
                  self.password_digest = BCrypt::Password.create(password)
                end

                def has_password? password
                  x = BCrypt::Password.new(self.password_digest)
                  x == password
                end
                
              end
            end
          end


Repositories: 
There are separate repositories for users, lists, items, shared_lists and sessions. The file repo_helper.rb defines a connection to the database and stores it in an instance variable. This allows each repository to contain code that relates directly to the repository to which it connects, making calls to a variable set outside each individual repository class. For users, lists, and items, each repository contains a build_entity method, where entity could be user. By returning the data this way, one can decouple the logic associated with using data returned from the server by ensuring consistency and predictable attributes from objects returned in this way.

          module ListMore
            class RepoHelper
              attr_reader :db

              def initialize dbname
                db_data = if ENV['RACK_ENV'] == 'production'
                  parse_rds_string
                else
                  {host: 'localhost', dbname: dbname}
                end

                @db = PG.connect(db_data)
              end

              def parse_rds_string
                rds_string = ENV['DATABASE_URL']
                data = rds_string.split(/\/|:|@/)
                {
                  host: data[5],
                  port: data[6],
                  user: data[3],
                  password: data[4],
                  dbname: data.last
                }
              end

            end
          end


Use Cases: 
These closely follow user stories. I implemented use cases because they allow one the ability to fully envision the frontend of an application whilst building the backend. These also provide an excellent means to test the interaction between the repositories and the entities. For example, when creating an item, the run method within the CreateItem use case will define a variable equal to a new instance of the item entity with various parameters constituting the item object. Then, this new item object is saved to the items repository, which returns another item entity object. This pattern allows one to send an object to the server with the intention of creating an item. The object can contain anything because all the entities inherit from OpenStruct. This is particularly useful when it comes to validation through tokens, which will be discussed in further detail below. In addition to the decoupling effect use cases have on overall software design, they encourage testing. Tests of use cases tend to simulate user interaction and help to ensure a fully functioning backend.

          module ListMore
            class CreateItem < UseCase

              def run params

                item = ListMore::Entities::Item.new({:content => params['content'], :user_id => params['user_id'], :list_id => params['list_id']})
                item = ListMore.items_repo.save item

                return failure unless item

                success item: item
              end

            end
          end


Serializer: 
The serializer is listed under use cases but is slightly different than the others. An example is the create_item use case, a class that essentially describes a user story. The serializer on the other hand is the facilitator between the objects returned from the database and whatever requirements exists on the front end. If, in the case of the create_item method, our front side needs the item data in a certain format, the serializer guarantees all data sent to the client contains all necessary information. It takes whatever parameters are entered and decides whether it is a list, user or item. Next, it will create and return, to the client side, a useable object. This ensures a uniformity of objects being sent to the browser, while at the same time, not depending on exactly what our database is returning.

          def serialize_item item
                {
                  :id      => item.id.to_i,
                  :content => item.content,
                  :list_id => item.list_id.to_i,
                  :user_id => item.user_id.to_i
                }
              end


Validation: 
The application uses a token based validation system. When a user signs in, a session token is created using the Secure Random gem and saved in a sessions repository along with the id of the user to which it belongs. When any request is made to the Sinatra endpoints, excluding root path and sign in/up, this token is added to the object that is sent to the server. Before any endpoints are visited, the server verifies the presence of a token within the request body and that the token is indeed valid. After which, the request is sent to the appropriate endpoint.

          before do
              @body = request.body.read
              @body = "{}" if @body.length == 0
              @params = JSON.parse(@body)
              puts "Got params: #{@params}"

              puts "PATH INFO: #{request.path_info.inspect}"
              pass if ['/', '/signup', '/signin'].include? request.path_info
              
              verified = ListMore::VerifyToken.run @params
              return {error: 'not authenticated'}.to_json unless verified
          end


Sinatra: 
The server is written in Sinatra. There are endpoints for everything that a user can do with the application. Each makes use of a (nearly) RESTful url structure. A before method runs on every request received, storing request.body.read in an instance variable used by all endpoints. At endpoints other than root and signin/up pages, the request is then authenticated by checking for a token that must be included in the request from the client side. Typically, a request is parsed from JSON, has its token verified, interacts with a repository by way of the entities created by use cases, serializes the data received from the repository before it is converted back to JSON and sent to the browser.

          get '/users' do
              users = ListMore.users_repo.all
              data = users.map { |user| ListMore::Serializer.run user }
              {
                'users' => data
              }.to_json
          end

RSpec: 
Test driven development stood out to me very early as an excellent way to understand fully what a code base is accomplishing. Each use case, repository and entity was (nearly) fully tested before writing server endpoints or frontend javascript. In this way, writing the endpoints is generally a matter of a few lines of code, the functionality of which has already been tested. Additionally, a full testing suite provides the ability to refactor code later on without worry. Simply run the tests, refactor, and repeat. 

          describe ListMore::CreateList do

            let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
            let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password_digest => "pitbull"})}

            before(:each) do
              dbhelper.drop_tables 
              dbhelper.create_tables 
            end

            it "will create a list" do
              user = ListMore.users_repo.save user_1

              params = {
                'name' => "Dogs",
                'user_id' => user.id
              }

              result = ListMore::CreateList.run params

              expect(result.success?).to be_true
              expect(result.list.name).to eq "Dogs"
              expect(result.list.user_id).to eq "1"
              expect(result.list.id.to_i).to be_a Integer
            end
          end

Mithril: 
This is a client-side Javascript MVC framework which divides the frontend code into a data layer (model), a user interface layer (view), and a glue layer (controller). The goal of the framework is to make application code more readable and maintainable. Mithril provides an excellent platform upon which to practice functional programming. Two important features of Mithril are data binding and routing. Although this is a single page application, m.route() provides an excellent way in which to simulate navigating a tradition application. By defining routes and corresponding modules for each "page" in our application, one can "route" the user to various modules and have this reflected in the url. Data binding is another key feature. This provides a way to connect a DOM element to a Javascript variable so that updating one updates the other. Internally, Mithril keeps a virtual representation of the DOM commonly referred to as the virtual DOM (React.js is similar in this respect). Mithril scans this cached virtual DOM for changes and only re-renders those portions that it must. This means the re-rendering is rather fast.

          m.route(document.getElementById('app'), "/", {
            "/": Welcome,
            "/signup": SignUp,
            "/signin": SignIn,
            "/users": UserHome,
            "/logout": Welcome,
            "/users/:id": UserLists,
            "/users/:userId/lists/:id": UserItems,
            "/lists/:id": EditList,
            "/items/:id": EditItem
          })


Extensions

Ideally, there should be an entity class for any data coming from the repositories, as well as a case within the serializer switch statement to account for these types other types of entities.

There should be more tests. In addition to many testing tools that exist for javascript, the use of which ensures a consistent frontend code base, RSpec can accomplish much more than it is currently. Although, I had to abandon testing the endpoints in order to expedite the building of the project overall, a fully tested backend is the best way to ensure a application that is consistent and refactorable.

There is a bug that exists deep within the ruby interpretter. Infrequently and inconsistently, the server will fail to respond because of a "segmentation fault-

 - "...is a fault raised by hardware with memory protection, notifying an operating system (OS) about a memory access violation. The OS kernel will in response usually perform some corrective action, generally passing the fault on to the offending process by sending the process a signal."




