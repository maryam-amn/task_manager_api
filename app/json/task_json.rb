class TaskJson
  def initialize(task:)
    @task = task
  end

  def to_h
    {
      id: @task.id,
      created_by: @task.username,
      title: @task.title,
      description: @task.description,
      status: @task.status
    }
  end
end
