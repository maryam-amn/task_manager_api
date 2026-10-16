class Api::V1::TasksController < ApiController
  def index
    task_to_json = Task.all.map do |task|
      TaskJson.new(task:).to_h
    end
    render json: { tasks: task_to_json }
  end
end
