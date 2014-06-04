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

# List information about objects in an Google Storage bucket
# TODO
#action :get do
#end

# Create an Google Storage bucket
action :put do
  begin
    Chef::Log.info("Attempting to create bucket #{new_resource.bucket_name}")
    response = gcs.put_bucket(new_resource.bucket_name)
  rescue Excon::Errors::Error => e
    print_error(e, new_resource.bucket_name)
  rescue => e
    Chef::Log.info(e)
  else
    if response.status == 200
      Chef::Log.info("Success creating bucket #{new_resource.bucket_name}")
    else
      Chef::Log.info("Creating bucket #{new_resource.bucket_name} returned #{response.status}")
    end
  end
end

# Delete an Google Storage bucket
action :delete do
  begin
    Chef::Log.info("Attempting to delete bucket #{new_resource.bucket_name}")
    response = gcs.delete_bucket(new_resource.bucket_name)
  rescue Excon::Errors::Error => e
    print_error(e, new_resource.bucket_name)
  rescue => e
    Chef::Log.info(e)
  else
    if response.status == 204
      Chef::Log.info("Success deleting bucket #{new_resource.bucket_name}")
    else
      Chef::Log.info("Deleting bucket #{new_resource.bucket_name} returned #{response.status}")
    end
  end
end

private

def print_error(e, bucket)
  s = e.response.data[:status]
  m = e.response.body.scan(/<Message>(.*?)<\/Message>/).join
  Chef::Log.info("Bucket #{bucket}, status #{s}, #{m}")
end
