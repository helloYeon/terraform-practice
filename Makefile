BUCKET_NAME = hoge
REGION      = ap-northeast-1
CD          = [[ -d envs/${ENV} ]] && cd envs/${ENV}
ENV         = $1
ARGS        = $2

tf-init:
	@${CD} && \
		terraform init ${ARGS}

tf-plan:
	@${CD} && \
		terraform plan ${ARGS}

tf-apply:
	@${CD} && \
		terraform apply ${ARGS}

tf:
	@${CD} && \
		terraform ${ARGS}

remote-disable:
	@${CD} && \
		terraform remote config \
		-disable