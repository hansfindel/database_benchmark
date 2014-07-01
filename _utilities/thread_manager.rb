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


    def map(number, object_instances, method_attribute, method_value)
        list = []
        object_instances.each do |instance|
            number.times do |i|
                object_attribute = sanitize_text(instance.send(method_attribute) + "-#{i}")
                list << Thread.new do |t|
                    object_value = instance.send(method_value)
                    list << Thread.new { yield(object_attribute, object_value) }
                end
            end
        end
        list.each do |t|
            t.join
        end
        return nil
    end

    private 
    def sanitize_text(text)
         text[text.rindex("/")+1..-1]
    end
end