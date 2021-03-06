require 'test_helper'

class TaxisControllerTest < ActionController::TestCase
  setup do
    Taxi.delete_all
    @taxi1 = Taxi.get_or_create("asd123")
    @taxi2 = Taxi.get_or_create("qwe234")
    @taxi3 = Taxi.get_or_create("ert345")
  end

  test "get index no params" do
    get :index, :format => :json
    taxis = MultiJson.load(@response.body)

    assert taxis.size==3, "there must be 3 taxis"
    should_contain_taxi(taxis, @taxi1)
    should_contain_taxi(taxis, @taxi2)
    should_contain_taxi(taxis, @taxi3)

  end

  test "post reset should return no taxis" do
    post :reset, :format => :json

    resp = @response.body

    assert resp == "3"
    assert Taxi.all.size==0
  end

  test "auth with existing installation_id does not create taxi" do
    assert_no_difference 'Taxi.all.size' do
      post :auth, {:format => :json, :installation_id=>@taxi1.installation_id}
      r = MultiJson.load(@response.body)
      assert should_equal_taxi(r,@taxi1)
    end

  end

  test "auth with new installation_id creates a taxi" do
    assert_difference 'Taxi.all.size',1 do
      post :auth, {:format => :json, :installation_id=>"XYZ123"}
      r = MultiJson.load(@response.body)
      assert !should_equal_taxi(r,@taxi1)
      assert !should_equal_taxi(r,@taxi2)
      assert !should_equal_taxi(r,@taxi3)
      assert should_equal_taxi(r, Taxi.last)
    end
  end




end
