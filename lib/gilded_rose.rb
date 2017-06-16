class GildedRose
  attr_reader :items_by_type
  MAX_QUALITY = 50
  MIN_QUALITY = 0
  MISC_DEVAL_FACTOR = 1
  CONJURED_DEVAL_FACTOR = 2

  def initialize(items)
    @items = items
    @items_by_type = {"brie" => [], "sulfuras" => [], "backstage passes" => [], "conjured" => [], "misc" => []}
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
      brie.sell_in -= 1
      if brie.sell_in >= 0 && brie.quality <= MAX_QUALITY - 1
        brie.quality += 1
      elsif brie.sell_in < 0 && brie.quality <= MAX_QUALITY - 2
        brie.quality += 2
      elsif brie.sell_in < 0 && brie.quality >= MAX_QUALITY - 2
        brie.quality = MAX_QUALITY
      end
    end
  end

  def update_backstage_passes()
    @items_by_type['backstage passes'].each do |backstage_pass|
      backstage_pass.sell_in -= 1
      if backstage_pass.sell_in > 10 && backstage_pass.quality < 50
        backstage_pass.quality += 1
      elsif backstage_pass.sell_in <= 10 && backstage_pass.sell_in > 5 && backstage_pass.quality <= MAX_QUALITY - 2
        backstage_pass.quality += 2
      elsif backstage_pass.sell_in <= 5 && backstage_pass.sell_in >= 0 && backstage_pass.quality <= MAX_QUALITY - 3
        backstage_pass.quality += 3
      elsif backstage_pass.sell_in < 0
        backstage_pass.quality = 0
      elsif backstage_pass.sell_in <= 10 && backstage_pass.sell_in > 5 && backstage_pass.quality >= MAX_QUALITY - 2
        backstage_pass.quality = MAX_QUALITY
      elsif backstage_pass.sell_in <= 5 && backstage_pass.sell_in >= 0 && backstage_pass.quality >= MAX_QUALITY - 3
        backstage_pass.quality = MAX_QUALITY
      end
    end
  end

  def update_misc()
    update_misc_or_conjured('misc')
  end

  def update_conjured(factor = CONJURED_DEVAL_FACTOR)
    update_misc_or_conjured('conjured', factor)
  end


  def update_quality()
    update_brie()
    update_backstage_passes()
    update_misc()
  end

  private

  def item_type_match(item)
    item_matched = false
    @items_by_type.keys.each do |type|
      item_name = item.name.downcase
        if item_name.include? type.to_s || item_name == type
          @items_by_type[type].push(item)
          item_matched = true
          break
        end
    end
    if item_matched == false
      @items_by_type["misc"].push(item)
    end
  end

  def update_misc_or_conjured(type, factor= MISC_DEVAL_FACTOR)
    @items_by_type[type].each do |type|
      type.sell_in -= 1
      if type.sell_in >= 0 && type.quality >= MIN_QUALITY + 1 * factor
        type.quality -= 1 * factor
      elsif type.sell_in < 0 && type.quality >= MIN_QUALITY + 2 * factor
        type.quality -= 2 * factor
      else
        type.quality = 0
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
