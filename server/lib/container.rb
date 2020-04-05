module Container
  def self.exists?(name)
    `podman container exists #{name}`
    $?.success?
  end
end
