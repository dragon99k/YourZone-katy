module EnumHelper

  def options_for_enum(object, enum)
    options = enums_to_translated_options(object.class.name, enum.to_s)
    options_for_select(options, object.send(enum))
  end

  def enums_to_translated_options(klass, enum)
    klass.classify.safe_constantize.send(enum.pluralize).map do |key, value|
      [I18n.t("activerecord.attributes.#{klass.underscore}.#{enum.to_s.pluralize}.#{key}"), key]
    end
  end

end