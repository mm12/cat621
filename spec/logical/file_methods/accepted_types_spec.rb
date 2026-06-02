# frozen_string_literal: true

require "rails_helper"

# --------------------------------------------------------------------------- #
#                   FileMethods — accepted types                              #
# --------------------------------------------------------------------------- #
#
# Covers:
#   - accepted_mime_types
#   - accepted_file_types
#
RSpec.describe FileMethods do
  let(:host_class) do
    Class.new do
      include FileMethods
    end
  end

  let(:host) { host_class.new }

  # ----------------------------------------------------------------------- #
  describe "#accepted_mime_types" do
    it "includes image and video mimes by default and excludes flash" do
      mimes = host.accepted_mime_types
      expect(mimes).to include(
        "image/png",
        "image/jpeg",
        "image/gif",
        "image/webp",
        "image/avif",
        "video/webm",
        "video/mp4",
      )
      expect(mimes).not_to include("application/x-shockwave-flash")
    end

    it "includes flash when allow_flash is true" do
      mimes = host.accepted_mime_types(allow_flash: true)
      expect(mimes).to include("application/x-shockwave-flash")
    end

    it "can restrict to only images" do
      mimes = host.accepted_mime_types(allow_videos: false)
      expect(mimes.none? { |m| m.start_with?("video/") }).to be true
    end

    it "can restrict to only videos" do
      mimes = host.accepted_mime_types(allow_images: false)
      expect(mimes.none? { |m| m.start_with?("image/") }).to be true
    end
  end

  # ----------------------------------------------------------------------- #
  describe "#accepted_file_types" do
    it "returns extensions by default" do
      types = host.accepted_file_types
      expect(types).to include(
        ".png",
        ".jpeg",
        ".gif",
        ".webp",
        ".avif",
        ".webm",
        ".mp4",
      )
      expect(types).not_to include(".swf")
    end

    it "returns mimes when include_mimes is true and include_extensions false" do
      types = host.accepted_file_types(include_mimes: true, include_extensions: false)
      expect(types).to include(
        "image/png",
        "image/jpeg",
        "image/gif",
        "image/webp",
        "image/avif",
        "video/webm",
        "video/mp4",
      )
    end

    it "returns both mimes and extensions when include_mimes and include_extensions are true" do
      types = host.accepted_file_types(include_mimes: true, include_extensions: true, allow_flash: true)
      expect(types).to include("image/png", ".png", "application/x-shockwave-flash", ".swf")
    end
  end
end
