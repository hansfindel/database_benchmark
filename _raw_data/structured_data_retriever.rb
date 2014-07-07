class StructuredDataRetriever
    def self.factory
        data_retrievers = []
        files = Dir["../_raw_data/random_web_markup/*_markup"]
        files.each do |file_name|
            data_retrievers << StructuredDataRetriever.new(to_utf8(file_name))
        end
        data_retrievers
    end

    @name = ""
    def getName
        @name
    end
    def void 
        ""
    end
    private 
    def initialize name
        @name = name
    end    

    def self.to_utf8 text
        if text.respond_to?(:encoding)
            text.force_encoding("ISO-8859-1").encode("UTF-8")
        else
            text
        end
    end
end