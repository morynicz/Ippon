shared_examples_for "tournament_updateable" do
  describe "PATCH update" do
    context "when the group fight exists" do
      let(:resource) { resource_class.create(attrs) }
      let(:resource_id) { resource.id }

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(tournament.id)
        end
        context "when the update atttributes are valid" do
          it "should return correct status" do
            action
            resource.reload
            expect(response.status).to eq(204)
          end

          it "should update resource attributes" do
            action
            resource.reload
            expect_hash_eq_resource(update_attrs, resource)
          end
        end

        context "when the update attributes are not valid" do
          let(:update_attrs) { bad_attributes }

          it "should not update resource attributes" do
            action
            resource.reload
            expect_hash_eq_resource(attrs, resource)
          end

          it "should return unporcessable entity" do
            action
            resource.reload
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      context "when the user isn't authorized" do
        it "should respond with unauthorized status" do
          action
          resource.reload
          expect(response).to have_http_status :unauthorized
        end

        it "should not update resource attributes" do
          action
          resource.reload
          expect_hash_eq_resource(attrs, resource)
        end
      end
    end

    context "when the resource doesn't exist" do
      let(:resource_id) {-9999}

      context "when user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end