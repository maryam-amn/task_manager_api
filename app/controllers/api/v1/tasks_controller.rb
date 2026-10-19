class Api::V1::TasksController < ApiController
  before_action :find_task, only: [ :show, :destroy ]

  def index
    task_to_json = Task.includes(:user).map do |task|
      TaskJson.new(task:).to_h
    end
    render json: { tasks: task_to_json }
  end

  def show
    render json: TaskJson.new(task: @task).to_h
  end

  def destroy
    @task.destroy
    render status: :ok, json: { message: I18n.t("task.api.status.successfully_destroyed") }
  end

  private
  def find_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
   render status: :not_found, json: { error: I18n.t("task.api.status.not_found"), details: { field: [ e ] } }
  end
end
