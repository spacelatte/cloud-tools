#!/usr/bin/env make -f

TOOLS := \
	kn \
	k3d \
	rke \
	kind \
	kops \
	krew \
	kubens \
	kubectx \
	kubectl \
	kompose \
	minikube \
	skaffold \
	stern \
	helm \
	coredns \
	eksctl \

OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)
AUTH := $(shell test -e .auth && cat .auth || echo)

ifeq ($(ARCH),x86_64)
	ARCH := amd64
endif

ifeq ($(ARCH),armv7l)
	ARCH := armhf
endif

REL_kn = https://api.github.com/repos/knative/client/releases/tags/v0.18.1
URL_kn = https://github.com/knative/client/releases/download/${VER}/kn-$(OS)-$(ARCH)

# REL_k3s = https://api.github.com/repos/rancher/k3s/releases/latest
# URL_k3s = https://github.com/rancher/k3s/releases/download/${VER}/k3s-$(ARCH)

REL_k3d = https://api.github.com/repos/rancher/k3d/releases/latest
URL_k3d = https://github.com/rancher/k3d/releases/download/${VER}/k3d-$(OS)-$(ARCH)

REL_rke = https://api.github.com/repos/rancher/rke/releases/latest
URL_rke = https://github.com/rancher/rke/releases/download/${VER}/rke_$(OS)-$(ARCH)

REL_helm = https://api.github.com/repos/helm/helm/releases/latest
URL_helm = https://get.helm.sh/helm-${VER}-$(OS)-$(ARCH).tar.gz
EXT_helm = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; \
	tar --strip=1 -OUxzvf "$@-$(OS)-${VER}.tmp" "$(OS)-$(ARCH)/$*" > "$@-$(OS)-${VER}"

REL_kind = https://api.github.com/repos/kubernetes-sigs/kind/releases/latest
URL_kind = https://kind.sigs.k8s.io/dl/${VER}/kind-$(OS)-$(ARCH)

REL_kops = https://api.github.com/repos/kubernetes/kops/releases/latest
URL_kops = https://github.com/kubernetes/kops/releases/download/${VER}/kops-$(OS)-$(ARCH)

REL_krew = https://api.github.com/repos/kubernetes-sigs/krew/releases/latest
URL_krew = https://github.com/kubernetes-sigs/krew/releases/download/${VER}/krew.tar.gz
EXT_krew = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; \
	tar -OUxzvf "$@-$(OS)-${VER}.tmp" "$*-$(OS)_$(ARCH)" > "$@-$(OS)-${VER}"

REL_kubens = https://api.github.com/repos/ahmetb/kubectx/releases/latest
URL_kubens = https://github.com/ahmetb/kubectx/releases/download/${VER}/kubens

REL_kubectx = https://api.github.com/repos/ahmetb/kubectx/releases/latest
URL_kubectx = https://github.com/ahmetb/kubectx/releases/download/${VER}/kubectx

REL_kubectl = https://storage.googleapis.com/kubernetes-release/release/stable.txt
REL_kubectl = https://api.github.com/repos/kubernetes/kubernetes/releases/latest
URL_kubectl = https://storage.googleapis.com/kubernetes-release/release/${VER}/bin/$(OS)/$(ARCH)/kubectl

REL_kompose = https://api.github.com/repos/kubernetes/kompose/releases/latest
URL_kompose = https://github.com/kubernetes/kompose/releases/download/${VER}/kompose-$(OS)-$(ARCH)

REL_minikube = https://api.github.com/repos/kubernetes/minikube/releases/latest
URL_minikube = https://storage.googleapis.com/minikube/releases/${VER}/minikube-$(OS)-$(ARCH)
URL_minikube = https://github.com/kubernetes/minikube/releases/download/${VER}/minikube-$(OS)-$(ARCH)

