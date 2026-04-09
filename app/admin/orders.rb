ActiveAdmin.register Order do
  permit_params :status

  index do
    selectable_column
    id_column
    column :customer
    column :order_date
    column("Total") { |o| number_to_currency(o.total) }
    column :status
    actions
  end

  filter :status
  filter :order_date

  show do
    attributes_table do
      row :customer
      row :order_date
      row :status
      row("Total") { |o| number_to_currency(o.total) }
    end

    panel "Order Items" do
      table_for order.order_items do
        column("Product") { |i| i.product.name }
        column :quantity
        column("Price Paid") { |i| number_to_currency(i.price_at_purchase) }
        column("Subtotal") { |i| number_to_currency(i.subtotal) }
      end
    end
  end

  action_item :mark_shipped, only: :show do
    link_to "Mark as Shipped", mark_shipped_admin_order_path(resource), method: :put if resource.status == 'paid'
  end

  member_action :mark_shipped, method: :put do
    resource.update!(status: 'shipped')
    redirect_to admin_order_path(resource), notice: "Order marked as shipped!"
  end
end