require 'rails_helper'

RSpec.describe StatusController, type: :controller do
  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    context 'when no StatusItems exist' do
      before { get :index }
      it { expect(assigns[:current_status]).to be_nil }
      it { expect(assigns[:previous_statuses]).to be_empty }
    end

    context 'when one StatusItem exists' do
      let!(:status_item) { StatusItem.create }
      before { get :index }

      it { expect(assigns[:current_status]).to eq(status_item) }
      it { expect(assigns[:previous_statuses]).to be_empty }
    end

    context 'when many StatusItem exists' do
      let!(:status_last_week) { StatusItem.create updated_at: 1.week.ago}
      let!(:status_last_month) { StatusItem.create updated_at: 1.month.ago }
      let!(:status_today) { StatusItem.create updated_at: Time.now }
      let!(:status_yesterday) { StatusItem.create updated_at: Date.yesterday }

      it 'the most recently updated is the current_status' do
        get :index
        expect(assigns[:current_status]).to eq(status_today)
      end

      it 'all other status_items are ordered by most recently updated' do
        get :index
        expect(assigns[:previous_statuses]).to eq([status_yesterday, status_last_week, status_last_month])
      end

      context "checking the boundary around the '10' previous items" do
        context 'when there are 10 status items' do
          before do
            number_of_items_to_create = 10 - StatusItem.count
            number_of_items_to_create.times{ StatusItem.create updated_at: 1.year.ago }
            get :index
          end

          it 'the most recently updated is the current_status' do
            expect(assigns[:current_status]).to eq(status_today)
          end

          it 'all other status_items are ordered by most recently updated' do
            get :index
            expect(assigns[:previous_statuses].length).to eq(9)
          end
        end

        context 'when there are 11 status items' do
          before do
            number_of_items_to_create = 11 - StatusItem.count
            number_of_items_to_create.times{ StatusItem.create updated_at: 1.year.ago }
            get :index
          end

          it 'the most recently updated is the current_status' do
            expect(assigns[:current_status]).to eq(status_today)
          end

          it 'all other status_items are ordered by most recently updated' do
            get :index
            expect(assigns[:previous_statuses].length).to eq(10)
          end
        end

        context 'when there are 12 status items' do
          before do
            number_of_items_to_create = 12 - StatusItem.count
            number_of_items_to_create.times{ StatusItem.create updated_at: 1.year.ago }
            get :index
          end

          it 'the most recently updated is the current_status' do
            expect(assigns[:current_status]).to eq(status_today)
          end

          it 'only provide 10 previous_statuses' do
            get :index
            expect(assigns[:previous_statuses].length).to eq(10)
          end
        end
      end
    end
  end
end
