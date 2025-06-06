# frozen_string_literal: true

class SearchFormBuilder < SimpleForm::FormBuilder
  def input(attribute_name, options = {}, &)
    # # Handle inline_with option for boolean toggles
    # inline_with = options.delete(:inline_with)
    # if inline_with
    #   @inline_booleans ||= {}
    #   @inline_booleans[inline_with] ||= []
    #   @inline_booleans[inline_with] << [attribute_name, options.dup]
    #   return "" # Don't render now; will be rendered with the referenced input
    # end

    # # If this input has an inline boolean(s) attached, render them together
    # if @inline_booleans && @inline_booleans[attribute_name]
    #   main_input = super(attribute_name, options, &block)
    #   inline_booleans = @inline_booleans[attribute_name].map do |(bool_attr, bool_opts)|
    #     super(bool_attr, bool_opts.merge(label: false))
    #   end.join.html_safe
    #   return @template.content_tag(:span, main_input + inline_booleans, class: "inline-inputs")
    # end
  if attribute_name.to_sym == :order
    order_input = super(attribute_name, options)
    direction_input = super(:direction, { as: :boolean, label: "Reverse?", input_html: { value: "desc" } })
    return order_input + direction_input
  end

    # # Default behavior
    value = value_for_attribute(attribute_name, options)
    return "".html_safe if value.nil? && options[:hide_unless_value]
    options = insert_autocomplete(options)
    options = insert_value(value, options)
    super
  end

  def user(user_attribute, **args)
    name_attribute = user_attribute.is_a?(Symbol) ? :"#{user_attribute}_name" : user_attribute[0]
    id_attribute = user_attribute.is_a?(Symbol) ? :"#{user_attribute}_id" : user_attribute[1]
    label = args[:label] || user_attribute.capitalize

    name_input = input(name_attribute, { **args.deep_dup, label: label, autocomplete: "user" })
    id_input = input(id_attribute, { **args, label: "#{label} ID", hide_unless_value: true })
    name_input + id_input
  end

  private

  def insert_value(value, options)
    return options if value.nil?

    if options[:collection]
      options[:selected] = value
    elsif options[:as]&.to_sym == :boolean
      options[:input_html][:checked] = true if value.truthy?
    else
      options[:input_html][:value] = value
    end
    options
  end

  def value_for_attribute(attribute_name, options)
    @options[:search_params][attribute_name] || options[:default]&.to_s
  end

  include FormBuilderCommon
end
