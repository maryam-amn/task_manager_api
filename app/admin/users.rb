ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :username

  index do
    selectable_column
    id_column
    column :email
    column :username
    column :created_at
    actions
  end

  filter :username
  filter :email
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
