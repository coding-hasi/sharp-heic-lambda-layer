FROM --platform=linux/x86_64 public.ecr.aws/lambda/nodejs:16

# Update the package manager
RUN yum update -y

# Install necessary tools
RUN yum install -y unzip yum-plugin-ovl autoconf aclocal automake libtool gcc-c++ python3

RUN yum groupinstall "Development Tools" -y

# Download the SAM CLI zip file
RUN curl -o aws-sam-cli.zip -L https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip

# Unzip the SAM CLI
RUN unzip aws-sam-cli.zip -d sam-installation

RUN ./sam-installation/install

# Clean up: remove the zip file
RUN rm aws-sam-cli.zip && rm -rf sam-installation

# Display SAM CLI version for verification
RUN sam --version

COPY . ${LAMBDA_TASK_ROOT}

RUN npm run build

# Copy function code
COPY examples/src/index.js ${LAMBDA_TASK_ROOT}/app.js

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)

CMD [ "app.handler" ]