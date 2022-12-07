class File
  attr_reader :size

  def initialize(size:)
    @size = size.to_i
  end
end

class Directory
  attr_reader :subdirectories, :files, :parent_directory

  def initialize(parent_directory:)
    @parent_directory = parent_directory
    @subdirectories = {}
    @files = {}
  end

  def add_file(name:, size:)
    @files[name] = File.new(size:)
  end

  def add_directory(name:)
    @subdirectories[name] = Directory.new(parent_directory: self)
  end

  def size
    size = 0
    @subdirectories.each { |_, s| size += s.size }
    @files.each { |_, f| size += f.size }
    size
  end

  def directories_larger_than_or_equal_to(min_size:)
    directories = []
    @subdirectories.each do |_, dir|
      directories += dir.directories_larger_than_or_equal_to(min_size:)
    end
    directories.append(self) if size >= min_size
    directories
  end
end

class System
  attr_reader :root_directory, :current_directory

  def initialize(file:)
    @root_directory = Directory.new(parent_directory: nil)
    @current_directory = @root_directory
    @lines = File.readlines(file, chomp: true)
  end

  def build
    @lines.each do |line|
      if line[0] == "$"
        process_command(line:)
      else
        process_item(line:)
      end
    end
  end

  def process_command(line:)
    _, cmd, destination = line.split
    cd(destination:) if cmd == "cd"
  end

  def process_item(line:)
    i, name = line.split
    if i == "dir"
      @current_directory.add_directory(name:)
    else
      @current_directory.add_file(name:, size: i)
    end
  end

  def cd(destination:)
    return if destination == "/"

    @current_directory = if destination == ".."
                           @current_directory.parent_directory
                         else
                           @current_directory.subdirectories[destination]
                         end
  end

  def directories_larger_than_or_equal_to(min_size:)
    @root_directory.directories_larger_than_or_equal_to(min_size:)
  end

  def total_size
    @root_directory.size
  end
end

s = System.new(file: "input.txt")
s.build

total_capacity = 70_000_000
space_required = 30_000_000
space_available = total_capacity - s.total_size
needs_deleting = space_required - space_available

puts s.directories_larger_than_or_equal_to(min_size: needs_deleting).map(&:size).min
