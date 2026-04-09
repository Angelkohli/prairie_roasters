ActiveAdmin.register Product do
  # Updated permit_params to include sale fields
  permit_params :name, :description, :roast_level, :origin,
                :stock_quantity, :category_id, :image, :on_sale, :sale_price

  index do
    selectable_column
    id_column
    column :name
    column :category
    column :roast_level
    column :stock_quantity
    column("Regular Price") { |p| number_to_currency(p.original_price) }
    
    # Sale status column with badge
    column("Sale Status") do |p|
      if p.on_sale?
        status_tag("ON SALE", class: "important")
      else
        status_tag("Regular", class: "ok")
      end
    end
    
    column("Sale Price") { |p| number_to_currency(p.sale_price) if p.on_sale? }
    column("Discount") { |p| "#{p.discount_percentage}% off" if p.on_sale? }
    actions
  end

  # Updated filters to include sale attributes
  filter :name
  filter :category
  filter :roast_level
  filter :on_sale, as: :select, collection: [["Yes", true], ["No", false]]
  filter :sale_price

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :category
      f.input :description
      f.input :roast_level, as: :select,
              collection: %w[Light Medium Medium-Dark Dark],
              include_blank: "Select Roast Level"
      f.input :origin
      f.input :stock_quantity
      f.input :image, as: :file
    end
    
    # New section for sale information
    f.inputs "Sale Information" do
      f.input :on_sale, 
              label: "Put this product on sale?",
              hint: "Check this box to mark the product as on sale"
      f.input :sale_price, 
              label: "Sale Price (CAD)",
              hint: "Enter the discounted price. Leave blank if not on sale."
    end
    
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :category
      row :description
      row :roast_level
      row :origin
      row :stock_quantity
      row("Regular Price") { |p| number_to_currency(p.original_price) }
      
      # Sale information section
      row("On Sale") do |p|
        if p.on_sale?
          status_tag("YES", class: "important")
        else
          status_tag("NO", class: "ok")
        end
      end
      
      row("Sale Price") { |p| number_to_currency(p.sale_price) if p.on_sale? }
      row("Discount") { |p| "#{p.discount_percentage}% off" if p.on_sale? }
      row("You Save") do |p|
        if p.on_sale?
          savings = p.original_price - p.sale_price
          number_to_currency(savings)
        end
      end
      
      row("Current Display Price") do |p|
        if p.on_sale?
          span do
            concat content_tag(:del, number_to_currency(p.original_price), class: "text-muted me-2")
            concat content_tag(:strong, number_to_currency(p.current_price), class: "text-danger")
          end
        else
          number_to_currency(p.current_price)
        end
      end
      
      row("Image") { |p| image_tag url_for(p.image) if p.image.attached? }
    end
    
    # Add a panel showing price history if you want
    panel "Price History" do
      table_for product.product_prices.order(effective_date: :desc).limit(5) do
        column("Price") { |pp| number_to_currency(pp.price) }
        column("Effective Date") { |pp| pp.effective_date.strftime("%B %d, %Y") }
      end
    end
  end

  # Optional: Add custom action to quickly toggle sale status
  action_item :toggle_sale, only: :show do
    if product.on_sale?
      link_to "Remove from Sale", toggle_sale_admin_product_path(product), 
              method: :put, 
              data: { confirm: "Remove this product from sale?" }
    else
      link_to "Put on Sale", toggle_sale_admin_product_path(product), 
              method: :put, 
              data: { confirm: "Mark this product as on sale? You'll need to set a sale price." }
    end
  end

  member_action :toggle_sale, method: :put do
    product = Product.find(params[:id])
    if product.on_sale?
      product.update(on_sale: false, sale_price: nil)
      redirect_to admin_product_path(product), notice: "Product removed from sale."
    else
      # Suggest a 15% discount as default
      suggested_price = (product.original_price * 0.85).round(2)
      redirect_to edit_admin_product_path(product), 
                  notice: "To put this product on sale, check 'On Sale' and set a sale price (suggested: #{number_to_currency(suggested_price)})."
    end
  end

  # Ransack allowlist (updated to include sale attributes for better search)
  controller do
    def scoped_collection
      super.includes(:category, :product_prices)
    end
    
    # Optional: Add custom bulk action for sale
    def apply_sale
      product_ids = params[:collection_selection]
      discount = params[:discount_percentage].to_f
      
      Product.where(id: product_ids).each do |product|
        sale_price = (product.original_price * (1 - discount / 100)).round(2)
        product.update(on_sale: true, sale_price: sale_price)
      end
      
      redirect_to admin_products_path, notice: "#{product_ids.count} products put on sale with #{discount}% discount!"
    end
  end

  # Add batch action to put multiple products on sale
  batch_action :put_on_sale, form: {
    discount_percentage: :number
  } do |ids, inputs|
    discount = inputs[:discount_percentage].to_f
    
    Product.find(ids).each do |product|
      sale_price = (product.original_price * (1 - discount / 100)).round(2)
      product.update(on_sale: true, sale_price: sale_price)
    end
    
    redirect_to collection_path, notice: "#{ids.count} products put on sale with #{discount}% discount!"
  end

  batch_action :remove_from_sale do |ids|
    Product.find(ids).each do |product|
      product.update(on_sale: false, sale_price: nil)
    end
    
    redirect_to collection_path, notice: "#{ids.count} products removed from sale."
  end
end