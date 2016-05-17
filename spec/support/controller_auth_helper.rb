module ControllerAuthHelpers
  extend ActiveSupport::Concern
  included do
    let(:current_user){FactoryGirl.create(:user)}
    before do |ex|
      sign_out :user
      if ex.metadata[:authenticated]
        sign_in current_user
      end
    end
  end
end
