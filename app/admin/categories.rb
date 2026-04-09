ActiveAdmin.register Category do
  permit_params :name, :description

  index do
    selectable_column
    id_column
    column :name
    column :description
    column("Products Count") { |c| c.products.count }
    actions
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row("Products Count") { |c| c.products.count }
    end
  end
end