class TestRunner

    ### run multiple times the same script/function/thing

    def run(script_name="scripts")
        experiment_count = 10   # number of experiments == number of elements in time_array
        time_array = []   # tasks duration -> for posterior analisys

        experiment_count.times do |time|
            start_time = Time.now 
            yield 
            end_time = Time.now
            task_duration = end_time - start_time
            time_array << task_duration
            puts "It took #{task_duration} to excecute #{script_name}"
        end
        puts time_array.join(";")
        print_usefull_data(time_array)
    end

    def print_usefull_data(array)
        puts "Average: #{average(array)}"
        puts "Median: #{median(array)}"
    end

    def median(array)
        sorted = array.sort
        len = sorted.length
        return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
    end

    def average(array)
        return array.reduce(:+).to_f / array.size
    end

end