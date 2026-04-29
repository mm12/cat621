# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostReplacement do
  def uploaded_file(path, mime_type)
    Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files", path), mime_type)
  end

  describe "create-time callbacks" do
    let(:creator) { create(:user, created_at: 2.weeks.ago) }
    let(:post) { create(:post, uploader: create(:user, created_at: 2.weeks.ago)) }
    let(:storage_manager) { Danbooru.config.storage_manager }

    before do
      allow(Danbooru.config.custom_configuration).to receive(:storage_manager).and_return(storage_manager)
      allow(storage_manager).to receive(:open).and_return(uploaded_file("sample.jpg", "image/jpeg"))
      CurrentUser.user = creator
      CurrentUser.ip_addr = "127.0.0.1"
    end

    after do
      CurrentUser.user = nil
      CurrentUser.ip_addr = nil
    end

    it "creates an original backup when the first replacement is created" do
      replacement_file = uploaded_file("sample.png", "image/png")

      expect {
        post.replacements.create!(
          creator: creator,
          creator_ip_addr: "127.0.0.1",
          replacement_file: replacement_file,
          reason: "A sufficient replacement reason",
          is_backup: false,
        )
      }.to change { post.replacements.count }.by(2)

      statuses = post.replacements.reload.map(&:status)
      expect(statuses).to include("original", "pending")
    end

    it "raises when the post cannot be backed up" do
      allow(storage_manager).to receive(:open).and_raise(StandardError, "missing file")

      expect {
        post.replacements.create!(
          creator: creator,
          creator_ip_addr: "127.0.0.1",
          replacement_file: uploaded_file("sample.png", "image/png"),
          reason: "A sufficient replacement reason",
          is_backup: false,
        )
      }.to raise_error(ProcessingError, /Failed to create backup/)
    end

    it "creates a non-duplicate replacement submission" do
      replacement = post.replacements.create(
        creator: creator,
        creator_ip_addr: "127.0.0.1",
        replacement_file: uploaded_file("sample.png", "image/png"),
        reason: "A sufficient replacement reason",
        is_backup: false,
      )

      expect(replacement.errors).to be_empty
      expect(replacement.storage_id).to be_present
      expect(post.replacements.map(&:status).sort).to include("original", "pending")
      expect(Digest::MD5.file(Rails.root.join("spec/fixtures/files/sample.png"))).to eq(Digest::MD5.file(replacement.replacement_file_path))
    end

    it "populates the previous version uploader" do
      replacement = post.replacements.create(
        creator: creator,
        creator_ip_addr: "127.0.0.1",
        replacement_file: uploaded_file("sample.png", "image/png"),
        reason: "A sufficient replacement reason",
        is_backup: false,
      )

      expect(replacement.uploader_on_approve.id).to eq(post.uploader_id)
    end

    it "increments the user's pending replacement count" do
      expect {
        post.replacements.create(
          creator: creator,
          creator_ip_addr: "127.0.0.1",
          replacement_file: uploaded_file("sample.png", "image/png"),
          reason: "A sufficient replacement reason",
          is_backup: false,
        )
      }.to change { creator.post_replacements.pending.count }.by(1)
    end
  end
end