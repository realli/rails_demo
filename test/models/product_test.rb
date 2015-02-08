require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  test "product price must be positive" do
    product = Product.new(title: "Test Book Title",
                          description: "test description",
                          image_url: "zzz.jpg")
    product.price = -1
    assert product.invalid?
    product.price = 0
    assert product.invalid?
    product.price = 1
    assert product.valid?
  end

  def new_product image_url
    Product.new(title: "test",
                description: "test",
                price: 1,
                image_url: image_url)
  end

  test "image url format" do
    ok = %w{fred.gif fred.jpg fred.png Fred.JPG fRed.Jpg http://a.b.c/test/x/u/t/tes.pnG}
    bad = %w{fred.doc freg.dig nad/bed.bat}
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid? "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "test",
                          price: 1,
                          image_url: "test.jpg")
    assert product.invalid?
    assert [I18n.translate('errors.messages.taken')],
      product.errors[:title]
  end
end
