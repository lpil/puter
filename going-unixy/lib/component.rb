class Component
  private

  def log(msg)
    puts "\e[1;34m#{self.class.name}>\e[0m #{msg}"
  end
end
