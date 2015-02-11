require 'server_spec_helper'

describe ListMore::Server do

  def app
    ListMore::Server.new
  end

  describe "GET /" do
    it "loads the homepage" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include "Loading.."
    end
  end
end
