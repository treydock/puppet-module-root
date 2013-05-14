require 'puppetlabs_spec_helper/module_spec_helper'

class String
  def camelize(term, uppercase_first_letter = true)
    string = term.to_s
    if uppercase_first_letter
      string = string.sub(/^[a-z\d]*/) { inflections.acronyms[$&] || $&.capitalize }
    else
      string = string.sub(/^(?:#{inflections.acronym_regex}(?=\b|[A-Z_])|\w)/) { $&.downcase }
    end
    string.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{inflections.acronyms[$2] || $2.capitalize}" }.gsub('/', '::')
  end
end