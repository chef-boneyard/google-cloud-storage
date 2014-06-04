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

require 'open-uri'

module Google
  module Gcs

    def gcs
      begin
        require 'fog'
      rescue LoadError
        Chef::Log.error("Missing gem 'fog'")
      end

      options = {
        :provider => 'google',
        :google_storage_access_key_id => new_resource.access_key_id,
        :google_storage_secret_access_key => new_resource.secret_access_key
      }

      @@gcs = Fog::Storage.new(options)
    end

  end
end
