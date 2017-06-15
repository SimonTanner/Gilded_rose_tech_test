class GildedRose
  attr_reader :items_by_type

  def initialize(items)
    @items = items
    @items_by_type = {"brie" => [], "sulfuras" => [], "backstage passes" => [], "misc" => []}
    items_classify_type(@items)
  end

  def items_classify_type(items)
    items.each do |item|
      item_type_match(item)
    end
    items_by_type = @items_by_type
  end

  def update_brie()
    @items_by_type['brie'].each do |brie|
      if brie.quality < 50
        brie.quality += 1
        brie.sell_in -= 1
      end
    end
  end

  def update_quality()
    @items.each do |item|
      if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
        if item.quality > 0
          if item.name != "Sulfuras, Hand of Ragnaros"
            item.quality = item.quality - 1
          end
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.quality > 0
              if item.name != "Sulfuras, Hand of Ragnaros"
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
    end
  end

  private

  def item_type_match(item)
    @items_by_type.keys.each do |type|
      if item.name.downcase.include? type
        @items_by_type[type].push(item)
        break
      else
        @items_by_type["misc"].push(item)
        break
      end
    end
  end

end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
