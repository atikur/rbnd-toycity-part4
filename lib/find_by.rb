class Module
  def create_finder_methods(*attributes)
    attributes.each do |attribute|
      new_method = %Q{
        def find_by_#{attribute}(val)
          self.all.each do |product|
            return product if product.#{attribute} == val
          end
        end
      }
      class_eval(new_method)
    end
  end
end