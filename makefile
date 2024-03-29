#!/usr/bin/env make -f

TOOLS := \
	aws-iam-authenticator \
	caddy \
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
	etcdutl \
	gh \
	helm \
	infracost \
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
	nomad \
	rke \
	shellcheck \
	simple-ec2 \
	skaffold \
	stern \
	terraform \
	terraform-ls \
	terraform-lsp \
	traefik \
	typesense \
	vault \
	websocketd \
	yq \

OS       := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH     := $(shell uname -m)
TRIPLET  := $(shell cc -dumpmachine | sed 's/[0-9.]*$$//g')
GH_USER  := $(shell git config github.self.user || echo 1)
GH_TOKEN := $(shell git config github.self.pat  || echo 1)
AUTH     := $(GH_USER):$(GH_TOKEN)
SHELL    := /bin/bash

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
CPL_kn = bin/$* completion $(shell basename "$(SHELL)")

REL_k3s = https://api.github.com/repos/rancher/k3s/releases
URL_k3s = https://github.com/rancher/k3s/releases/download/${VER}/k3s$$(echo -$(ARCH) | grep -v amd64)

REL_k3d = https://api.github.com/repos/rancher/k3d/releases
URL_k3d = https://github.com/rancher/k3d/releases/download/${VER}/k3d-$(OS)-$(ARCH)
CPL_k3d = bin/$* completion $(shell basename "$(SHELL)")

REL_rke = https://api.github.com/repos/rancher/rke/releases
URL_rke = https://github.com/rancher/rke/releases/download/${VER}/rke_$(OS)-$(ARCH)

REL_helm = https://api.github.com/repos/helm/helm/releases
URL_helm = https://get.helm.sh/helm-${VER}-$(OS)-$(ARCH).tar.gz
EXT_helm = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar --strip=1 -OUxzf "$@-$(OS)-${VER}.tmp" "$(OS)-$(ARCH)/$*" > "$@-$(OS)-${VER}"
CPL_helm = bin/$* completion $(shell basename "$(SHELL)")

REL_kind = https://api.github.com/repos/kubernetes-sigs/kind/releases
URL_kind = https://kind.sigs.k8s.io/dl/${VER}/kind-$(OS)-$(ARCH)
CPL_kind = bin/$* completion $(shell basename "$(SHELL)")

REL_kops = https://api.github.com/repos/kubernetes/kops/releases
URL_kops = https://github.com/kubernetes/kops/releases/download/${VER}/kops-$(OS)-$(ARCH)
CPL_kops = bin/$* completion $(shell basename "$(SHELL)")

REL_krew = https://api.github.com/repos/kubernetes-sigs/krew/releases
URL_krew = https://github.com/kubernetes-sigs/krew/releases/download/${VER}/krew-$(OS)_$(ARCH).tar.gz
EXT_krew = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "./$*-$(OS)_$(ARCH)" > "$@-$(OS)-${VER}"

REL_kubens = https://api.github.com/repos/ahmetb/kubectx/releases
URL_kubens = https://github.com/ahmetb/kubectx/releases/download/${VER}/kubens

REL_kubectx = https://api.github.com/repos/ahmetb/kubectx/releases
URL_kubectx = https://github.com/ahmetb/kubectx/releases/download/${VER}/kubectx

REL_kubectl = https://storage.googleapis.com/kubernetes-release/release/stable.txt
REL_kubectl = https://api.github.com/repos/kubernetes/kubernetes/releases
URL_kubectl = https://storage.googleapis.com/kubernetes-release/release/${VER}/bin/$(OS)/$(ARCH)/kubectl
CPL_kubectl = bin/$* completion $(shell basename "$(SHELL)")

REL_kompose = https://api.github.com/repos/kubernetes/kompose/releases
URL_kompose = https://github.com/kubernetes/kompose/releases/download/${VER}/kompose-$(OS)-$(ARCH)
CPL_kompose = bin/$* completion $(shell basename "$(SHELL)")

REL_minikube = https://api.github.com/repos/kubernetes/minikube/releases
URL_minikube = https://storage.googleapis.com/minikube/releases/${VER}/minikube-$(OS)-$(ARCH)
URL_minikube = https://github.com/kubernetes/minikube/releases/download/${VER}/minikube-$(OS)-$(ARCH)
CPL_minikube = bin/$* completion $(shell basename "$(SHELL)")

