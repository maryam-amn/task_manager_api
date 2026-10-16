# frozen_string_literal: true

require "test_helper"

class TaskJsonTest < ActiveSupport::TestCase
  test "Should get a task in json" do
    task = tasks(:blood_test)
    expected_json =
      {
        id: 686290135,
        created_by: "charlotte",
        title: "Faire la prise de sang à Mme Thomson au labo",
        description: "Chambre 706, puis l'envoyer au labo ",
        status: "draft"
      }
    task_to_json = TaskJson.new(task:).to_h
    assert_equal expected_json, task_to_json
  end
end
