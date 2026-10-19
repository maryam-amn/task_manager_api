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

  test "Should create a new task" do
    assert_difference -> { Task.count }, +1  do
    post api_v1_tasks_url, params: { user_id: users(:admin_user).id,
                                    title: "Faire la prise de sang à Mme Thomson au labo",
                                    description: "Chambre 706, puis l'envoyer au labo", status: "draft" }
    end
    assert_response :created

    task = Task.last
    task_json = TaskJson.new(task:).to_h
    assert_equal response.parsed_body, task_json.as_json
  end

  test "shouldn't be able to create a new task if the user doesn't exist" do
    post api_v1_tasks_url, params: { user_id: 0,
                                    title: "Faire la prise de sang à Mme Thomson au labo",
                                    description: "Chambre 706, puis l'envoyer au labo", status: "draft" }

    assert_response :unprocessable_entity

    expected_message = { "user" => [ "must exist" ] }

    assert_equal expected_message, response.parsed_body[:details][:field]
  end

  test "Shouldn't be able to create a new task without a title" do
    post api_v1_tasks_url, params: { user_id: users(:admin_user).id,
                                    description: "Chambre 706, puis l'envoyer au labo", status: "draft" }

    assert_response :unprocessable_entity

    expected_response = { title: "can't be blank" }

    assert_includes response.parsed_body[:details][:field][:title], expected_response[:title]
  end

  test "Shouldn't be able to create a new task when the title is short" do
    post api_v1_tasks_url, params: { user_id: users(:admin_user).id,
                                    title: "la",
                                    description: "Chambre 706, puis l'envoyer au labo", status: "draft" }

    assert_response :unprocessable_entity

    expected_response = { title: "is too short (minimum is 5 characters)" }

    assert_includes response.parsed_body[:details][:field][:title], expected_response[:title]
  end

  test "Shouldn't be able to create a new task without a description" do
    post api_v1_tasks_url, params: { user_id: users(:admin_user).id,
                                    title: "Faire la prise de sang à Mme Thomson au labo", status: "draft" }

    assert_response :unprocessable_entity

    expected_response = { description: "can't be blank" }

    assert_includes response.parsed_body[:details][:field][:description], expected_response[:description]
  end

  test "Shouldn't be able to create a new task when the description is short" do
    post api_v1_tasks_url, params: { user_id: users(:admin_user).id,
                                    title: "Faire la prise de sang à Mme Thomson au labo",
                                    description: "706", status: "draft" }

    assert_response :unprocessable_entity

    expected_response = { description: "is too short (minimum is 5 characters)" }

    assert_includes response.parsed_body[:details][:field][:description], expected_response[:description]
  end

  test "Shouldn't be able to create a new task when the status doesn't exist" do
    post api_v1_tasks_url, params: { user_id: users(:admin_user).id,
                                     title: "Faire la prise de sang à Mme Thomson au labo",
                                     description: "Chambre 706, puis l'envoyer au labo", status: "drafdt" }
    assert_response :unprocessable_entity

    expected_response = { description: "is not included in the list" }

    assert_includes response.parsed_body[:details][:field][:status], expected_response[:description]
  end

  test "Should be able to update a task using PATCH request" do
    task = tasks(:consultation)
    patch api_v1_task_url(id: task.id), params: {
                                     title: "Faire la prise de sang à Mme Thomson",
                                     description: "Chambre 304, puis l'envoyer au labo", status: "done" }

    assert_response :ok
    task.reload

    expected_response = TaskJson.new(task:).to_h.as_json
    assert_equal expected_response, response.parsed_body
  end


  test "Should be able to update a task using PUT request" do
    task = tasks(:consultation)
    put api_v1_task_url(id: task.id), params: { user_id: users(:charlotte).id, title: "Faire la prise de sang à Mme Thomson", description: "Chambre 304, puis l'envoyer au labo", status: "done" }

    assert_response :ok
    task.reload

    expected_response = TaskJson.new(task:).to_h.as_json
    assert_equal expected_response, response.parsed_body
  end

  test "Should render an error message if we try to update a task that doesn't exist using PATCH request" do
    patch api_v1_task_url(id: 0), params: { description: "Chambre 706, puis l'envoyer", status: "in_progress" }

    assert_response :not_found

    expected_error_message = I18n.t("task.api.status.not_found")

    assert_equal expected_error_message, response.parsed_body[:error]
  end

  test "Should render an error message if we try to update a task that doesn't exist' using PUT request" do
    put api_v1_task_url(id: 0), params: { user_id: users(:admin_user), title: "Faire la prise de sang à Mme Thomson au labo", description: "Chambre 706, puis l'envoyer", status: "in_progress" }

    assert_response :not_found

    expected_error_message = I18n.t("task.api.status.not_found")

    assert_equal expected_error_message, response.parsed_body[:error]
  end


  test "Shouldn't be able to update a task  if the user doesn't exist using PATCH request" do
    task = tasks(:consultation)
    patch api_v1_task_url(id: task.id), params: { user_id: 0, description: "Chambre 706, puis l'envoyer", status: "in_progress" }

    expected_message = { "user" => [ "must exist" ] }

    assert_equal expected_message, response.parsed_body[:details][:field]
  end

  test "Shouldn't be able to update a task  if the user doesn't exist using PUT request" do
    task = tasks(:consultation)
    put api_v1_task_url(id: task.id), params: { user_id: 0, title: "Faire la prise de sang à Mme Thomson au labo", description: "Chambre 706, puis l'envoyer", status: "in_progress" }

    expected_message = { "user" => [ "must exist" ] }

    assert_equal expected_message, response.parsed_body[:details][:field]
  end



  test "Shouldn't be able to update a task when the title is too short using PATCH request" do
    patch api_v1_task_url(id: tasks(:consultation).id), params: { title: "La",
      description: "Chambre 706, puis l'envoyer", status: "in_progress" }

    assert_response :unprocessable_entity

    expected_response = { title: "is too short (minimum is 5 characters)" }

    assert_includes response.parsed_body[:details][:field][:title], expected_response[:title]
  end

  test "Shouldn't be able to update a task when the title is too short using PUT request" do
    put api_v1_task_url(id: tasks(:consultation).id), params: { user_id: users(:admin_user).id, title: "La", description: "Chambre 706, puis l'envoyer au labo", status: "in_progress" }
    assert_response :unprocessable_entity

    expected_response = { title: "is too short (minimum is 5 characters)" }

    assert_includes response.parsed_body[:details][:field][:title], expected_response[:title]
  end

  test "Shouldn't be able to update a task when the title blank using PATCH request" do
    patch api_v1_task_url(id: tasks(:consultation).id), params: { title: "", description: "Chambre 706, puis l'envoyer au labo", status: "in_progress" }

    assert_response :unprocessable_entity

    expected_response = { title: "can't be blank" }

    assert_includes response.parsed_body[:details][:field][:title], expected_response[:title]
  end

  test "Shouldn't be able to update a task when the title blank using PUT request" do
    put api_v1_task_url(id: tasks(:consultation).id), params: { user_id: users(:admin_user).id, title: "", description: "Chambre 706, puis l'envoyer au labo", status: "in_progress" }

    assert_response :unprocessable_entity

    expected_response = { title: "can't be blank" }

    assert_includes response.parsed_body[:details][:field][:title], expected_response[:title]
  end

  test "Shouldn't be able to update a task when the description is too short using PATCH request" do
    patch api_v1_task_url(id: tasks(:consultation).id), params: { description: "test", status: "in_progress" }

    assert_response :unprocessable_entity

    expected_response = { description: "is too short (minimum is 5 characters)" }
    assert_includes response.parsed_body[:details][:field][:description], expected_response[:description]
  end

  test "Shouldn't be able to update a task when the description is too short using PUT request" do
    put api_v1_task_url(id: tasks(:consultation).id), params: {  user_id: users(:admin_user).id, description: "test", title: "Faire la prise de sang à Mme Thomson au labo", status: "in_progress" }

    assert_response :unprocessable_entity

    expected_response = { description: "is too short (minimum is 5 characters)" }
    assert_includes response.parsed_body[:details][:field][:description], expected_response[:description]
  end

  test "Shouldn't be able to update a task when the description is blank using PATCH request" do
    patch api_v1_task_url(id: tasks(:consultation).id), params: { description: "", status: "in_progress" }
    assert_response :unprocessable_entity

    expected_response = { description: "can't be blank" }
    assert_includes response.parsed_body[:details][:field][:description], expected_response[:description]
  end

  test "Shouldn't be able to update a task when the description is blank using PUT request" do
    put api_v1_task_url(id: tasks(:consultation).id), params: { user_id: users(:admin_user).id, description: "", status: "in_progress" }
    assert_response :unprocessable_entity

    expected_response = { description: "can't be blank" }
    assert_includes response.parsed_body[:details][:field][:description], expected_response[:description]
  end

  test "Shouldn't be able to update a task when the status doesn't exist in the list using PATCH request" do
    patch api_v1_task_url(id: tasks(:consultation).id), params: { title: "Faire la prise de sang à Mme Thomson",
                                                                  status: "to do" }
    assert_response :unprocessable_entity

    expected_response = { status: "is not included in the list" }
    assert_includes response.parsed_body[:details][:field][:status], expected_response[:status]
  end

  test "Shouldn't be able to update a task when the status doesn't exist in the list using PUT request" do
    put api_v1_task_url(id: tasks(:consultation).id), params: {  user_id: users(:charlotte).id, title: "Faire la prise de sang à Mme Thomson", description: "Chambre 706, puis l'envoyer au labo",
    status: "to do" }

    assert_response :unprocessable_entity

    expected_response = { status: "is not included in the list" }
    assert_includes response.parsed_body[:details][:field][:status], expected_response[:status]
  end
end
