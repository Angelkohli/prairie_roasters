# ============================================
# ADMIN USER
# ============================================
unless AdminUser.exists?(email: 'admin@prairieroasters.com')
  AdminUser.create!(
    email: 'admin@prairieroasters.com',
    password: 'password123',
    password_confirmation: 'password123'
  )
end
puts "✅ Admin user created"

# ============================================
# PROVINCES
# ============================================
[
  { name: 'Alberta',                   abbreviation: 'AB', gst: 0.05,    pst: 0.0,     hst: 0.0  },
  { name: 'British Columbia',          abbreviation: 'BC', gst: 0.05,    pst: 0.07,    hst: 0.0  },
  { name: 'Manitoba',                  abbreviation: 'MB', gst: 0.05,    pst: 0.07,    hst: 0.0  },
  { name: 'New Brunswick',             abbreviation: 'NB', gst: 0.0,     pst: 0.0,     hst: 0.15 },
  { name: 'Newfoundland and Labrador', abbreviation: 'NL', gst: 0.0,     pst: 0.0,     hst: 0.15 },
  { name: 'Nova Scotia',               abbreviation: 'NS', gst: 0.0,     pst: 0.0,     hst: 0.15 },
  { name: 'Ontario',                   abbreviation: 'ON', gst: 0.0,     pst: 0.0,     hst: 0.13 },
  { name: 'Prince Edward Island',      abbreviation: 'PE', gst: 0.0,     pst: 0.0,     hst: 0.15 },
  { name: 'Quebec',                    abbreviation: 'QC', gst: 0.05,    pst: 0.09975, hst: 0.0  },
  { name: 'Saskatchewan',              abbreviation: 'SK', gst: 0.05,    pst: 0.06,    hst: 0.0  },
  { name: 'Northwest Territories',     abbreviation: 'NT', gst: 0.05,    pst: 0.0,     hst: 0.0  },
  { name: 'Nunavut',                   abbreviation: 'NU', gst: 0.05,    pst: 0.0,     hst: 0.0  },
  { name: 'Yukon',                     abbreviation: 'YT', gst: 0.05,    pst: 0.0,     hst: 0.0  }
].each do |p|
  unless Province.exists?(abbreviation: p[:abbreviation])
    Province.create!(name: p[:name], abbreviation: p[:abbreviation], gst: p[:gst], pst: p[:pst], hst: p[:hst])
  end
end
puts "✅ #{Province.count} provinces seeded"

# ============================================
# CATEGORIES
# ============================================
[
  { name: 'Single Origin',     description: 'Beans traceable to a single farm, region, or country. Each cup tells the story of its origin.' },
  { name: 'Signature Blends',  description: 'In-house blends crafted for espresso and drip coffee. Balanced, consistent, and delicious.' },
  { name: 'Brewing Equipment', description: 'Pour-overs, French presses, grinders and everything you need to brew the perfect cup at home.' },
  { name: 'Accessories',       description: 'Filters, storage containers, scales, and coffee tools to elevate your brewing setup.' }
].each do |c|
  unless Category.exists?(name: c[:name])
    Category.create!(name: c[:name], description: c[:description])
  end
end
puts "✅ #{Category.count} categories seeded"

# ============================================
# PRODUCTS
# ============================================
single_origin = Category.find_by!(name: 'Single Origin')
blends        = Category.find_by!(name: 'Signature Blends')
equipment     = Category.find_by!(name: 'Brewing Equipment')
accessories   = Category.find_by!(name: 'Accessories')

