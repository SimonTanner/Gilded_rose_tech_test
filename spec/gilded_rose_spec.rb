require File.join(File.dirname(__FILE__), '../lib/gilded_rose')

describe GildedRose do

  describe "#items_classify_type" do
    it "classifies an item by it's type and stores it in an array stored in a hash table with the key as the type of object" do
      items = [Item.new("Aged Brie", 5, 6)]
      gilded_rose = GildedRose.new(items)
      expect(gilded_rose.items_by_type['brie']).to include(items[0])

      items = [Item.new("Backstage passes", 5, 6)]
      gilded_rose = GildedRose.new(items)
      expect(gilded_rose.items_by_type['backstage passes']).to include(items[0])

      items = [Item.new("Sulfuras", 5, 6)]
      gilded_rose = GildedRose.new(items)
      expect(gilded_rose.items_by_type['sulfuras']).to include(items[0])

      items = [Item.new("Carrots", 5, 6)]
      gilded_rose = GildedRose.new(items)
      expect(gilded_rose.items_by_type['misc']).to include(items[0])

      items = [Item.new("Conjured Mana Cake", 2, 5)]
      gilded_rose = GildedRose.new(items)
      expect(gilded_rose.items_by_type['conjured']).to include(items[0])
    end

    it "can be passed multiple items of different types in one assignment" do
      items = [Item.new("Aged Brie", 5, 6), Item.new("Backstage passes", 5, 6), Item.new("Sulfuras", 5, 6), Item.new("Carrots", 5, 6)]
      gilded_rose = GildedRose.new(items)
      expect(gilded_rose.items_by_type['brie']).to include(items[0])
      expect(gilded_rose.items_by_type['backstage passes']).to include(items[1])
      expect(gilded_rose.items_by_type['sulfuras']).to include(items[2])
      expect(gilded_rose.items_by_type['misc']).to include(items[3])
    end
  end

  describe "#update_brie" do
    before(:example) do
      @items = [Item.new("Aged Brie", 5, 6)]
      @gilded_rose = GildedRose.new(@items)
    end

    it "updates the quality of any item classified as a type of brie" do
      @gilded_rose.update_brie()
      expect(@items[0].quality).to eq(7)
    end

    it "will not increase the quality of the brie above 50" do
      50.times {@gilded_rose.update_brie()}
      expect(@items[0].quality).to eq(50)
    end

    it "decreases the sellin no. by 1 each time it is called" do
      5.times {@gilded_rose.update_brie()}
      expect(@items[0].sell_in).to eq(0)
    end

    it "increases the quality by 2 once the sell by date has passed" do
      10.times {@gilded_rose.update_brie()}
      expect(@items[0].quality).to eq(21)
    end
  end

  describe "#update_backstage_passes" do
    before(:example) do
      @items = [Item.new("Backstage passes", 20, 6)]
      @gilded_rose = GildedRose.new(@items)
    end

    it "decreases the sell_in value by one each day" do
      @gilded_rose.update_backstage_passes()
      expect(@items[0].sell_in).to eq(19)
    end

    it "increases in value by 1 per day if there are more than ten days until the event" do
      @gilded_rose.update_backstage_passes()
      expect(@items[0].quality).to eq(7)
    end

    it "increases in value by 2 per day if there are less than ten days until the event" do
      11.times { @gilded_rose.update_backstage_passes() }
      expect(@items[0].quality).to eq(19)
    end

    it "increases in value by 2 per day if there are less than ten days until the event" do
      @items = [Item.new("Backstage passes", 5, 6)]
      @gilded_rose = GildedRose.new(@items)
      2.times { @gilded_rose.update_backstage_passes() }
      expect(@items[0].quality).to eq(12)
    end

    it "increases the value of the pass up to the date of the event" do
      20.times { @gilded_rose.update_backstage_passes() }
      expect(@items[0].quality).to eq(43)
    end

    it "the value of the pass drops to zero if the event has already happened" do
      21.times { @gilded_rose.update_backstage_passes() }
      expect(@items[0].quality).to eq(0)
    end

    it "won't increase the value above 50" do
      @items = [Item.new("Backstage passes", 5, 46)]
      @gilded_rose = GildedRose.new(@items)
      2.times { @gilded_rose.update_backstage_passes() }
      expect(@items[0].quality).to eq(50)
    end
  end

  describe "#update_misc" do
    before(:example) do
      @items = [Item.new("+5 Dexterity Vest", 10, 20)]
      @gilded_rose = GildedRose.new(@items)
    end

    it "decreases the value of a miscallaneous item by 1 each day if the sell_in date is positive" do
      @gilded_rose.update_misc()
      expect(@items[0].quality).to eq(19)
    end

    it "decreases the value of a miscallaneous item by 2 each day if the sell_in date is passed" do
      14.times { @gilded_rose.update_misc() }
      expect(@items[0].quality).to eq(2)
    end

    it "the value cannot decrease below 0" do
      16.times { @gilded_rose.update_misc() }
      expect(@items[0].quality).to eq(0)
    end
  end

  describe "#update_conjured" do
    before(:example) do
      @items = [Item.new("Conjured Mana Cake", 2, 5)]
      @gilded_rose = GildedRose.new(@items)
    end

    it "degrades by 1 each day that it hasn't passed it's sell by date" do
      @gilded_rose.update_conjured()
      expect(@items[0].quality).to eq(4)
    end

    it "degrades by 1 each day that it hasn't passed it's sell by date" do
      @gilded_rose.update_conjured()
      expect(@items[0].sell_in).to eq(1)
    end
  end

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    it "if an item is not special, e.g. Brie, Sulfuras or Backstage passes, then it will decay twice as fast once passed it's sell in date has passed" do
      items = [Item.new("Carrots", 0, 10)]
      gilded_rose = GildedRose.new(items)
      5.times { gilded_rose.update_quality() }
      expect(items[0].quality).to eq(0)
    end

    it "if the item is 'Aged Brie' the quality increases by 2 each day, once passed it's sell by date" do
      items = [Item.new("Aged Brie", 0, 0)]
      gilded_rose = GildedRose.new(items)
      5.times { gilded_rose.update_quality() }
      expect(items[0].quality).to eq(10)
    end

    it "the quality of an item is never below zero" do
      items = [Item.new("Carrots", 0, 0)]
      gilded_rose = GildedRose.new(items)
      5.times { gilded_rose.update_quality() }
      expect(items[0].quality).to eq(0)
    end

    it "the quality of Sulfuras never decreases" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 45)]
      gilded_rose = GildedRose.new(items)
      10.times { gilded_rose.update_quality() }
      expect(items[0].quality).to eq(45)
    end

  end

end
