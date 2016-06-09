module FeatureRaceHelpers
  extend ActiveSupport::Concern
  included do
    before do |ex|
      if ex.metadata[:raceable]
        has_css?("h1#welcome-title")
        if has_css?("h1#welcome-title")
          puts "has"
        else
          puts "hasn't"
        end
      end
    end
  end
end
