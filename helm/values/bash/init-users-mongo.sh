#!/bin/bash
set -e

mongo <<EOF
use \$COURIER_DB_NAME
db.createUser({user: "\$COURIER_DB_USERNAME", pwd: "\$COURIER_DB_PASSWORD", roles: [{role: "readWrite", db: "\$COURIER_DB_NAME"}]})

use \$CART_DB_NAME
db.createUser({user: "\$CART_DB_USERNAME", pwd: "\$CART_DB_PASSWORD", roles: [{role: "readWrite", db: "\$CART_DB_NAME"}]})
EOF