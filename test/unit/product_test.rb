require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
    assert true
  end
  
  test "product price must be positive" do
    product = Product.new(:title => 'fun',
                          :description => 'yeppers',
                          :image_url => 'pic.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal 'must be greater than or equal to 0.01', product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?
  end

  test "image url" do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg}
    bad = %w{fred.doc fred.gif/more fred.gif.more}

    ok.each do |name|
      assert new_product(name).valid?, 'should not valid'
    end

    bad.each do |name|
      assert new_product(name).invalid?, 'should not be valid'
    end
  end

  def new_product(image_url)
    Product.new(:title => 'title',
                :image_url => image_url,
                :price => 1.00,
                :description => 'rad')
  end
end
