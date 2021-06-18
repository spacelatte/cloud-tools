#!/usr/bin/env make -f

TOOLS := \
	calicoctl \
	captain \
	civo \
	consul \
	copilot \
	coredns \
	ctop \
	deno \
	direnv \
	doctl \
	ecs-cli \
	eksctl \
	etcd \
	etcdctl \
	helm \
	jq \
	k3d \
	k3s \
	k9s \
	kind \
	kn \
	kompose \
	kops \
	krew \
	kubectl \
	kubectx \
	kubens \
	minikube \
	rke \
	shellcheck \
	simple-ec2 \
	skaffold \
	stern \
	terraform \
	terraform-ls \
	traefik \
	vault \
	websocketd \

OS       := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH     := $(shell uname -m)
GH_USER  := $(shell git config --global github.user || echo 1)
GH_TOKEN := $(shell git config --global github.pat  || echo 1)
AUTH     := $(GH_USER):$(GH_TOKEN)

ifeq ($(ARCH),x86_64)
	ARCH := amd64
endif

ifeq ($(ARCH),armv7l)
	ARCH := armhf
endif

ifeq ($(ARCH),aarch64)
	ARCH := arm64
endif

REL_kn = https://api.github.com/repos/knative/client/releases
URL_kn = https://github.com/knative/client/releases/download/${VER}/kn-$(OS)-$(ARCH)

REL_k3s = https://api.github.com/repos/rancher/k3s/releases
URL_k3s = https://github.com/rancher/k3s/releases/download/${VER}/k3s$$(echo -$(ARCH) | grep -v amd64)

REL_k3d = https://api.github.com/repos/rancher/k3d/releases
URL_k3d = https://github.com/rancher/k3d/releases/download/${VER}/k3d-$(OS)-$(ARCH)

REL_rke = https://api.github.com/repos/rancher/rke/releases
URL_rke = https://github.com/rancher/rke/releases/download/${VER}/rke_$(OS)-$(ARCH)

REL_helm = https://api.github.com/repos/helm/helm/releases
URL_helm = https://get.helm.sh/helm-${VER}-$(OS)-$(ARCH).tar.gz
EXT_helm = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; tar --strip=1 -OUxzvf "$@-$(OS)-${VER}.tmp" "$(OS)-$(ARCH)/$*" > "$@-$(OS)-${VER}"

REL_kind = https://api.github.com/repos/kubernetes-sigs/kind/releases
URL_kind = https://kind.sigs.k8s.io/dl/${VER}/kind-$(OS)-$(ARCH)

REL_kops = https://api.github.com/repos/kubernetes/kops/releases
URL_kops = https://github.com/kubernetes/kops/releases/download/${VER}/kops-$(OS)-$(ARCH)

REL_krew = https://api.github.com/repos/kubernetes-sigs/krew/releases
URL_krew = https://github.com/kubernetes-sigs/krew/releases/download/${VER}/krew.tar.gz
EXT_krew = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; tar -OUxzvf "$@-$(OS)-${VER}.tmp" "$*-$(OS)_$(ARCH)" > "$@-$(OS)-${VER}"

REL_kubens = https://api.github.com/repos/ahmetb/kubectx/releases
URL_kubens = https://github.com/ahmetb/kubectx/releases/download/${VER}/kubens

REL_kubectx = https://api.github.com/repos/ahmetb/kubectx/releases
URL_kubectx = https://github.com/ahmetb/kubectx/releases/download/${VER}/kubectx

REL_kubectl = https://storage.googleapis.com/kubernetes-release/release/stable.txt
REL_kubectl = https://api.github.com/repos/kubernetes/kubernetes/releases
URL_kubectl = https://storage.googleapis.com/kubernetes-release/release/${VER}/bin/$(OS)/$(ARCH)/kubectl

REL_kompose = https://api.github.com/repos/kubernetes/kompose/releases
URL_kompose = https://github.com/kubernetes/kompose/releases/download/${VER}/kompose-$(OS)-$(ARCH)

