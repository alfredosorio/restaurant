require 'terminal-table'

class MenuItem
  def initialize(name, category, description, price)
    @name = name
    @category = category
    @description = description
    @price = price
    @options = options
  end

  attr_accessor :name, :category, :description, :price, :options
end

class Order
  def initialize()
    @items = []
  end

  def << (menu_item)
    @items << menu_item
  end

  def total
    total = 0
    @items.each do |item|
      total += item.price
    end
    "$#{total}"
  end

  def bill
    table = Terminal::Table.new headings: ['Name', 'Options', 'Price'] do |t|
      @items.each do |item|
        t << [item.name, item.options, "$#{item.price}"]
      end
      t.add_separator
      t << ['TOTAL','', total]
    end
    table
  end
end

def display_food_menu
  puts 'Food Menu:'
  MENU_ITEMS.each_with_index do |menu_item, index|
    user_index = index + 1
    # Display item with index first, then name and price
    if menu_item.category == "Food"
      puts "#{user_index}. #{menu_item.name}: #{menu_item.description} ($#{menu_item.price})"
    end
  end
end

def display_drinks_menu
  puts 'Drinks Menu:'
  MENU_ITEMS.each_with_index do |menu_item, index|
    user_index = index + 1
    # Display item with index first, then name and price
    if menu_item.category == "Drink"
      puts "#{user_index}. #{menu_item.name}: #{menu_item.description} ($#{menu_item.price})"
    end    
  end
end

def order_items(order)
  display_food_menu
  puts '' # Divider Line
  display_drinks_menu
  puts '' # Divider Line
  loop do
    puts 'What would you like?'
    choice = gets.chomp
    # Stop looping if user pressed just enter
    break if choice == ""

    # User must choose an index number
    user_index = choice.to_i

    # If the user entered in an invalid choice
    if user_index == 0
      "Invalid choice, please try again"
      next # Loop through and ask again
    end

    index = user_index - 1 # Convert to zero-based index
    menu_item = MENU_ITEMS[index]

    # Add item to order
    order << menu_item

    # Repeat order back
    puts "You have ordered the #{menu_item.name}."
    puts '' # Divider Line

    # puts "Do you have any special options with your #{menu_item.name}?"
    # puts '' # Divider Line
    # user_options = gets.chomp
    # order << user_options
    
    Which course?
    puts "Would you like the #{menu_item.name} for your [e]ntree, [m]ain or [d]essert?"
      loop do
      course_choice = gets.chomp.downcase
        if course_choice == 'e'
          puts 'You have chosen an entree'
          return
        elsif course_choice == 'm'
          puts 'You have chosen an main'
          return
        elsif course_choice == 'd'
          puts 'You have chosen a dessert'
          return    
        else
          puts 'You entered an invalid entry. Please try again'
          sleep 2
          puts '' # Divider Line
        end
      end
  end
end

def ask_for_bill(order)
  puts 'Thank you'
  puts ''

  sleep 2
  puts 'I hope you enjoyed your meal. Here is your bill:'
  puts order.bill
end

def main_menu
order = Order.new

  loop do
    system 'clear'
    puts 'Restaurant Main Menu'
    puts '' # Divider Line
    puts '1. Show food menu.'
    puts '2. Order items.'
    puts '3. Ask for bill.'
    puts '4. Show drinks menu.'
    puts '' # Divider Line
    puts 'Please selection an option: '
    option = gets.chomp

    case option
    when '1'
      system 'clear'
      display_food_menu
      puts '' # Divider Line
      puts 'Press any key to continue...'
      gets 
    when '2'
      system 'clear'
      order_items(order)
    when '3'
      system 'clear'
      ask_for_bill(order)
      puts '' # Divider Line
      puts 'Press any key to continue...'
      gets    
    when '4'
      system 'clear'
      display_drinks_menu
      puts '' # Divider Line
      puts 'Press any key to continue...'
      gets         
    else 
      puts 'You have entered an invalid option. Please try again.'
      sleep 2
    end     
  end
end

MENU_ITEMS = [
  MenuItem.new('Steak', 'Food', 'This boneless steak is rich, tender, juicy and full-flavored', 20),
  MenuItem.new('Parma', 'Food', 'A delicious chicken Parma', 15),
  MenuItem.new('Eggplant Casserole', 'Food', 'A healthy Turkish Eggplant Casserole Recipe with Tomatoes', 15),
  MenuItem.new('Chips', 'Food', 'Delicious fries', 7),
  MenuItem.new('Beer', 'Drink', 'A nice stout beer from Germany', 7),
  MenuItem.new('Soft drink', 'Drink', 'A drink that is nice and soft', 3.50),
  MenuItem.new('Martini', 'Drink', 'The martini is a cocktail made with gin and vermouth, and garnished with an olive or a lemon twist.', 5.50),
  MenuItem.new('Sour', 'Drink', 'A sour is a traditional family of mixed drinks.', 8),
  MenuItem.new('Margarita', 'Drink', 'A margarita is a cocktail consisting of tequila, triple sec, and lime or lemon juice, often served with salt or sugar on the rim of the glass.', 9.50),
  MenuItem.new('Mojito', 'Drink', 'Mojito is a traditional Cuban highball.', 6.50),
  MenuItem.new('Espresso Martini', 'Drink', 'Espresso Martini is a cold, coffee-flavored cocktail made with vodka, espresso coffee, coffee liqueur, and sugar syrup.', 7.50),
  MenuItem.new('Negroni', 'Drink', 'The Negroni cocktail is made of one part gin, one part vermouth rosso, and one part Campari, garnished with orange peel.', 4)
]

main_menu