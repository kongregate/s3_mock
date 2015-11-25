require "s3_mock/version"
require "aws-sdk"

module S3Mock

  def s3_mock(file_or_file_list, dir_contents={})
    files = file_or_file_list.is_a?(Array) ? file_or_file_list : [file_or_file_list]
    s3_mocks = {}
    s3_objects = Class.new(super_class=Hash) do
      def [](key)
        return super(key) if keys.include?(key)
        Class.new() { def self.exists?() false end }
      end
    end

    @objects ||= s3_objects.new
    root = mock("root")
    s3_mocks[""] = root
    root.stubs(:children).returns([])
    files.each do |file|
      parts = file.split("/")
      parts.each_with_index do |part, i|
        path = parts[0..i].join("/")
        next if !s3_mocks[path].nil?

        part_mock = mock(path)
        parent_path = parts[0..(i-1)].join("/") if i > 0
        parent_mock = parent_path ? s3_mocks[parent_path] : root
        parent_mock.children.push(part_mock) #returns(parent_mock.stubs(:children).push())

        if (i+1) == parts.length
          #file
          part_mock.stubs(:leaf?).returns(true)
          part_mock.stubs(:branch?).returns(false)
          part_mock.stubs(:exists?).returns(true)
          part_mock.stubs(:key).returns(path)
          part_mock.stubs(:delimiter).returns("/")
          @objects[path] = part_mock
        else
          #folder
          part_mock.stubs(:leaf?).returns(false)
          part_mock.stubs(:branch?).returns(true)
          part_mock.stubs(:children).returns([])
          part_mock.stubs(:prefix).returns(path+"/")
          part_mock.stubs(:delimiter).returns("/")
          AWS::S3::Bucket.any_instance.stubs(:as_tree).with(:prefix => path).returns(part_mock)
        end

        s3_mocks[path] = part_mock

      end
    end

    dir_contents.each do |path, value|
      if value.nil?
        s3_mocks[path].stubs(:children).returns(@objects.values)
        s3_mocks[path].stubs(:select).returns(s3_mocks[path])
        s3_mocks[path].stubs(:each).returns([s3_mocks[path]])
        s3_mocks[path].stubs(:as_tree).returns(s3_mocks[path])
      else
        s3_mocks[path].stubs(:children).returns([s3_mocks[value]])
        s3_mocks[path].stubs(:as_tree).with(:prefix => path).returns(s3_mocks[path])
      end
    end

    AWS::S3::Bucket.any_instance.stubs(:as_tree).with().returns(root)
    AWS::S3::Bucket.any_instance.stubs(:objects).returns(@objects)
    #if we just wanted one mock, return pointer to it
    file_or_file_list.is_a?(Array) ? s3_mocks : s3_mocks[file_or_file_list]
  end
end
