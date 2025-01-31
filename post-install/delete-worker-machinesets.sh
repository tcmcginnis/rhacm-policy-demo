#!/bin/bash
#
# This script will delete the "-worker-" machinesets from a cluster as the last step in Post Deployment
#
COUNT=$(oc get machinesets -n openshift-machine-api|grep "\-worker-"|wc -l)
if [ $COUNT -eq 0 ]; then
   echo "There are no worker machine sets here."
   echo ""
   oc whoami --show-server
   echo ""
   oc get machinesets -n openshift-machine-api
   exit 10
fi
echo "You are about to delete the following worker machinesets."
echo ""
oc get machinesets -n openshift-machine-api|head -1
oc get machinesets -n openshift-machine-api|grep "\-worker-"
echo ""

ANS=""
until [ "$ANS" = "Y" -o "$ANS" = "N" ]
do
   read -p "Answer (y/n):" ANS
   ANS=${ANS^^}
done
if [ "$ANS" = "Y" ]; then
   oc get machinesets -n openshift-machine-api|grep "\-worker-"|awk '{print $1}'|xargs oc delete machinesets -n openshift-machine-api
fi

