require 'rexml/document'

module Pinboard
  module XMLParser
    module_function

    def parse(xml_string)
      doc = REXML::Document.new(xml_string)
      {doc.root.name => convert_element(doc.root)}
    end

    def convert_element(element)
      result = {}

      element.attributes.each { |name, value| result[name] = value }

      children = {}
      element.each_element do |child|
        (children[child.name] ||= []) << child
      end

      children.each do |name, elements|
        if elements.size == 1
          result[name] = convert_element(elements.first)
        else
          result[name] = elements.map { |e| convert_element(e) }
        end
      end

      text = element.texts.map(&:value).join.strip

      if result.empty?
        return text.empty? ? nil : text
      elsif !text.empty?
        result['__content__'] = text
      end

      result
    end
  end
end
