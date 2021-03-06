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
      let!(:status_item) { create_status_item }
      before { get :index }

      it { expect(assigns[:current_status]).to eq(status_item) }
      it { expect(assigns[:previous_statuses]).to be_empty }
    end

    context 'when many StatusItem exists' do
      let!(:status_last_week) { create_status_item updated_at: 1.week.ago}
      let!(:status_last_month) { create_status_item updated_at: 1.month.ago }
      let!(:status_today) { create_status_item updated_at: Time.now }
      let!(:status_yesterday) { create_status_item updated_at: Date.yesterday }

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
            number_of_items_to_create.times{ create_status_item updated_at: 1.year.ago }
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
            number_of_items_to_create.times{ create_status_item updated_at: 1.year.ago }
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
            number_of_items_to_create.times{ create_status_item updated_at: 1.year.ago }
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

  describe 'POST create' do
    context 'without authentication' do
      it 'raises exception' do
        post :create, format: :json, state: 'UP', message: 'All working'
        expect(response.code).to eq('401')
        expect(response.message).to eq('Unauthorized')
      end
    end

    context 'authenticated' do
      before { authenticate }

      context 'successful request' do
        it 'stores a new status item' do
          post :create, format: :json, state: 'UP', message: 'All working'
          expect(StatusItem.count).to eq(1)
          expect(StatusItem.first.state).to eq('UP')
          expect(StatusItem.first.message).to eq('All working')
        end

        it 'provides a status_item in the json response' do
          post :create, format: :json, state: 'UP', message: 'All working'
          json = JSON.parse response.body
          expect(json["status_item"]['id']).to eq(StatusItem.first.id)
          expect(json["status_item"]['state']).to eq('UP')
          expect(json["status_item"]['message']).to eq('All working')
        end

        it 'gives a successful response' do
          post :create, format: :json, state: 'UP', message: 'All working'
          json = JSON.parse response.body
          expect(json['status']).to eq(200)
        end
      end

      context 'unsuccessful request' do
        it 'gives a 500 and errors' do
          post :create, format: :json, state: 'something else', message: nil
          json = JSON.parse response.body
          expect(json['status']).to eq(500)

          expected_errors = [
            "State needs to be UP or DOWN",
            "Message can't be blank"
          ]
          expect(json['errors']).to eq(expected_errors)
        end
      end
    end
  end

  describe 'PUT update' do
    let(:status_item) { create_status_item state: 'UP', message: 'All working' }

    context 'without authentication' do
      it 'raises exception' do
        put :update, format: :json, id: status_item.id, state: 'DOWN'
        expect(response.code).to eq('401')
        expect(response.message).to eq('Unauthorized')
      end
    end

    context 'authenticated' do
      before { authenticate }

      context 'successful request' do
        it 'updates state' do
          put :update, format: :json, id: status_item.id, state: 'DOWN'

          status_item.reload
          expect(status_item.state).to eq('DOWN')
        end

        it 'updates message' do
          put :update, format: :json, id: status_item.id, message: 'All good!'

          status_item.reload
          expect(status_item.message).to eq('All good!')
        end

        it 'updates both state and message' do
          put :update, format: :json, id: status_item.id, state: 'DOWN', message: 'All good!'

          status_item.reload
          expect(status_item.state).to eq('DOWN')
          expect(status_item.message).to eq('All good!')
        end

        it 'gives a successful response' do
          put :update, format: :json, id: status_item.id, message: 'All good!'
          json = JSON.parse response.body
          expect(json['status']).to eq(200)
        end

        it 'provides a status_item in the json response' do
          put :update, format: :json, id: status_item.id, state: 'DOWN', message: 'Struggling!'
          json = JSON.parse response.body
          expect(json["status_item"]['id']).to eq(status_item.id)
          expect(json["status_item"]['state']).to eq('DOWN')
          expect(json["status_item"]['message']).to eq('Struggling!')
        end
      end

      context 'unsuccessful request' do
        it 'gives a 500 and errors' do
          put :update, format: :json, id: status_item.id, message: nil, state: 'something else'
          json = JSON.parse response.body
          expect(json['status']).to eq(500)

          expected_errors = [
            "State needs to be UP or DOWN",
            "Message can't be blank"
          ]
          expect(json['errors']).to eq(expected_errors)
        end
      end
    end
  end

  def authenticate
    username = Rails.application.secrets.auth_username
    password = Rails.application.secrets.auth_password
    @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  end
end
