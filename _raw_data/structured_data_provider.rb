class StructuredDataProvider
    def self.factory
        data_providers = []
        files = Dir["../_raw_data/random_web_markup/*_markup"]
        files.each do |file_name|
            text = ""    
            File.open(file_name, "r") do |infile|
                while (line = infile.gets)
                    text += line
                end
            end
            data_providers << StructuredDataProvider.new(file_name, text)
        end
        data_providers
    end
    
    @text = ""
    @name = ""
    def getHTML
        @text
    end
    def getName
        @name
    end
    private 
    def initialize name, text
        @name = name
        @text = text
    end    

end