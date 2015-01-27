require 'minitest/autorun'
require 'mocha/mini_test'
require './lib/s3_mock'

class S3MockTest < MiniTest::Test

  include S3Mock

  def test_s3_helper
    s3_mocks = s3_mock([
      "foo/bar/file.json",
      "foo/baz/file.json",
      "foo/baz/file2.json"
    ])

    assert s3_mocks["foo/bar/file.json"].exists?
    assert s3_mocks["foo/bar/file.json"].leaf?
    assert !s3_mocks["foo/bar/file.json"].branch?
    assert s3_mocks["foo/bar"].branch?
    assert !s3_mocks["foo/bar"].leaf?
    assert_equal 1, s3_mocks["foo/bar"].children.length
    assert_equal 2, s3_mocks["foo"].children.length, s3_mocks["foo"].children.inspect + " with "+s3_mocks.inspect
    assert_equal 2, s3_mocks["foo/baz"].children.length, s3_mocks["foo/baz"].children.inspect + " with "+s3_mocks.inspect

    s3 = AWS::S3.new
    bucket = s3.buckets["some-bucket"]
    assert_equal 3, bucket.objects.length
    assert_equal 1, bucket.as_tree(:prefix => "foo/bar").children.length
    assert_equal true, bucket.as_tree(:prefix => "foo/bar").children.first.leaf?
    assert_equal "foo/baz/file2.json", bucket.as_tree(:prefix => "foo/baz").children.last.key
    assert_equal 2, bucket.as_tree(:prefix => "foo").children.select(&:branch?).length, "should have found 'bar' and 'baz'"
    assert_equal 1, bucket.as_tree.children.select(&:branch?).length, "should have only found 'foo'"
    assert_equal false, bucket.objects["does/not/exist"].exists?
    assert_equal false, bucket.objects["foo/bar/either"].exists?
  end

end
