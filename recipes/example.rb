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

include_recipe "gcs"

gcs = data_bag_item("gcs", "credentials")
file = "/tmp/daily.log"

gcs_bucket "logs" do
  access_key_id gcs['access_key_id']
  secret_access_key gcs['secret_access_key']
  action :put
end

if ::File.exist?(file)
  gcs_object "#{::File.basename(file)}.#{Time.now.strftime('%Y%m%d')}" do
    access_key_id gcs['access_key_id']
    secret_access_key gcs['secret_access_key']
    bucket_name "logs"
    local_path file
    action :put
  end
end
