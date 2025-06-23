# frozen_string_literal: true

class UserVote < ApplicationRecord
  class Error < Exception; end

  self.abstract_class = true

  belongs_to :user
  validates :score, inclusion: { in: [-1, 0, 1], message: "must be 1 or -1" }
  after_initialize :initialize_attributes, if: :new_record?
  scope :for_user, ->(uid) { where("user_id = ?", uid) }

  def self.inherited(child_class)
    super
    child_class.class_eval do
      belongs_to model_type
    end
  end

  # PostVote => :post
  def self.model_type
    model_name.singular.delete_suffix("_vote").to_sym
  end

  def initialize_attributes
    self.user_id ||= CurrentUser.user.id
    self.user_ip_addr ||= CurrentUser.ip_addr
  end

  def is_positive?
    score == 1
  end

  def is_negative?
    score == -1
  end

  def is_locked?
    score == 0
  end

  module SearchMethods
    def search(params)
      q = super

      if params["#{model_type}_id"].present?
        q = q.where("#{model_type}_id" => params["#{model_type}_id"].split(",").first(100))
      end

      q = q.where_user(:user_id, :user, params)

      allow_complex_params = (params.keys & ["#{model_type}_id", "user_name", "user_id"]).any?

      if allow_complex_params
        q = q.where_user({ model_type => :"#{model_creator_column}_id" }, :"#{model_type}_creator", params) do |q, _user_ids|
          q.joins(model_type)
        end

        if params[:timeframe].present?
          q = q.where("#{table_name}.updated_at >= ?", params[:timeframe].to_i.days.ago)
        end

        if params[:user_ip_addr].present?
          q = q.where("user_ip_addr <<= ?", params[:user_ip_addr])
        end

        if params[:score_type].present?
          q = q.where("#{table_name}.score = ?", params[:score])
        end

        if params[:score].present?
          q = score_search_helper(q, params[:score], "score")
        end

        if params[:downvotes].present?
          q = score_search_helper(q, params[:downvotes], "down_score")
        end

        if params[:upvotes].present?
          q = score_search_helper(q, params[:upvotes], "up_score")
        end

        if params[:duplicates_only].to_s.truthy?
          subselect = search(params.except("duplicates_only")).select(:user_ip_addr).group(:user_ip_addr).having("count(user_ip_addr) > 1").reorder("")
          q = q.where(user_ip_addr: subselect)
        end
      end

      if params[:order] == "ip_addr" && allow_complex_params
        q = q.order(:user_ip_addr)
      else
        q = q.apply_basic_order(params)
      end
      q
    end
    def score_search_helper(q, score_string, range_type)
      # handle numbers ('a'), ranges ('a..b'), and comparisons ('>a','<a',''>=a','<=a')
      # score_string is a string
      # we have the table `post_votes`, which contains a `post_id`. 
      # We need to look at `posts` table for the `score`, `upvotes`, and `downvotes`.
      return q unless score_string.present? && range_type.present?
      q = q.joins(:post) unless q.joins_values.include?(:post)
      
      if score_string =~ /\A-?\d+\z/
        # single number
        q = q.where("post.#{range_type} = ?", score_string.to_i)
      elsif score_string =~ /\A-?\d+\.\.-?\d+\z/
        # range 'a..b'
        a, b = score_string.split("..").map(&:to_i)
        q = q.where("posts.#{range_type} >= ? AND posts.#{range_type} <= ?", a, b)
      elsif score_string =~ /\A[<>=]?-?\d+\z/
        # comparison '>a', '<a', '>=a', '<=a'
        operator = score_string[0] # first character is the operator
        value = score_string[1..-1].to_i
        case operator
        when '>'
          q = q.where("posts.#{range_type} > ?", value)
        when '<'
          q = q.where("posts.#{range_type} < ?", value)
        when '='
          q = q.where("posts.#{range_type} = ?", value)
        when '>='
          q = q.where("posts.#{range_type} >= ?", value)
        when '<='
          q = q.where("posts.#{range_type} <= ?", value)
        end
      else
        # invalid format, return original query
        raise Error, "Invalid format for #{range_type}: #{score_string}"
      end
      q
    end
  end

  extend SearchMethods
end