REL_minikube = https://api.github.com/repos/kubernetes/minikube/releases
URL_minikube = https://storage.googleapis.com/minikube/releases/${VER}/minikube-$(OS)-$(ARCH)
URL_minikube = https://github.com/kubernetes/minikube/releases/download/${VER}/minikube-$(OS)-$(ARCH)

REL_skaffold = https://api.github.com/repos/GoogleContainerTools/skaffold/releases
URL_skaffold = https://storage.googleapis.com/skaffold/releases/${VER}/skaffold-$(OS)-$(ARCH)
URL_skaffold = https://github.com/GoogleContainerTools/skaffold/releases/download/${VER}/skaffold-$(OS)-$(ARCH)

REL_stern = https://api.github.com/repos/wercker/stern/releases
URL_stern = https://github.com/wercker/stern/releases/download/${VER}/stern_$(OS)_$(ARCH)

REL_coredns = https://api.github.com/repos/coredns/coredns/releases
URL_coredns = https://github.com/coredns/coredns/releases/download/${VER}/coredns_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).tgz
EXT_coredns = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; tar -OUxzvf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_eksctl = https://api.github.com/repos/weaveworks/eksctl/releases
URL_eksctl = https://github.com/weaveworks/eksctl/releases/download/${VER}/eksctl_$(shell uname -s)_$(ARCH).tar.gz
EXT_eksctl = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; tar -OUxzvf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

# https://github.com/kubernetes-sigs/kustomize/releases/download/api%2Fv0.5.1/api_v0.5.1_darwin_amd64.tar.gz
REL_kustomize = https://api.github.com/repos/kubernetes-sigs/kustomize/releases
URL_kustomize = https://github.com/kubernetes-sigs/kustomize/releases/download/${VER}/kustomize_$$(echo ${VER} | cut -d/ -f2)_$(OS)_$(ARCH).tar.gz
EXT_kustomize = file -bzI "$@-$(OS)-$$(echo ${VER} | cut -d/ -f2).tmp" | grep -q 'application/x-tar' || exit 0; tar -OUxzvf "$@-$(OS)-$$(echo ${VER} | cut -d/ -f2).tmp" "$*" > "$@-$(OS)-${VER}"

REL_kubefed = https://api.github.com/repos/kubernetes-sigs/kubefed/releases
URL_kubefed = https://github.com/kubernetes-sigs/kubefed/releases/download/${VER}/kubefedctl-$$(echo ${VER} | cut -b2-)-$(OS)-$(ARCH).tgz
EXT_kubefed = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; tar -OUxzvf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_terraform = https://api.github.com/repos/hashicorp/terraform/releases
URL_terraform = https://releases.hashicorp.com/terraform/$$(echo ${VER} | cut -b2-)/terraform_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).zip
EXT_terraform = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/zip' || exit 0; unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_terraform-ls = https://api.github.com/repos/hashicorp/terraform-ls/releases
URL_terraform-ls = https://releases.hashicorp.com/terraform-ls/$$(echo ${VER} | cut -b2-)/terraform-ls_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).zip
EXT_terraform-ls = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/zip' || exit 0; unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_consul = https://api.github.com/repos/hashicorp/consul/releases
URL_consul = https://releases.hashicorp.com/consul/$$(echo ${VER} | cut -b2-)/consul_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).zip
EXT_consul = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/zip' || exit 0; unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_captain = https://api.github.com/repos/jenssegers/captain/releases
URL_captain = https://github.com/jenssegers/captain/releases/download/${VER}/captain-osx

REL_deno = https://api.github.com/repos/denoland/deno/releases
URL_deno = https://github.com/denoland/deno/releases/download/${VER}/deno-$$(uname -m)-apple-$(OS).zip
EXT_deno = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/zip' || exit 0; unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_etcd = https://api.github.com/repos/etcd-io/etcd/releases
URL_etcd = https://github.com/etcd-io/etcd/releases/download/${VER}/etcd-${VER}-$(OS)-$(ARCH).zip
EXT_etcd = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/zip' || exit 0; unzip -p "$@-$(OS)-${VER}.tmp" "etcd-${VER}-$(OS)-$(ARCH)/$*" > "$@-$(OS)-${VER}"