[
  { name: 'Ethiopian Yirgacheffe',        category: single_origin, price: 19.99, roast_level: 'Light',       origin: 'Ethiopia',          stock_quantity: 50, description: 'Bright and floral with notes of jasmine, bergamot, and lemon zest. A classic light roast from the birthplace of coffee. Best enjoyed as a pour-over or Aeropress.' },
  { name: 'Colombian Huila',              category: single_origin, price: 18.99, roast_level: 'Medium',      origin: 'Colombia',          stock_quantity: 45, description: 'Sweet red fruit notes with a smooth caramel finish. Grown at high altitude in the Huila department by smallholder farmers. Excellent for drip or espresso.' },
  { name: 'Guatemalan Antigua',           category: single_origin, price: 18.49, roast_level: 'Medium-Dark', origin: 'Guatemala',         stock_quantity: 40, description: 'Full body with rich chocolate and spice notes. Volcanic soil in the Antigua valley gives this coffee its distinctive earthy character. Great for French press.' },
  { name: 'Sumatran Mandheling',          category: single_origin, price: 17.99, roast_level: 'Dark',        origin: 'Sumatra, Indonesia', stock_quantity: 35, description: 'Earthy and full-bodied with low acidity. Wet-hulled processing gives this Indonesian coffee a distinctive herbal and cedar quality. Perfect for dark roast lovers.' },
  { name: 'Kenyan AA',                    category: single_origin, price: 21.99, roast_level: 'Light',       origin: 'Kenya',             stock_quantity: 30, description: 'Complex and wine-like acidity with blackcurrant and tomato notes. Washed process from the central highlands of Kenya. A truly unique and memorable cup.' },
  { name: 'Costa Rican Tarrazu',          category: single_origin, price: 19.49, roast_level: 'Medium',      origin: 'Costa Rica',        stock_quantity: 28, description: 'Bright and clean with honey sweetness and a crisp citrus finish. Grown in the high-altitude Tarrazu region, renowned for producing some of Costa Ricas finest coffees.' },
  { name: 'Brazilian Cerrado',            category: single_origin, price: 16.99, roast_level: 'Medium-Dark', origin: 'Brazil',            stock_quantity: 55, description: 'Smooth and nutty with low acidity and a chocolatey finish. Classic Brazilian profile makes this an ideal everyday drinker and a great base for espresso.' },
  { name: 'Exchange District Espresso',   category: blends,        price: 17.99, roast_level: 'Medium-Dark', origin: 'Blend',             stock_quantity: 60, description: 'Our signature espresso blend inspired by Winnipegs historic Exchange District. Dark chocolate, brown sugar, and a thick crema. Designed for lattes, cappuccinos, and straight shots.' },
  { name: 'Prairie Morning Blend',        category: blends,        price: 16.99, roast_level: 'Medium',      origin: 'Blend',             stock_quantity: 55, description: 'A comforting medium roast designed for everyday drip coffee. Nutty and caramel-forward with a clean, bright finish. The perfect companion for your morning routine.' },
  { name: 'Swiss Water Decaf',            category: blends,        price: 18.99, roast_level: 'Medium',      origin: 'Blend',             stock_quantity: 25, description: 'All the flavour, none of the buzz. Chemical-free Swiss Water Process decaffeination preserves the natural sweetness and body. You wont miss the caffeine.' },
  { name: 'Assiniboine Dark Roast',       category: blends,        price: 16.49, roast_level: 'Dark',        origin: 'Blend',             stock_quantity: 40, description: 'Bold, smoky, and intense. Our darkest blend inspired by the rugged banks of the Assiniboine River. Rich dark chocolate and toasted oak notes for those who like it strong.' },
  { name: 'Hario V60 Pour-Over Dripper',  category: equipment,     price: 34.99, roast_level: nil,           origin: nil,                 stock_quantity: 20, description: 'The gold standard for filter coffee. Precision spiral ribs ensure optimal water flow for an exceptionally clean and nuanced cup. Includes 40 V60 paper filters.' },
  { name: 'Bodum Chambord French Press',  category: equipment,     price: 49.99, roast_level: nil,           origin: nil,                 stock_quantity: 15, description: 'Classic chrome and borosilicate glass French press. 8-cup capacity, stainless steel plunger with triple filter system. Timeless design for a rich, full-bodied coffee.' },
  { name: 'Aeropress Coffee Maker',       category: equipment,     price: 44.99, roast_level: nil,           origin: nil,                 stock_quantity: 18, description: 'Fast, versatile, and nearly unbreakable. Makes espresso-style concentrate or smooth filtered coffee in under two minutes. Includes 350 microfilters.' },
  { name: 'Timemore C2 Hand Grinder',     category: equipment,     price: 79.99, roast_level: nil,           origin: nil,                 stock_quantity: 12, description: 'Precision hand grinder with stainless steel conical burrs. 40 grind settings from espresso to French press. Portable, quiet, and produces exceptionally consistent grounds.' },
  { name: 'Fellow Atmos Vacuum Canister', category: accessories,   price: 39.99, roast_level: nil,           origin: nil,                 stock_quantity: 30, description: 'Keep your coffee fresher for longer with this airtight vacuum-seal canister. Twist the lid to remove oxygen and lock in freshness. Matte black finish. 0.7L capacity.' },
  { name: 'Hario V60 Paper Filters',      category: accessories,   price: 9.99,  roast_level: nil,           origin: nil,                 stock_quantity: 50, description: 'Genuine Hario tabbed paper filters for the V60 dripper. Oxygen-bleached white filters for a clean, flavour-neutral brew. Size 02, fits the most popular V60 dripper size.' },
  { name: 'Coffee Dosing Spoon',          category: accessories,   price: 7.99,  roast_level: nil,           origin: nil,                 stock_quantity: 60, description: 'Stainless steel measuring spoon calibrated for a perfect 10g dose of coffee. Matte black finish with Prairie Roasters branding. Simple, accurate, and built to last.' }
].each do |data|
  price    = data.delete(:price)
  category = data.delete(:category)

  unless Product.exists?(name: data[:name])
    product = Product.create!(
      name:           data[:name],
      description:    data[:description],
      roast_level:    data[:roast_level],
      origin:         data[:origin],
      stock_quantity: data[:stock_quantity],
      category:       category
    )
    product.product_prices.create!(price: price, effective_date: Time.current)
  end
