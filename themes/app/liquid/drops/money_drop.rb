class Spree::MoneyDrop < Liquid::BaseDrop

  def to_s
    @source.to_s
  end

   def money
     @source.money
   end
end