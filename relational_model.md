##Scenario 1 - HTML Cache

###CachedPage

*	name:string
*	html_body:text



##Scenario 2 - Project Management System

###User

*	first_name:string
*	last_name:string
*	email:string
*	password_hash:string
*	password_salt:string
*	active:boolean
*	deleted:boolean

###Project

*	name:sting
*	description:text
*	created_by:integer
*	active:boolean

###UserProject

*	user_id:integer
*	project_id:integer
*	admin:boolean

###Column

*	name:string
*	description:text
*	color:string
*	order:integer
*	project_id:integer

###Task

*	name:string
*	description:text
*	difficulty:integer
*	created_by:integer
*	assigned_to:integer
*	column_id:integer
*	completed_at:datetime
*	priority:float
*	seconds_worked:integer



##Scenario 3 - Find tasks by user

*Identical*


##Scenario 4 - Average worked time per task

*Identical*