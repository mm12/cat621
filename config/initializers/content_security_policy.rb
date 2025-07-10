# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    policy.script_src  :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    policy.style_src   :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    policy.connect_src :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    policy.object_src  :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    policy.media_src   :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    policy.frame_ancestors :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    policy.frame_src   :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    policy.font_src    :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    policy.img_src     :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    policy.child_src   :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    policy.form_action :self, :unsafe_inline, :unsafe_eval, '*', :data, :blob
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w(script-src)
  config.content_security_policy_report_only = false
end
