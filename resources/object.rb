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

actions :get, :put, :delete, :copy

attribute :access_key_id,                   :kind_of => String, :required => true
attribute :secret_access_key,               :kind_of => String, :required => true

attribute :object_name,                     :kind_of => String, :name_attribute => true
attribute :bucket_name,                     :kind_of => String
attribute :local_path,                      :kind_of => String
attribute :cache_control,                   :kind_of => String
attribute :content_disposition,             :kind_of => String
attribute :content_encoding,                :kind_of => String
attribute :content_type,                    :kind_of => String
# x_goog_acl must be one of the following: 'private', 'public-read', 'public-read-write', 'authenticated-read'
attribute :x_goog_acl,                      :kind_of => String, :default => "private"
attribute :source_object_name,              :kind_of => String, :name_attribute => true
attribute :target_object_name,              :kind_of => String
attribute :source_bucket_name,              :kind_of => String
attribute :target_bucket_name,              :kind_of => String
attribute :metadata_directive,              :kind_of => String
attribute :copy_source_if_match,            :kind_of => String
attribute :copy_source_if_modified_since,   :kind_of => String
attribute :copy_source_if_none_match,       :kind_of => String
attribute :copy_source_if_unmodified_since, :kind_of => String

def initialize(*args)
  super
  @action = :put
end
