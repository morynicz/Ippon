require 'rails_helper'

RSpec.describe Point, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "value" do
    context "point type is men" do
      let(:point) { FactoryGirl::create(:point, type: :men)}
      it "returns a hit value" do
        expect(point.value).to eq(Point::HIT_VALUE)
      end
    end

    context "point type is kote" do
      let(:point) { FactoryGirl::create(:point, type: :kote)}
      it "returns a hit value" do
        expect(point.value).to eq(Point::HIT_VALUE)
      end
    end

    context "point type is do" do
      let(:point) { FactoryGirl::create(:point, type: :do)}
      it "returns a hit value" do
        expect(point.value).to eq(Point::HIT_VALUE)
      end
    end

    context "point type is tsuki" do
      let(:point) { FactoryGirl::create(:point, type: :tsuki)}
      it "returns a hit value" do
        expect(point.value).to eq(Point::HIT_VALUE)
      end
    end

    context "point type is hansoku" do
      let(:point) { FactoryGirl::create(:point, type: :hansoku)}
      it "returns a hit value" do
        expect(point.value).to eq(Point::HANSOKU_VALUE)
      end
    end
  end
end