REL_skaffold = https://api.github.com/repos/GoogleContainerTools/skaffold/releases
URL_skaffold = https://storage.googleapis.com/skaffold/releases/${VER}/skaffold-$(OS)-$(ARCH)
URL_skaffold = https://github.com/GoogleContainerTools/skaffold/releases/download/${VER}/skaffold-$(OS)-$(ARCH)
CPL_skaffold = bin/$* completion $(shell basename "$(SHELL)")

REL_stern = https://api.github.com/repos/stern/stern/releases
URL_stern = https://github.com/stern/stern/releases/download/${VER}/stern_$$(echo $(VER) | cut -b2-)_$(OS)_$(ARCH).tar.gz
EXT_stern = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"
CPL_stern = bin/$* --completion $(shell basename "$(SHELL)")
SRT_stern = id

REL_coredns = https://api.github.com/repos/coredns/coredns/releases
URL_coredns = https://github.com/coredns/coredns/releases/download/${VER}/coredns_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).tgz
EXT_coredns = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_eksctl = https://api.github.com/repos/weaveworks/eksctl/releases
URL_eksctl = https://github.com/weaveworks/eksctl/releases/download/${VER}/eksctl_$(shell uname -s)_$(ARCH).tar.gz
EXT_eksctl = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"
CPL_eksctl = bin/$* completion $(shell basename "$(SHELL)")

REL_kustomize = https://api.github.com/repos/kubernetes-sigs/kustomize/releases
URL_kustomize = https://github.com/kubernetes-sigs/kustomize/releases/download/${VER}/kustomize_$$(echo ${VER} | cut -d/ -f2)_$(OS)_$(ARCH).tar.gz
EXT_kustomize = file -bz --mime-type "$@-$(OS)-$$(echo ${VER} | cut -d/ -f2).tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-$$(echo ${VER} | cut -d/ -f2).tmp" "$*" > "$@-$(OS)-${VER}"
CPL_kustomize = bin/$* completion $(shell basename "$(SHELL)")

REL_kubefed = https://api.github.com/repos/kubernetes-sigs/kubefed/releases
URL_kubefed = https://github.com/kubernetes-sigs/kubefed/releases/download/${VER}/kubefedctl-$$(echo ${VER} | cut -b2-)-$(OS)-$(ARCH).tgz
EXT_kubefed = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"
CPL_kubefed = bin/$* completion $(shell basename "$(SHELL)")

REL_terraform = https://api.github.com/repos/hashicorp/terraform/releases
URL_terraform = https://releases.hashicorp.com/terraform/$$(echo ${VER} | cut -b2-)/terraform_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).zip
EXT_terraform = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q -e 'application/x-executable' -e 'application/.*zip.*' && unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"
CPL_terraform = echo complete -C "$(shell pwd)/bin/$*" "$*"

REL_terraform-ls = https://api.github.com/repos/hashicorp/terraform-ls/releases
URL_terraform-ls = https://releases.hashicorp.com/terraform-ls/$$(echo ${VER} | cut -b2-)/terraform-ls_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).zip
EXT_terraform-ls = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q -e 'application/x-executable' -e 'application/.*zip.*' && unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_terraform-lsp = https://api.github.com/repos/juliosueiras/terraform-lsp/releases
URL_terraform-lsp = https://github.com/juliosueiras/terraform-lsp/releases/download/${VER}/terraform-lsp_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).tar.gz
EXT_terraform-lsp = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_consul = https://api.github.com/repos/hashicorp/consul/releases
URL_consul = https://releases.hashicorp.com/consul/$$(echo ${VER} | cut -b2-)/consul_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).zip
EXT_consul = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q -e 'application/x-executable' -e 'application/.*zip.*' && unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"
#CPL_consul = bin/$* -autocomplete-install

REL_captain = https://api.github.com/repos/jenssegers/captain/releases
URL_captain = https://github.com/jenssegers/captain/releases/download/${VER}/captain-$(shell uname -s | sed 's/Darwin/osx/g' | sed 's/Linux/linux/g')

REL_deno = https://api.github.com/repos/denoland/deno/releases
URL_deno = https://github.com/denoland/deno/releases/download/${VER}/deno-$$(cc -dumpmachine | sed 's/[0-9.]*$$//g' | sed 's:-linux:-unknown-linux:g').zip
EXT_deno = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q -e 'application/x-sharedlib' -e 'application/.*zip.*' && unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"
CPL_deno = bin/$* completions $(shell basename "$(SHELL)")

