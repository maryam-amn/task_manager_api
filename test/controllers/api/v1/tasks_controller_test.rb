# frozen_string_literal: true

require "test_helper"
class Api::V1::TasksControllerTest < ActionDispatch::IntegrationTest
  test "Should get all tasks" do
    get api_v1_tasks_url

    assert_response :success
    assert_match(/json/, response.header["Content-Type"])

    task = tasks(:blood_test)
    tasks_to_json = TaskJson.new(task:).to_h

    assert_includes response.parsed_body["tasks"], tasks_to_json.as_json
    assert_equal Task.count, response.parsed_body["tasks"].count
  end

  test "Should render a task if we can find the task's ID" do
    task = tasks(:blood_test)

    get api_v1_task_url(task.id)

    assert_response :success

    expected_response = TaskJson.new(task:).to_h

    assert_equal expected_response.as_json, response.parsed_body
  end

  test "Should render an error message if we cannot find the task's ID" do
    get api_v1_task_url(id: 0)

    assert_response :not_found

    expected_error_message = I18n.t("task.api.status.not_found")

    assert_equal expected_error_message, response.parsed_body[:error]
  end

  test "Should be able to delete a task" do
    task = tasks(:blood_test)

    assert_difference -> { Task.count } => -1 do
      delete api_v1_task_url(id: task.id)
    end

    assert_response :ok

    assert_equal I18n.t("task.api.status.successfully_destroyed"), response.parsed_body[:message]
  end

  test "Should render an error message if we try to delete a nonexistent task" do
    assert_difference -> { Task.count } => 0 do
      delete api_v1_task_url(id: 0)
    end

    assert_response :not_found
    expected_error_message = I18n.t("task.api.status.not_found")

    assert_equal expected_error_message, response.parsed_body[:error]
  end
end
