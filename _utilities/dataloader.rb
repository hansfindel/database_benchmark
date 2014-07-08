class DataLoader

    # Users
    def self.get_users(num = 1000)
        arr = []
        num.times do |i|
            arr <<  [i,"first_name "+i.to_s,"last_name","email@email.com","qwertyuiopasdfghjklzxcvbnm","qwertyuiopasdfghjklzxcvbnm"]
        end
        return arr.shuffle
    end

    # Projects
    def self.get_projects(num = 200)
        arr = []
        num.times do |i|
            arr <<[i,"Lorem ipsum dolor sit amet",i*5,true]
        end
        return arr.shuffle
    end

    # ProjectUsers
    def self.get_project_users(num = 1000)
        arr = []
        num.times do |i|
            arr << [i,(i.to_f/5.0).ceil,i%100==0]
        end
        return arr.shuffle
    end

    # Columns
    def self.get_columns(num = 800)
        arr = []
        num.times do |i|
            arr << [i,"Lorem ipsum dolor sit amet","#FAFAFA",i%5,(i.to_f/4.0).floor]
        end
        return arr.shuffle
    end

    # Tasks
    def self.get_tasks(num = 2000)
        arr = []
        hours_worked = [0.5,1,2,3,4]
        num.times do |i|
            arr << [i,'task_name '+i.to_s,"Lorem ipsum dolor sit amet",i%3,i/2,i/2,i*4/10,Time.now.to_i,hours_worked.sample.to_i,(hours_worked.sample*60*60).to_i]
        end
        return arr.shuffle
    end

end




