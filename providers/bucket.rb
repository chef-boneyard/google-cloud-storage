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
    Chef::Log.debug("Attempting to create bucket #{new_resource.bucket_name} on GCS")
    gcs.put_bucket(new_resource.bucket_name)
  rescue Excon::Errors::Error
    print_response($!.response, new_resource.bucket_name)
  rescue
    Chef::Log.info("Error creating bucket #{new_resource.bucket_name}")  
  else
    Chef::Log.debug("Completed creating bucket #{new_resource.bucket_name} on GCS")
  end
end

action :delete do
  begin
    Chef::Log.debug("Attempting to delete bucket #{new_resource.bucket_name} on GCS")
    gcs.delete_bucket(new_resource.bucket_name)
  rescue Excon::Errors::Error
    print_response($!.response, new_resource.bucket_name)
  rescue
    Chef::Log.info("Error deleting bucket #{new_resource.bucket_name}")
  else
    Chef::Log.debug("Completed deleted bucket #{new_resource.bucket_name} on GCS")
  end
end

private

def print_response(response, bucket)
  r = response
  m = r.body.scan(/<Message>(.*?)<\/Message>/).join
  Chef::Log.info("Error with bucket #{bucket}")
  Chef::Log.info(m)
end