end
puts "✅ #{Product.count} products seeded"

# ============================================
# ADD SALE PRODUCTS
# ============================================
puts "Adding sale prices to selected products..."

# Get references to products
ethiopian = Product.find_by(name: 'Ethiopian Yirgacheffe')
colombian = Product.find_by(name: 'Colombian Huila')
exchange = Product.find_by(name: 'Exchange District Espresso')
prairie_morning = Product.find_by(name: 'Prairie Morning Blend')
aeropress = Product.find_by(name: 'Aeropress Coffee Maker')
fellow_canister = Product.find_by(name: 'Fellow Atmos Vacuum Canister')

# Put Ethiopian Yirgacheffe on sale (15% off)
if ethiopian
  original_price = ethiopian.current_price
  sale_price = (original_price * 0.85).round(2)
  ethiopian.update!(
    on_sale: true,
    sale_price: sale_price
  )
  puts "  🔥 #{ethiopian.name} on sale: $#{sale_price} (was $#{original_price}) - Save #{((original_price - sale_price) / original_price * 100).round}%"
end

# Put Colombian Huila on sale (20% off)
if colombian
  original_price = colombian.current_price
  sale_price = (original_price * 0.80).round(2)
  colombian.update!(
    on_sale: true,
    sale_price: sale_price
  )
  puts "  🔥 #{colombian.name} on sale: $#{sale_price} (was $#{original_price}) - Save #{((original_price - sale_price) / original_price * 100).round}%"
end

# Put Exchange District Espresso on sale (15% off)
if exchange
  original_price = exchange.current_price
  sale_price = (original_price * 0.85).round(2)
  exchange.update!(
    on_sale: true,
    sale_price: sale_price
  )
  puts "  🔥 #{exchange.name} on sale: $#{sale_price} (was $#{original_price}) - Save #{((original_price - sale_price) / original_price * 100).round}%"
end

# Put Prairie Morning Blend on sale (10% off)
if prairie_morning
  original_price = prairie_morning.current_price
  sale_price = (original_price * 0.90).round(2)
  prairie_morning.update!(
    on_sale: true,
    sale_price: sale_price
  )
  puts "  🔥 #{prairie_morning.name} on sale: $#{sale_price} (was $#{original_price}) - Save #{((original_price - sale_price) / original_price * 100).round}%"
end

# Put Aeropress on sale (20% off - big discount!)
if aeropress
  original_price = aeropress.current_price
  sale_price = (original_price * 0.80).round(2)
  aeropress.update!(
    on_sale: true,
    sale_price: sale_price
  )
  puts "  🔥 #{aeropress.name} on sale: $#{sale_price} (was $#{original_price}) - Save #{((original_price - sale_price) / original_price * 100).round}%"
end

# Put Fellow Atmos Canister on sale (15% off)
if fellow_canister
  original_price = fellow_canister.current_price
  sale_price = (original_price * 0.85).round(2)
  fellow_canister.update!(
    on_sale: true,
    sale_price: sale_price
  )
  puts "  🔥 #{fellow_canister.name} on sale: $#{sale_price} (was $#{original_price}) - Save #{((original_price - sale_price) / original_price * 100).round}%"
end

# Count how many products are on sale
on_sale_count = Product.where(on_sale: true).count
puts "✅ #{on_sale_count} products are now on sale!"

# ============================================
# PAGES
# ============================================
unless Page.exists?(slug: 'about')
  Page.create!(
    slug: 'about',
    title: 'About Prairie Roasters',
    content: "Founded in 2018 by coffee enthusiasts committed to quality and sustainability, Prairie Roasters has built a loyal following through their small cafe in Winnipeg's Exchange District.\n\nWe roast every batch in small quantities to ensure peak freshness when it reaches your door. Our team works closely with farmers and cooperatives around the world to source exceptional green coffee.\n\nWhether you are a seasoned specialty coffee drinker or just beginning your journey, we are here to help you discover your perfect cup."
  )
end

unless Page.exists?(slug: 'contact')
  Page.create!(
    slug: 'contact',
    title: 'Contact Us',
    content: "We would love to hear from you!\n\nEmail: hello@prairieroasters.ca\nPhone: (204) 555-0192\n\nCafe Location:\n123 Arthur Street\nExchange District\nWinnipeg, Manitoba R3B 1H3\n\nHours:\nTuesday to Friday: 8am to 5pm\nSaturday to Sunday: 9am to 4pm\nMonday: Closed"
  )
end
puts "✅ Pages seeded"

puts ""
puts "🌾 Prairie Roasters seeded successfully!"
puts "   Admin: admin@prairieroasters.com / password123"
puts "   Products: #{Product.count} | Categories: #{Category.count} | Provinces: #{Province.count}"
puts "   🔥 On Sale: #{Product.where(on_sale: true).count} products with discounted prices!"