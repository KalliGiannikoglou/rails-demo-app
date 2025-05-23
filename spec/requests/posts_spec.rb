require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe 'GET / (public)' do
    let!(:post) { create(:post, status: :published)}
    let!(:post_draft) { create(:post)}

    it "assigns published posts" do
      get '/'
      expect(assigns(:posts)).to match_array([post])
    end
  end

  describe 'GET /post/1 (public)' do
    context 'with Important sections' do
      let(:post) do
        create(:post,
          sections: [
            create(:section),
            create(:section, :important)
          ]
        )
      end

      it "shows important sections first" do
        get post_path(post)
        expect(assigns(:post).sorted_sections.first).to be_a Section::Important
      end
    end
  end

  context 'User authorized' do
    include_context 'logged in user'

    describe "GET /index" do
      it "returns a success response" do
        get '/posts'
        expect(response).to have_http_status(:ok)
      end

      context 'when draft post' do
        let!(:post) { create(:post, user: current_user) }

        it 'assigns draft posts' do
          get '/posts'
          expect(assigns(:posts)).to match_array([post])
        end
      end

      context 'when published post' do
        let!(:post) { create(:post, status: :published, user: current_user) }

        it 'assigns published posts' do
          get '/posts'
          expect(assigns(:posts)).to match_array([post])
        end
      end

      context 'when other users post' do
        let(:user) { create(:user) }

        let!(:post) { create(:post, status: :draft, user: user) } # from ruby version 3.1+ user can be ommited

        it 'assigns no posts' do
          get '/posts'
          expect(assigns(:posts)).not_to include post
        end
      end
    end

    describe "POST /posts" do
      let(:post_params) do
        {
          post: {
            title: 'Ok',
            content: 'Alright',
            sections_attributes: [
              content: 'Test section',
              type: 'Section::Important'
            ]
          }
        }
      end

      let(:sections) { current_user.posts.first.sections }

      it "returns a success response" do
        post '/posts', params: post_params
        expect(response).to have_http_status(:found)
      end

      it "creates a new post with 1 section" do
        post '/posts', params: post_params
        expect(sections.count).to eq(1)
      end
    end

    describe 'GET /posts/1' do
      context 'when other users post not published' do
        let(:post) { create(:post) }

        it 'does not show the post' do
          get post_path(post)
          expect(response).to have_http_status(:redirect)
        end
      end
    end
  end
end
