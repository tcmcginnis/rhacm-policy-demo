if [ "$1" = "" ]; then
   echo "USAGE: $0 \"cluster name\""
   exit 1
else
   cluster_name=$1
fi

CLUSTER_LOGIN=$(oc whoami --show-server|awk -F"api." '{print $2}'|awk -F. '{print $1}')
if [ "$CLUSTER_LOGIN" != "$cluster_name" ]; then
   echo "You must log in to the \"$cluster_name\" as kubeadmin before running this."
   echo ""
   echo "oc login https://api.${cluster_name}.YourDomainName.com:6443 -u kubeadmin"
   echo ""
   exit 2
fi
BASEDIR=`dirname $0`
POLICY_DIR="$BASEDIR/policies/post-deployment/clusters/"
CLUSTER_POLICY_DIR="$BASEDIR/policies/post-deployment/clusters/${cluster_name}"
COMMON_POLICY_DIR="$BASEDIR/policies/post-deployment/common"

ls -d $CLUSTER_POLICY_DIR $COMMON_POLICY_DIR
if [ $? -ne 0 ]; then
   exit 10
fi

(find $CLUSTER_POLICY_DIR -type f | egrep -ie "\.yaml" -ie "\.yml" | grep -v "kustomization\.y" ;
 find $COMMON_POLICY_DIR  -type f | egrep -ie "\.yaml" -ie "\.yml" | grep -v "kustomization\.y") | while read yaml_file 
do
   CMD="oc apply -f $yaml_file"
   echo $CMD
   $CMD
done

