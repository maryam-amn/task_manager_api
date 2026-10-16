require "test_helper"

class TaskTest < ActiveSupport::TestCase
  setup do
    @user = users(:admin_user)
  end

  test "should be able to create a task" do
    task = Task.new(user_id: @user.id, title: "Remplacer la vicodin par des placebo", description: "Voir avec le pharmacien comment procéder exactement.", status: "done")
    assert task.valid?
  end

  test "shouldn't be able to create task without a title" do
    task =  Task.new(user_id: @user.id, description: "Rechercher des traces de moisissures.", status: "draft")
    assert_not task.valid?
  end

  test "shouldn't be able to create task without a description " do
    task = Task.new(user_id: @user.id, title: "Faire le test pour la chorée de huntington", status: "archived")
    assert_not task.valid?
  end

  test "shouldn't be able to create task without a user" do
    task = Task.new(title: "Faire la prise de sang à Mme Thomson au labo", description: "Chambre 706, puis l'envoyer au labo", status: "draft")
    assert_not task.valid?
  end
end
