module FeatureRaceHelpers
  extend ActiveSupport::Concern
  included do
    before do |ex|
      if ex.metadata[:raceable]
        has_css?("h1#welcome-title")
      end
    end
  end
end
