# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'when persisted' do
    subject { create(:article, author: create(:author)) }

    it { expect(subject.slug).to be_a(String) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:author).class_name('User').validate }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:favorites).dependent(:destroy) }
    it { is_expected.to have_many(:taggings).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:taggings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'columns' do
    it { is_expected.to have_db_column(:slug).with_options(null: false) }
    it { is_expected.to have_db_column(:title).with_options(null: false) }
    it { is_expected.to have_db_column(:description).with_options(null: false) }
    it { is_expected.to have_db_column(:body).with_options(null: false) }
    it { is_expected.to have_db_column(:favorites_count).with_options(default: 0, null: false) }
    it { is_expected.to have_db_column(:author_id).with_options(null: false) }
    it { is_expected.to have_db_column(:created_at).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).with_options(null: false) }
    it { is_expected.to have_db_index(:author_id) }
    it { is_expected.to have_db_index(:slug).unique }
  end

  describe 'methods' do
    subject { described_class }

    it { expect(subject.tagged_with('test')).to be_a(ActiveRecord::Relation) }
    it { expect(subject.feed_for(User.new)).to be_a(ActiveRecord::Relation) }
  end

  describe 'favorites_count' do
    let(:user) { create(:user) }
    let(:article) { create(:article, author: build(:author)) }

    it 'will increase favorites_count when user favorites an article' do
      expect do
        Favorite.create!(user: user, article: article)
      end .to change { article.favorites_count }.by(1)
    end
  end
end