REL_etcd = https://api.github.com/repos/etcd-io/etcd/releases
URL_etcd = https://github.com/etcd-io/etcd/releases/download/${VER}/etcd-${VER}-$(OS)-$(ARCH).$(shell uname -s | sed 's/Darwin/zip/g' | sed 's/Linux/tar.gz/g')
EXT_etcd = case $$(file -bz --mime-type "$@-$(OS)-${VER}.tmp") in \
	*tar*) tar -OUxzf "$@-$(OS)-${VER}.tmp" "etcd-${VER}-$(OS)-$(ARCH)/$*" > "$@-$(OS)-${VER}" ;; \
	*zip*) unzip -p "$@-$(OS)-${VER}.tmp"    "etcd-${VER}-$(OS)-$(ARCH)/$*" > "$@-$(OS)-${VER}" ;; \
	esac;

REL_etcdctl = $(REL_etcd)
URL_etcdctl = $(URL_etcd)
EXT_etcdctl = $(EXT_etcd)

REL_etcdutl = $(REL_etcd)
URL_etcdutl = $(URL_etcd)
EXT_etcdutl = $(EXT_etcd)

REL_copilot = https://api.github.com/repos/aws/copilot-cli/releases
URL_copilot = https://github.com/aws/copilot-cli/releases/download/${VER}/copilot-$(OS)$(shell uname -s | grep -qEi linux && echo -$(ARCH))-${VER}
CPL_copilot = bin/$* completion $(shell basename "$(SHELL)")

REL_ecs-cli = https://api.github.com/repos/aws/amazon-ecs-cli/releases
URL_ecs-cli = https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-$(OS)-$(ARCH)-${VER}

REL_ctop = https://api.github.com/repos/bcicen/ctop/releases
URL_ctop = https://github.com/bcicen/ctop/releases/download/${VER}/ctop-$$(echo ${VER} | tr -d v)-$(OS)-$(ARCH)

REL_shellcheck = https://api.github.com/repos/koalaman/shellcheck/releases
URL_shellcheck = https://github.com/koalaman/shellcheck/releases/download/${VER}/shellcheck-${VER}.$(OS).$(shell uname -m).tar.xz
EXT_shellcheck = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar --strip=1 -OUxf "$@-$(OS)-${VER}.tmp" "shellcheck-${VER}/$*" > "$@-$(OS)-${VER}"

REL_websocketd = https://api.github.com/repos/joewalnes/websocketd/releases
URL_websocketd = https://github.com/joewalnes/websocketd/releases/download/${VER}/websocketd-$$(echo ${VER} | cut -b2-)-$(OS)_$(ARCH).zip
EXT_websocketd = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q -e 'application/x-executable' -e 'application/.*zip.*' && unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_jq = https://api.github.com/repos/stedolan/jq/releases
URL_jq = https://github.com/stedolan/jq/releases/download/${VER}/jq-$(shell echo $(OS) | grep -i linux64 || echo osx-$(ARCH))

REL_doctl = https://api.github.com/repos/digitalocean/doctl/releases
URL_doctl = https://github.com/digitalocean/doctl/releases/download/${VER}/doctl-$$(echo ${VER} | cut -b2-)-$(OS)-$(ARCH).tar.gz
EXT_doctl = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"
CPL_doctl = bin/$* completion $(shell basename "$(SHELL)")

REL_civo = https://api.github.com/repos/civo/cli/releases
URL_civo = https://github.com/civo/cli/releases/download/${VER}/civo-$$(echo ${VER} | cut -b2-)-$(OS)-$(ARCH).tar.gz
EXT_civo = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"
CPL_civo = bin/$* completion $(shell basename "$(SHELL)")

REL_traefik = https://api.github.com/repos/traefik/traefik/releases
URL_traefik = https://github.com/traefik/traefik/releases/download/${VER}/traefik_${VER}_$(OS)_$(ARCH).tar.gz
EXT_traefik = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"
SRT_traefik = tag_name

REL_simple-ec2 = https://api.github.com/repos/awslabs/aws-simple-ec2-cli/releases
URL_simple-ec2 = https://github.com/awslabs/aws-simple-ec2-cli/releases/download/${VER}/simple-ec2-$(OS)-$(ARCH)