REL_skaffold = https://api.github.com/repos/GoogleContainerTools/skaffold/releases/latest
URL_skaffold = https://storage.googleapis.com/skaffold/releases/${VER}/skaffold-$(OS)-$(ARCH)
URL_skaffold = https://github.com/GoogleContainerTools/skaffold/releases/download/${VER}/skaffold-$(OS)-$(ARCH)

REL_stern = https://api.github.com/repos/wercker/stern/releases/latest
URL_stern = https://github.com/wercker/stern/releases/download/${VER}/stern_$(OS)_$(ARCH)

REL_coredns = https://api.github.com/repos/coredns/coredns/releases/latest
URL_coredns = https://github.com/coredns/coredns/releases/download/${VER}/coredns_$$(echo ${VER} | cut -b2-)_$(OS)_$(ARCH).tgz
EXT_coredns = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; \
	tar -OUxzvf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

REL_eksctl = https://api.github.com/repos/weaveworks/eksctl/releases/latest
URL_eksctl = https://github.com/weaveworks/eksctl/releases/download/${VER}/eksctl_$(shell uname -s)_$(ARCH).tar.gz
EXT_eksctl = file -bzI "$@-$(OS)-${VER}.tmp" | grep -q 'application/x-tar' || exit 0; \
	tar -OUxzvf "$@-$(OS)-${VER}.tmp" "$*" > "$@-$(OS)-${VER}"

# https://github.com/kubernetes-sigs/kustomize/releases/download/api%2Fv0.5.1/api_v0.5.1_darwin_amd64.tar.gz
# https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.8.1/kustomize_v3.8.1_darwin_amd64.tar.gz
# https://github.com/kubernetes-sigs/kubefed/releases/download/v0.3.1/kubefedctl-0.3.1-darwin-amd64.tgz

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
	@curl --compressed -#4Lfm5 -o "$@" "$(REL_$*)" $$(test -s '$@' && echo -z '$@' ) $(AUTH)

bin/%: export VER = $$(grep 'tag_name' '$<' | cut -d\" -f4 || head -1 '$<' )
bin/%: %.json bin
	@echo            "* CURL -o '$@-$(OS)-${VER}.tmp' '$(URL_$*)' #"
	@curl --compressed -#4Lf -o "$@-$(OS)-${VER}.tmp" "$(URL_$*)" $$(test -s '$@' && echo -z "$@-$(OS)-${VER}" )
	@#echo "* IF size($@-$(OS)-${VER}.tmp)"  # "-> MV"    "$@-$(OS)-${VER}"{.tmp,}
	@#test -s        "$@-$(OS)-${VER}.tmp"   #&&   mv -vf "$@-$(OS)-${VER}"{.tmp,}  ||  rm -vf "$@-$(OS)-${VER}.tmp"
	@echo "* IF ' defined(EXT_$*) -> EXEC (EXT_$*)' #" # "IF '$(EXT_$*)' -> '$(EXT_$*)' #"
	@test -z  "$(EXT_$*)" || $(SHELL) -ec '($(EXT_$*)) && touch "$@-$(OS)-${VER}";'
	@echo "* IF '!defined(EXT_$*) -> LN" "$@-$(OS)-${VER}"{.tmp,}
	@test -n  "$(EXT_$*)" ||     ln -sfF "$*-$(OS)-${VER}"{.tmp,}
	@echo "* LN '$@-$(OS)-${VER}' -> '$@' #"
	@ln -sfF    "$*-$(OS)-${VER}"    "$@" #&& touch "$@-$(OS)-${VER}"
	@echo "* CHMOD '$@-$(OS)-${VER}' '$@' '$(ARCH)' #"
	@chmod a+rx  "$@-$(OS)-${VER}"
	@echo "* CHK: $@-$(OS)-${VER} --help"
	@exec "$@-$(OS)-${VER}" --help 1>/dev/null

bin:
	mkdir -p "$@"

clean:
	rm -rf $(addprefix bin/, $(TOOLS) ) $(addsuffix .json, $(TOOLS) )
