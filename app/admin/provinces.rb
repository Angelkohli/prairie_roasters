# app/admin/provinces.rb
ActiveAdmin.register Province do
  permit_params :name, :abbreviation, :gst, :pst, :hst

  index do
    selectable_column
    column :name
    column :abbreviation
    column :gst
    column :pst
    column :hst
    actions
  end

  form do |f|
    f.inputs "Province / Territory Tax Rates" do
      f.input :name
      f.input :abbreviation, label: "Code (2 letters)"
      f.input :gst, label: "GST (%)", hint: "e.g., 0.05 for 5%"
      f.input :pst, label: "PST (%)", hint: "e.g., 0.07 for 7%"
      f.input :hst, label: "HST (%)", hint: "e.g., 0.13 for 13% (overrides GST+PST)"
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :abbreviation
      row :gst
      row :pst
      row :hst
    end
  end
end