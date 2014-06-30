class ThreadManager

    ### run multiple threads without care the implementation 
    ### fun with some metaprogramming and ruby magic
    ## example: 
    # tn = ThreadManager.new; 
    # tn.config_for_text(4, RawDataProvider, :web_markup) do |x|;  puts "**#{x.size}**"; end
    def config_for_text(number, object_class, target_method)
        list = []
        _list = []
        number.times do |i|
            _list << Thread.new do |t|
                text = object_class.new.send(target_method)
                list << Thread.new { yield(text) }
            end
        end
        _list.each do |t|
            t.join
        end
        list.each do |t|
            t.join
        end
        return nil
    end

end