REL_vault = https://api.github.com/repos/hashicorp/vault/releases
URL_vault = https://releases.hashicorp.com/vault/$$(echo ${VER} | cut -b2-)/vault_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).zip
EXT_vault = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q -e 'application/x-executable' -e 'application/.*zip.*' && unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"
#CPL_vault = bin/$* -autocomplete-install $(shell basename "$(SHELL)")

REL_direnv = https://api.github.com/repos/direnv/direnv/releases
URL_direnv = https://github.com/direnv/direnv/releases/download/${VER}/direnv.$(OS)-$(ARCH)
CPL_direnv = bin/$* hook $(shell basename "$(SHELL)")

REL_calicoctl = https://api.github.com/repos/projectcalico/calicoctl/releases
URL_calicoctl = https://github.com/projectcalico/calicoctl/releases/download/${VER}/calicoctl-$(OS)-$(ARCH)

REL_regctl = https://api.github.com/repos/regclient/regclient/releases
URL_regctl = https://github.com/regclient/regclient/releases/download/${VER}/regctl-$(OS)-$(ARCH)
CPL_regctl = bin/$* completion $(shell basename "$(SHELL)")

REL_k9s = https://api.github.com/repos/derailed/k9s/releases
URL_k9s = https://github.com/derailed/k9s/releases/download/${VER}/k9s_$(shell uname -s)_$(shell uname -m).tar.gz
EXT_k9s = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_yq = https://api.github.com/repos/mikefarah/yq/releases
URL_yq = https://github.com/mikefarah/yq/releases/download/${VER}/yq_$(OS)_$(ARCH)
CPL_yq = bin/$* shell-completion $(shell basename "$(SHELL)")

REL_caddy = https://api.github.com/repos/caddyserver/caddy/releases
URL_caddy = https://github.com/caddyserver/caddy/releases/download/${VER}/caddy_$$(echo ${VER} | cut -b2-)_$$(echo ${OS} | sed s:darwin:mac:g)_$(ARCH).tar.gz
EXT_caddy = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_typesense = https://api.github.com/repos/typesense/typesense/releases
URL_typesense = https://dl.typesense.org/releases/$$(echo ${VER} | cut -b2-)/typesense-server-$$(echo ${VER} | cut -b2-)-$(OS)-$(ARCH).tar.gz
EXT_typesense = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*-server" > "$@-$(OS)-${VER}"
CPL_typesense = echo : bin/$* completion $(shell basename "$(SHELL)")

REL_nomad = https://api.github.com/repos/hashicorp/nomad/releases
URL_nomad = https://releases.hashicorp.com/nomad/$$(echo ${VER} | cut -b2-)/nomad_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).zip
EXT_nomad = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q -e 'application/x-executable' -e 'application/.*zip.*' && unzip -p "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"
CPL_nomad = echo complete -C "$(shell pwd)/bin/$*" "$*"

REL_aws-iam-authenticator = https://api.github.com/repos/kubernetes-sigs/aws-iam-authenticator/releases
URL_aws-iam-authenticator = https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/${VER}/aws-iam-authenticator_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH)

REL_infracost = https://api.github.com/repos/infracost/infracost/releases
URL_infracost = https://github.com/infracost/infracost/releases/download/${VER}/infracost-$(OS)-$(ARCH).tar.gz
EXT_infracost = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar -OUxzf "$@-$(OS)-${VER}.tmp" "$*-$(OS)-$(ARCH)" > "$@-$(OS)-${VER}"

REL_gh = https://api.github.com/repos/cli/cli/releases
URL_gh = https://github.com/cli/cli/releases/download/${VER}/gh_$$(echo ${VER} | cut -b2-)_$$(echo $(OS) | sed s:darwin:macOS:g)_$(ARCH).tar.gz
EXT_gh = file -bz --mime-type "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' && tar --strip=1 -OUxzf "$@-$(OS)-${VER}.tmp" "gh_$$(echo ${VER} | cut -b2-)_$$(echo $(OS) | sed s:darwin:macOS:g)_$(ARCH)/bin/$*" > "$@-$(OS)-${VER}"
CPL_gh = bin/$* completion -s $(shell basename "$(SHELL)")

export COLUMNS = 50

all: $(addprefix bin/, $(TOOLS) ) showbanner
	# That is all...
	# PS: You can try 'competions' and 'extras'

