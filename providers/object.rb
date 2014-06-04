# Copyright 2014 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include Google::Gcs

action :create do
  begin
    Chef::Log.info("Attempting to create #{new_resource.bucket_name}:#{new_resource.object_name}")
    opts = {}
    opts[:'Cache-Control'] = new_resource.cache_control if new_resource.cache_control 
    opts[:'Content-Disposition'] = new_resource.content_disposition if new_resource.content_disposition
    opts[:'Content-Encoding'] = new_resource.content_encoding if new_resource.content_encoding
    opts[:'Content-Type'] = new_resource.content_type if new_resource.content_type
    opts[:'x-goog-acl'] = new_resource.x_goog_acl
    response = gcs.put_object(
      new_resource.bucket_name,
      new_resource.object_name,
      ::File.open(new_resource.local_path),
     opts)
  rescue Excon::Errors::Error => e
    print_error(e, "#{new_resource.bucket_name}:#{new_resource.object_name}")
  rescue => e
    Chef::Log.info(e)
  else
    if response.status == 200
      Chef::Log.info("Success creating object #{new_resource.bucket_name}:#{new_resource.object_name}")
    else
      Chef::Log.info("Creating object #{new_resource.bucket_name}:#{new_resource.object_name} returned #{response.status}")
    end
  end
end

action :delete do
  begin
    Chef::Log.info("Attempting to delete #{new_resource.bucket_name}:#{new_resource.object_name}")
    response = gcs.delete_object(new_resource.bucket_name, new_resource.object_name)
  rescue Excon::Errors::Error => e
    print_error(e, "#{new_resource.bucket_name}:#{new_resource.object_name}")
  rescue
    Chef::Log.info("error")
  else
    if response.status == 204
      Chef::Log.info("Success deleting object #{new_resource.bucket_name}:#{new_resource.object_name}")
    else
      Chef::Log.info("Deleting object #{new_resource.bucket_name}:#{new_resource.object_name} returned #{response.status}")
    end
  end
end

action :copy do
  begin
    target_object_name = new_resource.target_object_name || new_resource.source_object_name
    Chef::Log.info("Attempting to copy #{new_resource.source_bucket_name}:#{new_resource.source_object_name} "\
      "-> #{new_resource.target_bucket_name}:#{target_object_name}")
    opts = {}
    opts[:'x-goog-metadata-directive'] = new_resource.metadata_directive if new_resource.metadata_directive
    opts[:'x-goog-copy_source-if-match'] = new_resource.copy_source_if_match if new_resource.copy_source_if_match
    opts[:'x-goog-copy_source-if-modified_since'] = new_resource.copy_source_if_modified_since if new_resource.copy_source_if_modified_since
    opts[:'x-goog-copy_source-if-none-match'] = new_resource.copy_source_if_none_match if new_resource.copy_source_if_none_match
    opts[:'x-goog-copy_source-if-unmodified-since'] = new_resource.copy_source_if_unmodified_since if new_resource.copy_source_if_unmodified_since
    response = gcs.copy_object(
      new_resource.source_bucket_name,
      new_resource.source_object_name,
      new_resource.target_bucket_name,
      target_object_name,
      opts)
  rescue Excon::Errors::Error => e
    print_error(e, new_resource.source_object_name)
  rescue => e
    Chef::Log.info(e)
  else
    if response.status == 200
      Chef::Log.info("Success copy #{new_resource.source_bucket_name}:#{new_resource.source_object_name} "\
        "-> #{new_resource.target_bucket_name}:#{target_object_name}")
    else
      Chef::Log.info("Copy object #{new_resource.source_bucket_name}:#{new_resource.source_object_name} "\
          "-> #{new_resource.target_bucket_name}:#{target_object_name} returned #{response.status}")
    end
  end
end

private

def print_error(e, object)
  s = e.response.data[:status]
  m = e.response.body.scan(/<Message>(.*?)<\/Message>/).join
  Chef::Log.info("Object #{object}, status #{s}, #{m}")
end
