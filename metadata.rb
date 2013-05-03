name             "databox"
maintainer       "Huiming Teo"
maintainer_email "teohuiming@gmail.com"
license          "Apache License 2.0"
description      "Setup a database server that runs multiple MySQL and PostgreSQL databases."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

recipe            "databox", "Includes all recipes."
recipe            "databox::mysql", "Install MySQL and create MySQL databases."
recipe            "databox::postgresql", "Install PostgreSQL and create PostgreSQL databases."

supports "ubuntu"
supports "debian"

depends "database"
depends "mysql"
depends "postgresql"
