class ThreadManager

    ### run multiple threads without care the implementation 
    ### fun with some metaprogramming and ruby magic
    ## example: tn.config_for_text(4, RawDataProvider, :web_markup) do |x|;  puts "**#{x.size}**"; end
    def config_for_text(number, object_class, target_method)
        list = []
        number.times do |i|
            text = object_class.new.send(target_method)
            list << Thread.new { yield(text) }
        end
        list
    end

end