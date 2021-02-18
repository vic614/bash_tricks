# kubectl
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
alias ka="kubectl apply -f"
alias kg="kubectl get -o wide"
alias ktp="kubectl top pods"
alias ktn="kubectl top nodes"
alias kgp="kubectl get pods -o wide"
alias kgpv="kubectl get pv -o wide"
alias kgpvc="kubectl get pvc -o wide"
alias kgcm="kubectl get cm -o wide"
alias kgn="kubectl get nodes -o wide"
alias kgns="kubectl get ns -o wide --show-labels"
alias kgs="kubectl get svc -o wide"
alias kgvs="kubectl get vs -o wide"
alias kgrs="kubectl get rs -o wide"
alias kgap="kubectl get authorizationpolicies.security.istio.io -o wide"
alias kgpo="kubectl get policy -o wide"
alias kgpfail="kubectl get pods -o wide -A | grep -v 'Running' | grep -v 'Completed'"
alias kl="kubectl logs"
alias kcall='kubectl get nodes --no-headers | awk '\''{print $1}'\'' | xargs -I {} sh -c '\''echo {} ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo '\'''
# kubectl wrapper to prevent accidental deletion
kubectl() {
  kube_prod_context_regex="_prod-" #Change to a Regex that matches the prod cluster's context
  case $* in
    delete* ) shift 1
              kube_context=$(kubectl config current-context)
              if [[ $kube_context =~ .*"$kube_prod_context_regex".* ]]; then
                read -p "kubectl delete in production (y or n)?" yn
                case $yn in
                  [Yy]* ) command kubectl delete "$@";;
                  [Nn]* ) echo abort.. ;;
                esac
              else
                command kubectl delete "$@"
              fi ;;
    * ) command kubectl "$@" ;;
  esac
}
# Find all resources in a namespace 
kgall() {
  if [ $# -eq 0 ]
  then
    echo "Define namespace to search."
  else
    echo "Searching all resources in namespace $1"
    kubectl get namespace $1 &&
    kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n $1
  fi
}

