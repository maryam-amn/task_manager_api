ActiveAdmin.register Task do
  permit_params :user_id, :title, :description, :status

  index do
    selectable_column
    id_column
    column :username do |task|
      task.user.username
    end
    column :title do |task|
      task.title.truncate(30)
    end
    column :description do |task|
      task.description.truncate(30)
    end
    column :status  do |t|
      status_tag t.status
    end
    actions
  end

  show do
    attributes_table do
    row :user_id  do |t|
      link_to(t.user&.username, admin_user_path(t.user.id))
    end
    row :title
    row :description
    row :status  do |t|
      status_tag t.status
    end
    row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :user_id, as: :hidden, input_html: { value: current_user.id }
      f.input :title
      f.input :description, as: :text
      f.input :status, as: :select, prompt: "Select Status"
    end
    f.actions
  end
end
