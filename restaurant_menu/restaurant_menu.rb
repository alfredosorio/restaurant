require 'terminal-table'

class MenuItem
  def initialize(name, category, description, price)
    @name = name
    @category = category
    @description = description
    @price = price
    @course = nil
    @options = nil
  end

  attr_accessor :name, :category, :description, :price, :course, :options
end

class Order
  def initialize
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
    "$#{total.round(2)}"
  end

  def surcharge_total
    total = 0
    @items.each do |item|
      total += item.price
    end

    calculated_surcharge = total * (1.5 / 100)
    surcharge_total = (total + calculated_surcharge)    
    "$#{surcharge_total.round(2)}"
  end

  def bill
    if @items == []
      system 'clear'
      puts 'Please order at least one item.'
      sleep 2
      main_menu
    else
      puts 'Thank you'
      puts ''

      sleep 2
      puts 'I hope you enjoyed your meal. Here is your bill:'
      puts '' # Divider Line
      table = Terminal::Table.new headings: ['Name', 'Course', 'Options', 'Price'] do |t|
        @items.each do |item|
          t << [item.name, item.course.capitalize, item.options.capitalize, "$#{item.price}"]
          
        end
        t.add_separator
        t << ['TOTAL (Credit cards incur a surcharge of 1.5%)','','', total]
      end
      table
    end
  end

  def pay_bill
    puts '' # Divider Line
    puts "Please pay #{total} now."
    puts '' # Divider Line
    puts '1. Cash'
    puts '2. Credit Card'
    puts '' # Divider Line
    print 'How would you like to pay? '
    choice = gets.chomp
    case choice
    when '1'
      puts "Sure, that will be #{total}"
      sleep 3
      puts '' # Divider Line
      puts 'Payment received. Thank you for visiting, and see you next time.'
      puts '' # Divider Line
      exit
    when '2'
      puts 'Please note that credit cards incur a surcharge of 1.5%'
      puts "So your total was #{total} and is now #{surcharge_total}"
      sleep 2
      puts '' # Divider Line
      puts "Charging #{surcharge_total} from your account..."
      sleep 3
      puts 'Payment received. Thank you for visiting, and see you next time.'
      puts '' # Divider Line
      exit
    else
      puts 'You entered an invalid entry. Please try again'
      sleep 2
      puts '' # Divider Line
    end
  end

  def request_item(order)
    loop do
      display_food_menu
      puts '' # Divider Line
      display_drinks_menu      
      print 'What would you like? '
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


      # Request course
      print "Would you like the #{menu_item.name} for your [e]ntree, [m]ain or [d]essert? "
      loop do
        choice = gets.chomp.downcase
        case choice
        when 'e'
          puts "The #{menu_item.name} will be served as part of your entree."
          menu_item.course = 'entree'
          break
        when 'm'
          puts "The #{menu_item.name} will be served as part of your main."
          menu_item.course = 'main'
          break
        when 'd'
          puts "The #{menu_item.name} will be served as part of your dessert."
          menu_item.course = 'dessert'
          break    
        else
          puts 'You entered an invalid entry. Please try again'
          sleep 2
          puts '' # Divider Line
        end
      end      


      # Request options
      puts '' # Divider Line
      print "Do you have any special options with your #{menu_item.name}? "
      choice = gets.chomp
      menu_item.options = choice
      puts "Sure, I'll take note of that for your #{menu_item.name}"
      sleep 2
      system 'clear'
    end
  end
end

def display_food_menu
  puts '=' * 9
  puts 'Food Menu'
  puts '=' * 9
  puts '' # Divider Line
  MENU_ITEMS.each_with_index do |menu_item, index|
    user_index = index + 1
    # Display item with index first, then name and price
    if menu_item.category == "Food"
      puts "#{user_index}.) #{menu_item.name}"
      puts "#{menu_item.description}"
      puts "($#{menu_item.price})"
      puts '' # Divider Line
    end
  end
end

def display_drinks_menu
  puts '=' * 11
  puts 'Drinks Menu'
  puts '=' * 11
  puts '' # Divider Line
  MENU_ITEMS.each_with_index do |menu_item, index|
    user_index = index + 1
    # Display item with index first, then name and price
    if menu_item.category == "Drink"
      puts "#{user_index}.) #{menu_item.name} ($#{menu_item.price})"
      puts "#{menu_item.description}"
      puts '' # Divider Line
    end
  end
end

def ask_for_bill(order)
  puts order.bill
  
  loop do
    puts '' # Divider Line
    print 'Would you like to pay now? [y/n] '
    choice = gets.chomp.downcase
    case choice
    when 'y'
      order.pay_bill
    when 'n'
      return
    else 
    puts 'You entered an invalid entry. Please try again'
    sleep 2
    puts '' # Divider Line
    end
  end
end

def main_menu
  order = Order.new

  loop do
    system 'clear'
    puts 'Restaurant Main Menu'
    puts '' # Divider Line
    puts '1. Show food menu.'
    puts '2. Show drinks menu.'
    puts '3. Order items.'
    puts '4. Ask for bill.'
    puts '' # Divider Line
    puts 'Please selection an option: '
    option = gets.chomp

    case option
    when '1'
      system 'clear'
      display_food_menu
      puts 'Press any key...'
      gets 
    when '2'
      system 'clear'
      display_drinks_menu
      puts 'Press any key...'
      gets        
    when '3'
      system 'clear'
      order.request_item(order)
    when '4'
      system 'clear'
      ask_for_bill(order)
      puts '' # Divider Line
    when 't'
      test(order)
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
  MenuItem.new('Chips', 'Food', 'Delicious string fries cooked in batter for a nice and crispy crunch', 7),
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