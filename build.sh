#!/bin/bash

function exit_on_error()
{
    message=$1
    echo $message;

    exit 1;
}

for name in chromium-nginx php-grpc php-zts-grpc php-grpc-free-unit phpfpm-grpc php-free-unit php-grpc-roadrunner php-grpc-frankenphp
do
    image="alpine-${name}"

    echo ""
    echo "Building image ${image}..."
    echo ""
    docker build --no-cache -t lagdo/${image} ./${image} || exit_on_error "Unable to build image ${image}."

    echo ""
    echo "Publishing image ${image}..."
    echo ""
    docker push lagdo/${image}
done
