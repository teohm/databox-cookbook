# Chef cookbook - databox (v0.1.1)

Setup a **database server** that runs multiple MySQL and PostgreSQL databases.


## Install

To install with **Berkshelf**, add this into `Berksfile`:

```
cookbook 'databox'
```

## Usage

Add `databox::default` recipe into run list, or include the recipe in your code:

```
include_recipe "databox::default"
```

And overwrite attributes to customize the cookbook.

See also [teohm/kitchen-sample](https://github.com/teohm/kitchen-example) for `databox` usage example with chef-solo.

## Attributes

You **should** set the database root password:

 * `node["databox"]["db_root_password"]` (default: `nil`) - password string.
   * for **MySQL**, it overwrites the following passwords in `mysql` cookbook:
     * `node.set["mysql"]["server_root_password"]`
     * `node.set["mysql"]["server_repl_password"]`
     * `node.set["mysql"]["server_debian_password"]`
   * for **PostgreSQL**, it overwrites `postgres` user password in `postgresql` cookbook:
     * `node.set["postgresql"]["password"]["postgres"]`
 
To install **MySQL**, provide a list of database entries:

  * `node["databox"]["databases"]["mysql"]` (default: `[]`)
    
    ```
    # Example:
    node.set["databox"]["databases"]["mysql"] = [
      {
        "database_name" => "app1_production",
        "username" => "app1",
        "password" => "app1_pass"
      }
      {
        "database_name" => "app2_production",
        "username" => "app2",
        "password" => "app2_pass",
        "encoding" => "UTF8",
        "collation" => "utf8_unicode_ci"
      }
    ]
    ```
    
    Each database entry may contain resource parameters specified in [`database`](https://github.com/opscode-cookbooks/database) cookbook:

    * [`database_user`](https://github.com/opscode-cookbooks/database#attribute-parameters-1) resource parameters:
      * username
      * password
      * database_name
      * connection
      * privileges
      * host
      * table
    * [`database`](https://github.com/opscode-cookbooks/database/blob/master/libraries/resource_database.rb) resource parameters needed by MySQL:
      * collation
      * encoding

To install **PostgreSQL**, provide a list of database entries:

  * `node["databox"]["databases"]["postgresql"]` (default: `[]`)
    
    ```
    # Example:
    node.set["databox"]["databases"]["postgresql"] = [
      {
        "database_name" => "app1_production",
        "username" => "app1",
        "password" => "app1_pass"
      }
      {
        "database_name" => "app2_production",
        "username" => "app2",
        "password" => "app2_pass",
        "encoding" => "UTF8",
        "collation" => en_US.utf8"
      }
    ]
    ```
    
    Each database entry may contain resource parameters specified in [`database`](https://github.com/opscode-cookbooks/database) cookbook:

    * [`database_user`](https://github.com/opscode-cookbooks/database#attribute-parameters-1) resource parameters:
      * username
      * password
      * database_name
      * connection
      * privileges
      * host
      * table
    * [`database`](https://github.com/opscode-cookbooks/database/blob/master/libraries/resource_database.rb) resource parameters:
      * template
      * collation
      * encoding
      * tablespace
      * connection_limit
      * owner


## Recipes

 * `databox::default` - run all recipes.
 * `databox::mysql` - install MySQL and create MySQL databases.
 * `databox::postgresql` - install PostgreSQL and create PostgreSQL databases.

## Requirements

### Supported Platforms

 * `ubuntu` - tested on Ubuntu 12.10
 * `debian` - should work
 
Pull requests, issue and test reports are welcomed to better support your platform.
 
### Cookbook Dependencies

 * Depends on these cookbooks:
   * mysql
   * postgresql
   * database
   
## Change History

See [CHANGELOG](CHANGELOG.md).

## License and Authors

 * Author:: Huiming Teo <teohuiming@gmail.com>

Copyright 2013, Huiming Teo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
