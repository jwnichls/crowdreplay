module GameViewHelper
  def concat_categories(categories)
    str = categories[0].category
    categories[1..(categories.length-1)].each { |c| str += "," + c.category }
    str
  end
  
  def concat_volumes(categories,vol)
    str = vol[:time].strftime("%m-%d-%Y %k:%M %z")
    categories.each { |c| str += "," + vol[c.category].to_s }
    str
  end
end