REL_etcdctl = $(REL_etcd)
URL_etcdctl = $(URL_etcd)
EXT_etcdctl = $(EXT_etcd)

REL_copilot = https://api.github.com/repos/aws/copilot-cli/releases
URL_copilot = https://github.com/aws/copilot-cli/releases/download/${VER}/copilot-$(OS)$$(test $(OS) == linux && echo -$(ARCH))

REL_ecs-cli = https://api.github.com/repos/aws/amazon-ecs-cli/releases
URL_ecs-cli = https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-$(OS)-$(ARCH)-${VER}

REL_ctop = https://api.github.com/repos/bcicen/ctop/releases
URL_ctop = https://github.com/bcicen/ctop/releases/download/${VER}/ctop-$$(echo ${VER} | cut -b2-)-$(OS)-$(ARCH)

REL_shellcheck = https://api.github.com/repos/koalaman/shellcheck/releases
URL_shellcheck = https://github.com/koalaman/shellcheck/releases/download/${VER}/shellcheck-${VER}.$(OS).$(shell uname -m).tar.xz
EXT_shellcheck = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-xz' || exit 0; tar --strip=1 -OUxzvf "$@-$(OS)-${VER}.tmp" "shellcheck-${VER}/$*" > "$@-$(OS)-${VER}"

REL_websocketd = https://api.github.com/repos/joewalnes/websocketd/releases
URL_websocketd = https://github.com/joewalnes/websocketd/releases/download/${VER}/websocketd-$$(echo ${VER} | cut -b2-)-$(OS)_$(ARCH).zip
EXT_websocketd = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/zip' || exit 0; unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_jq = https://api.github.com/repos/stedolan/jq/releases
URL_jq = https://github.com/stedolan/jq/releases/download/${VER}/jq-$(shell echo $(OS) | grep -i linux || echo osx)-$(ARCH)

REL_doctl = https://api.github.com/repos/digitalocean/doctl/releases
URL_doctl = https://github.com/digitalocean/doctl/releases/download/${VER}/doctl-$$(echo ${VER} | cut -b2-)-$(OS)-$(ARCH).tar.gz
EXT_doctl = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; tar -OUxzvf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_civo = https://api.github.com/repos/civo/cli/releases
URL_civo = https://github.com/civo/cli/releases/download/${VER}/civo-$$(echo ${VER} | cut -b2-)-$(OS)-$(ARCH).tar.gz
EXT_civo = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; tar -OUxzvf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_traefik = https://api.github.com/repos/traefik/traefik/releases
URL_traefik = https://github.com/traefik/traefik/releases/download/${VER}/traefik_${VER}_$(OS)_$(ARCH).tar.gz
EXT_traefik = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; tar -OUxzvf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_copilot = https://api.github.com/repos/aws/copilot-cli/releases
URL_copilot = https://github.com/aws/copilot-cli/releases/download/${VER}/copilot-$(OS)

REL_simple-ec2 = https://api.github.com/repos/awslabs/aws-simple-ec2-cli/releases
URL_simple-ec2 = https://github.com/awslabs/aws-simple-ec2-cli/releases/download/${VER}/simple-ec2-$(OS)-$(ARCH)

REL_vault = https://api.github.com/repos/hashicorp/vault/releases
URL_vault = https://releases.hashicorp.com/vault/$$(echo ${VER} | cut -b2-)/vault_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).zip
EXT_vault = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/zip' || exit 0; unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_direnv = https://api.github.com/repos/direnv/direnv/releases
URL_direnv = https://github.com/direnv/direnv/releases/download/${VER}/direnv.$(OS)-$(ARCH)

