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
end
