# frozen_string_literal: true

module Nokogiri
  module HTML4
    class DocumentFragment < Nokogiri::XML::DocumentFragment
      ####
      # Create a Nokogiri::XML::DocumentFragment from +tags+, using +encoding+
      def self.parse(tags, encoding = nil)
        doc = HTML4::Document.new

        encoding ||= if tags.respond_to?(:encoding)
          encoding = tags.encoding
          if encoding == ::Encoding::ASCII_8BIT
            "UTF-8"
          else
            encoding.name
          end
        else
          "UTF-8"
        end

        doc.encoding = encoding

        new(doc, tags)
      end

      def initialize(document, tags = nil, ctx = nil)
        return self unless tags

        if ctx
          preexisting_errors = document.errors.dup
          node_set = ctx.parse("<div>#{tags}</div>")
          node_set.first.children.each { |child| child.parent = self } unless node_set.empty?
          self.errors = document.errors - preexisting_errors
        else
          # This is a horrible hack, but I don't care
          path = if /^\s*?<body/i.match?(tags)
            "/html/body"
          else
            "/html/body/node()"
          end

          temp_doc = HTML4::Document.parse("<html><body>#{tags}", nil, document.encoding)
          temp_doc.xpath(path).each { |child| child.parent = self }
          self.errors = temp_doc.errors
        end
        children
      end
    end
  end
end
