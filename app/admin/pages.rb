ActiveAdmin.register Page do
  permit_params :title, :content

  index do
    selectable_column
    id_column
    column :title
    column :slug
    actions
  end

  filter :title
  filter :slug

  form do |f|
    f.inputs "Edit Page Content" do
      f.input :title
      f.input :content, as: :text, input_html: { rows: 10 }
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content
    end
  end
end