REL_calicoctl = https://api.github.com/repos/projectcalico/calicoctl/releases
URL_calicoctl = https://github.com/projectcalico/calicoctl/releases/download/${VER}/calicoctl-$(OS)-$(ARCH)

REL_regctl = https://api.github.com/repos/regclient/regclient/releases
URL_regctl = https://github.com/regclient/regclient/releases/download/${VER}/regctl-$(OS)-$(ARCH)

REL_k9s = https://api.github.com/repos/derailed/k9s/releases
URL_k9s = https://github.com/derailed/k9s/releases/download/${VER}/k9s_${VER}_$(shell uname -s)_$(shell uname -m).tar.gz
EXT_k9s = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; tar -OUxzvf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

export COLUMNS = 50

all: $(addprefix bin/, $(TOOLS) ) showbanner
	# That is all...

showbanner:
	@tr : '\n' <<< "$(PATH)" | grep -qi "$(shell realpath "$(CURDIR)/bin")" || (true \
		&& echo '**************************************************************' \
		&& echo '==> ADD $(PWD)/bin or $(CURDIR)/bin to $$PATH !!! <==' \
		&& echo '**************************************************************' \
	)

.FORCE:
.PRECIOUS: %.json
%.json: .FORCE
	@echo "* CURL -o '$@' '$(REL_$*)' #"
	@curl --compressed -#4Lfm5 -u "$(AUTH)" -o "$@" "$(REL_$*)" $$(test -s '$@' && echo -z '$@' ) \

bin/%: export VER = $$( jq -r '.[].tag_name' '$<' | sort -Vr | head -1 )
#bin/%: export VER = $$(grep -m1 'tag_name' '$<' | cut -d\" -f4 || head -1 '$<')
bin/%: %.json bin
	@echo            "* CURL -o '$@-$(OS)-${VER}.tmp' '$(URL_$*)' #"
	@curl --compressed -#4Lf -o "$@-$(OS)-${VER}.tmp" "$(URL_$*)" $$(test -s '$@' && echo -z "$@-$(OS)-${VER}" )
	@#echo "* IF size($@-$(OS)-${VER}.tmp)"  # "-> MV"    "$@-$(OS)-${VER}"{.tmp,}
	@#test -s        "$@-$(OS)-${VER}.tmp"   #&&   mv -vf "$@-$(OS)-${VER}"{.tmp,}  ||  rm -vf "$@-$(OS)-${VER}.tmp"
	@echo "* IF ' defined(EXT_$*) -> EXEC (EXT_$*)' #" # "IF '$(EXT_$*)' -> '$(EXT_$*)' #"
	@test -z  "$(EXT_$*)" || $(SHELL) -ec '($(EXT_$*)) && touch "$@-$(OS)-${VER}";'
	@echo "* IF '!defined(EXT_$*) -> LN  '$*-$(OS)-${VER}.tmp' -> '$@-$(OS)-${VER}' #"
	@test -n  "$(EXT_$*)" ||     ln -sfF "$*-$(OS)-${VER}.tmp"    "$@-$(OS)-${VER}" #
	@echo "* LN '$*-$(OS)-${VER}' -> '$@' #"
	@ln -sfF    "$*-$(OS)-${VER}"    "$@" #&& touch "$@-$(OS)-${VER}"
	@echo "* CHMOD '$@-$(OS)-${VER}' '$@' '$(ARCH)' #"
	@chmod a+rx  "$@-$(OS)-${VER}"
	@echo "* CHK: $@-$(OS)-${VER} --help"
	@#exec "$@-$(OS)-${VER}" --help 1>/dev/null

bin:
	mkdir -p "$@"

clean: prune
	rm -rf \
		$(addsuffix .json, $(TOOLS) ) \
		$(addprefix bin/, $(TOOLS) ) \
		bin/*.tmp
	find bin -type f -delete

prune:
	@echo Cleaning up broken links...
	@find bin -type l -exec sh -c 'test -e "$$1" || rm -vf "$$1";' -- {} \;

list:
	@echo $(TOOLS)