showbanner:
	@echo "$(PATH)" | tr : '\n' | grep -qEi "$(shell realpath "$(CURDIR)/bin")" || (true \
		&& echo '***********************************************************' \
		&& echo '=====> ADD $(PWD)/bin or $(CURDIR)/bin to $$PATH !!! <=====' \
		&& echo '***********************************************************' \
	)

completions: $(addsuffix .cpl, $(TOOLS) )
	@ : echo echo completions loaded $(shell pwd)

extras: bin/krew
	$< update
	$< upgrade
	$< install cert-manager
	$< install ctx
	$< install flame
	$< install get-all
	$< install gke-credentials
	$< install graph
	$< install grep
	$< install images
	$< install ingress-nginx
	$< install konfig
	$< install krew
	$< install ns
	$< install tree
	$< install tree
	$< install whoami

.FORCE:
.PRECIOUS: %.json %.txt
%.json: .FORCE
	@echo "# CURL -o '$@' '$(REL_$*)' #"
	@curl --compressed -#4Lfm5 -u "$(AUTH)" -o "$@" "$(REL_$*)" $$(test -s '$@' && echo -z '$@' ) \

#bin/%: export VER = $$( jq -r "sort_by(.[\$$ARGS.positional[0] // \"published_at\"])[-1].tag_name" '$<' --args "$(SRT_$*)")
#bin/%: export VER = $$(grep -m1 'tag_name' '$<' | cut -d\" -f4 || head -1 '$<')
%.txt: %.json
	@jq -r 'if type == "object" then . else (sort_by(.[$$ARGS.positional[0] // "published_at"])[-1]) end' '$<' --args $(SRT_$*) \
	| tee "$@" >/dev/null

bin/%: export VER = $$(jq -r '.tag_name' '$<')
bin/%: %.txt bin
	@echo            "# CURL -o '$@-$(OS)-${VER}.tmp' '$(URL_$*)' #"
	@curl --compressed -#4Lf -o "$@-$(OS)-${VER}.tmp" "$(URL_$*)" $$(test -s '$@' && echo -z "$@-$(OS)-${VER}" )
	@#echo "# IF size($@-$(OS)-${VER}.tmp)"  # "-> MV"    "$@-$(OS)-${VER}"{.tmp,}
	@#test -s        "$@-$(OS)-${VER}.tmp"   #&&   mv -vf "$@-$(OS)-${VER}"{.tmp,}  ||  rm -vf "$@-$(OS)-${VER}.tmp"
	@echo "# IF ' defined(EXT_$*) -> EXEC (EXT_$*)' #" # "IF '$(EXT_$*)' -> '$(EXT_$*)' #"
	@test -z  "$(EXT_$*)" || $(SHELL) -xec '($(EXT_$*)) && touch "$@-$(OS)-${VER}";'
	@echo "# IF '!defined(EXT_$*) -> LN  '$*-$(OS)-${VER}.tmp' -> '$@-$(OS)-${VER}' #"
	@test -n  "$(EXT_$*)" ||     ln -sfF "$*-$(OS)-${VER}.tmp"    "$@-$(OS)-${VER}" #
	@echo "# LN '$*-$(OS)-${VER}' -> '$@' #"
	@ln -sfF    "$*-$(OS)-${VER}"    "$@" #&& touch "$@-$(OS)-${VER}"
	@echo "# CHMOD '$@-$(OS)-${VER}' '$@' '$(ARCH)' #"
	@chmod a+rx  "$@-$(OS)-${VER}"
	@echo "# CHK: $@-$(OS)-${VER} --help"
	@#exec "$@-$(OS)-${VER}" --help 1>/dev/null

bin:
	mkdir -p "$@"

%.cpl: # bin/%
	@test -z "$(CPL_$*)" || "$(SHELL)" -ec '$(CPL_$*)'

clean:
	@find bin -type f -name '*.tmp' -delete
	@echo $(TOOLS) | xargs -n1 -- bash -c 'find bin -type f -name "$$1*" | grep -v $$(basename $$(realpath bin/$$1))- | xargs rm -vf' --

remove: prune
	rm -rf \
		$(addsuffix .json, $(TOOLS) ) \
		$(addsuffix .txt, $(TOOLS) ) \
		$(addprefix bin/, $(TOOLS) ) \
		bin/*.tmp
	find bin -type f -delete

prune:
	@echo Cleaning up broken links...
	@find bin -type l -exec sh -c 'test -e "$$1" || rm -vf "$$1";' -- {} \;

list:
	@echo $(TOOLS) | xargs -n1 -- echo
