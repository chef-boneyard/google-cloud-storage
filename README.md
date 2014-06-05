# Google Cloud Storage Cookbook LWRP

## Description

This cookbook provides libraries, resources and providers to configure
and manage Google Cloud Storage components. The currently supported
GCS resources are:

 * bucket (`bucket`)
 * object (`object`)

## Requirements

Requires [fog](https://github.com/fog/fog) ruby gem to interact with GCS.

## Authorizing Setup

In order to use the Google Cloud Storage cookbook, you will first need to have
a [Google Cloud](https://cloud.google.com/developers/) project. Once your
project has been created, log in to the [Google Developers Console]
(https://console.developers.google.com/project) and select your project. From
the Google Developers Console, on the left side of the page, click "APIs
& auth" then the "Credentials" sub menu. At the bottom of the page,
click "Return to original console". This will redirect you to the "Google APIs
Console". From the new menu on the left side of the page, click on "Google
Cloud Storage" Unless you've already enabled "Interoperable Access" you'll see
a button towards the bottom of the page. Click that button to enable
"Interoperable Access". Finally, click the new "Interoperable Access" sub menu
on the left side of the page. Your "Interoperable Storage Access Keys" will
now be listed.

```ruby
    % knife data bag show gcs credentials 
    {
      "access_key_id": "AABBCCDDEE",
      "secret_access_key": "abcdefg23456789+0"
    }
```

This can be loaded in a recipe with:

```ruby
    gcs = data_bag_item("gcs", "credentials")
```

And to access the values:

```ruby
    gcs['access_key_id']
    gcs['secret_access_key']
```

## Resources and Providers

This cookbook provides a resource and corresponding provider.

### object.rb

Manage GCS objects with this resource.

Actions:

* `get` - download an object.
* `put` - upload an object.
* `delete` - delete object.
* `copy` - copy an object from one bucket to another.

### bucket.rb

Manage GCS buckets with this resource.

Actions:

* `put` - create a bucket.
* `delete` - delete a bucket.

## Usage

### object create

This will copy a local file to GCS with private permissions set.

```ruby
    gcs_object "my_file" do
      access_key_id gcs['access_key_id']
      secret_access_key gcs['secret_access_key']
      bucket_name "my_bucket"
      local_path "/path/to/my_file"
      action :put
    end
```

### object copy

This will copy an object from one bucket to another. By default,
the target object name will be the same as source unless specified
with the optional `target_bucket_name`.

```ruby
    gcs_object "my_file" do
      access_key_id gcs['access_key_id']
      secret_access_key gcs['secret_access_key']
      source_bucket_name "my_bucket"
      target_bucket_name "my_other_bucket"
      action :copy
    end
```


License and Authors
===================

* Author:: Paul Rossman (<paulrossman@google.com>)

Copyright 2014, Google, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
