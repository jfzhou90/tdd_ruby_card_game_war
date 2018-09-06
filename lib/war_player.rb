 class Player
   attr_reader :name, :client
   def initialize(name)
     @name = name
     @cards_in_hand = []
     @client = nil
   end

   def cards_count
     @cards_in_hand.size
   end

   def add_card(card)
     @cards_in_hand.unshift(card)
   end

   def deal
     @cards_in_hand.pop
   end

   def add_client(client)
     @client = client
   end
 end
