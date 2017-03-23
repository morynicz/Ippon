shared_examples_for 'tournament_deletable' do

  let(:action) { xhr :delete, :destroy, format: :json, id: resource_id }


  describe 'shared DELETE: destroy' do
    context "when the resouce exists" do
      let(:resource_id){resource.id}

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(tournament.id)
        end
        it "should respond with 204 status" do
          action
          expect(response.status).to eq(204)
        end

        it "should delete the object" do
          action
          expect(resource.class.exists?(resource_id)).to be false
        end

        #it "should destroy all children of this object" do
      #    action
      #    for child_id in children_ids
      #      expect(child_exist_checker.call(child_id)).to be false
      #    end
      #  end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
        it "should not delete the resource" do
          action
          expect(resource.class.exists?(resource_id)).to be true
        end
      #  it "should not delete the children" do
      #    for child_id in children_ids
      #      expect(child_exist_checker.call(child_id)).to be false
      #    end
      #  end
      end
    end

    context "when the resource doesn't exist" do
      let(:resource_id) {-9999}

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
      end

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(tournament.id)
        end
        it "should respond with not found status" do
          action
          expect(response).to have_http_status :not_found
        end
      end
    end
  end
end
