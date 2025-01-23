PROJECT_NAME = yeon
REGION       = us-east-2
CD           = [[ -d envs/${ENV} ]] && cd envs/${ENV}
ENV          = $1
ARGS         = $2

tf:
	@${CD} && \
		terraform ${ARGS}

remote-enable:
	@${CD} && \
		terraform init -migrate-state\
		-backend-config='bucket=${PROJECT_NAME}-${ENV}-terraform' \
		-backend-config='key=terraform.tfstate' \
		-backend-config='region=${REGION}'
