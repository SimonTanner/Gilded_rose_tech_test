require File.join(File.dirname(__FILE__), '../lib/gilded_rose')

describe GildedRose do

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

    it "if the item is 'Aged Brie' the quality increases by 1 each day" do
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
