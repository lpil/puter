class Component
  def self.install
    self.new.install
  end

  private

  def log(msg)
    puts "#{self.class.name}> #{msg}"
  end
end
