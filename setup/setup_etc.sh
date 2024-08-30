#!/bin/bash
sudo tee /etc/security/limits.d/limit.conf > /dev/null <<EOF
* soft nofile 1048576
* hard nofile 1048576
root soft nofile 1048576
root hard nofile 1048576
EOF

echo "source $PEGASUS_ROOT/env.sh" | sudo tee /etc/profile.d/pegasus.sh > /dev/null
