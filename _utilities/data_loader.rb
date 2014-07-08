class DataLoader

    def self.relational_factory(magnitud_order = 1)
        # for cassandra and for pg
        self.default_factory(magnitud_order)
    end
    def self.relational_document_factory(magnitud_order = 1)
        data = self.default_factory(magnitud_order)
        
        users = []
        data[:users].each do |user_data|
            users << { id: user_data[0], first_name: user_data[1], last_name: user_data[2], email: user_data[3], password_hash: user_data[4], password_salt: user_data[5], active: user_data[6], deleted: user_data[7] }
        end
        projects = []
        data[:projects].each do |project_data|
            projects << { id: project_data[0], name: project_data[1], description: project_data[2], created_by: project_data[3], active: project_data[4] }
        end
        project_users = []
        data[:project_users].each do |project_user_data|
            project_users << { id: project_user_data[0], user_id: project_user_data[1], project_id: project_user_data[2], admin: project_user_data[3] }
        end
        tasks = []
        data[:tasks].each do |task_data|
            tasks << { id: task_data[0], name: task_data[1], description: task_data[2], difficulty: task_data[3], created_by: task_data[4], assigned_to: task_data[5], column_id: task_data[6], completed_at: task_data[7], column_id: task_data[8], priority: task_data[9], seconds_worked: task_data[10] } 
        end
        columns = []
        data[:columns].each do |column_data|
            columns << { id: column_data[0], name: column_data[1], description: column_data[2], color: column_data[3], order: column_data[4], project_id: column_data[5] }
        end
        {
            users: users,
            projects: projects,
            project_users: project_users,
            tasks: tasks,
            columns: columns
        }
    end

    def self.nested_document_factory(magnitud_order = 1)
        data = self.default_factory(magnitud_order)                
        users = []
        data[:users].each do |user_data|
            user = { id: user_data[0], first_name: user_data[1], last_name: user_data[2], email: user_data[3], password_hash: user_data[4], password_salt: user_data[5], active: user_data[6], deleted: user_data[7] }
            project_array = []
            data[:project_users].each do |project_data|
                project_array << project_data[2].to_i if project_data[1].to_i == user[:id].to_i # add id to user if has matches with its id
            end
            user[:project_ids] = project_array
            users << user
        end

        projects = []
        data[:projects].each do |project_data|
            project = { id: project_data[0], name: project_data[1], description: project_data[2], created_by: project_data[3], active: project_data[4] }
            project_users_array = []
            data[:project_users].each do |project_user_data|
                project_users_array << project_user_data[1].to_i if project_user_data[2].to_i == project[:id].to_i
            end    
            project[:user_ids] = project_users_array
            columns = []
            data[:columns].each do |column_data|
                column = { id: column_data[0], name: column_data[1], description: column_data[2], color: column_data[3], order: column_data[4], project_id: column_data[5] }
                if column[:project_id] = project[:id]
                    tasks = []
                    data[:tasks].each do |task_data|
                        task = { id: task_data[0], name: task_data[1], description: task_data[2], difficulty: task_data[3], created_by: task_data[4], assigned_to: task_data[5], column_id: task_data[6], completed_at: task_data[7], column_id: task_data[8], priority: task_data[9], seconds_worked: task_data[10] } 
                        tasks << task if task[:column_id] == column[:id]
                    end
                    column[:tasks] = tasks
                    columns << column
                end
            end
            project[:columns] = columns
            projects << project
        end
        
        { users: users, projects: projects } # return value
    end

    def self.default_factory(magnitud_order = 1)
        # default_values = [1000, 200, 1000, 800, 2000] 
        # default_names  = [:get_users, :get_projects, :get_project_users, :get_columns, :get_tasks]
        # output = []
        # 5.times do |i|
        #     output << self.send(default_names[i], magnitud_order * default_values)
        # end
        # output
        {
            users: self.get_users(magnitud_order * 1000), 
            projects: self.get_projects(magnitud_order * 200), 
            project_users: self.get_project_users(magnitud_order * 1000), 
            columns: self.get_columns(magnitud_order * 800), 
            tasks: self.get_tasks(magnitud_order * 2000)
        }
    end

    #private (pseudo-private)
    # Users
    def self.get_users(num = 1000)
        arr = []
        num.to_i.times do |i|
            arr <<  [i,"first_name "+i.to_s,"last_name","email@email.com","qwertyuiopasdfghjklzxcvbnm","qwertyuiopasdfghjklzxcvbnm", i%2==0||i%3==0, i%31==0]
        end
        return arr.shuffle
    end

    # Projects
    def self.get_projects(num = 200)
        arr = []
        num.to_i.times do |i|
            arr <<[i, "Project#{i}", "Lorem ipsum dolor sit amet" ,i*5 ,true]
        end
        return arr.shuffle
    end

    # ProjectUsers
    def self.get_project_users(num = 1000)
        arr = []
        num.to_i.times do |i|
            arr << [i,i,(i.to_f/5.0).ceil,i%100==0]
        end
        return arr.shuffle
    end

    # Columns
    def self.get_columns(num = 800)
        arr = []
        num.to_i.times do |i|
            arr << [i,"Lorem ipsum dolor sit amet","#FAFAFA",i%5,(i.to_f/4.0).floor]
        end
        return arr.shuffle
    end

    # Tasks
    def self.get_tasks(num = 2000)
        arr = []
        hours_worked = [0.5,1,2,3,4]
        num.to_i.times do |i|
            arr << [i,'task_name '+i.to_s,"Lorem ipsum dolor sit amet",i%3,i/2,i/2,i*4/10,Time.now.to_i,hours_worked.sample.to_i,(hours_worked.sample*60*60).to_i]
        end
        return arr.shuffle
    end

end
