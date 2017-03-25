shared_examples_for "tournament_showable" do
  describe "GET show" do
    subject(:results) {JSON.parse(response.body)}

    context "when the group fight exists" do
      let(:resource_id) {
        resource.id
      }

      it "should return 200 status" do
        action
        expect(response.status).to eq(200)
      end

      it "should return result with correct resource" do
        action
        expect_result_with_correct_resource(results, resource)
      end

      context "when the user is not an admin" do
        it "should return admin status false" do
          action
          expect(results["is_admin"]).to be false
        end
      end

      context "when the user is authenticated", authenticated: true do
        context "when the user is an admin" do
          it "should return admin status true" do
            authorize_user(tournament.id)
            action
            expect(results["is_admin"]).to be true
          end
        end
      end
    end

    context "when the group fight doesn't exist" do
      let(:resource_id) {-9999}
      it "should respond with 404 status" do
        action
        expect(response.status).to eq(404)
      end
    end
  end
end