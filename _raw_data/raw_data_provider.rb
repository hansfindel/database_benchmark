class RawDataProvider

    def web_markup
        files = Dir["../_raw_data/random_web_markup/*_markup"]
        text = ""
        # read random markup file
        File.open(files[rand(files.length)], "r") do |infile|
            while (line = infile.gets)
                text += line
            end
        end
        text
    end

end