shared_examples_for "tournament_createable" do
  describe "POST :create" do

    subject(:results) {JSON.parse(response.body)}

    context "when the user is not authenticated" do
      it "does not create a resource" do
        expect {
          action
        }.to_not change(resource_class, :count)
      end

      it "denies access" do
        action
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when the user is authenticated", authenticated: true do
      context "when user is authorized" do
        before do
          authorize_user(tournament.id)
        end

        context "with invalid attributes" do

          let(:attributes){ bad_attributes }

          it "does not create a resource" do
            expect {
              action
            }.to_not change(resource_class, :count)
          end

          it "returns the correct status" do
            action
            expect(response).to have_http_status :unprocessable_entity
          end
        end

        context "with valid attributes" do
          it "creates a resource" do
            expect {
              action
            }.to change(resource_class, :count).by(1)
          end

          it "returns the correct status" do
            action
            response.inspect
            expect(response).to be_successful
          end

          it "creates a resource with proper values" do
            action
            res = resource_class.find(get_resource_id_from_results(results))
            expect_hash_eq_resource_create(attributes, res)
          end
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not create a group fight" do
          expect {
            action
          }.to_not change(resource_class, :count)
        end
      end
    end
  end
end

