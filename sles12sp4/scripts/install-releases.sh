#!/bin/bash

if [ ! -L /etc/products.d/baseproduct ]; then
    if [ -f /etc/products.d/SLES.prod ]; then
        ln -s /etc/products.d/SLES.prod /etc/products.d/baseproduct
    fi
fi
